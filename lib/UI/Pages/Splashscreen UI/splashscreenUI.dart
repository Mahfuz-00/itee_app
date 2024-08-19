import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itee_exam_app/UI/Pages/Dashboard%20UI/dashboardUI.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Data/Data Sources/API Service (Dashboard)/apiservicedashboard.dart';
import '../../../Data/Data Sources/API Service (Profile)/apiserviceprofile.dart';
import '../../../Data/Models/profilemodel.dart';
import '../../Bloc/auth_cubit.dart';
import '../Login UI/loginUI.dart';
import '../Sign Up UI/signupUI.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController animationController;
  late Animation<double> FadeAnimation;
  late Animation<Offset> SlideAnimation;
  late Animation<Offset> animatedpadding;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    SlideAnimation = Tween(begin: const Offset(0, 3), end: const Offset(0, 0))
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOutCirc));
    FadeAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    animatedpadding = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.easeIn));

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        animationController.forward();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    shouldRefresh: true,
                  )),
        );
      }
    });

    WidgetsBinding.instance.addObserver(this);
    _checkAuthentication();
  }

  @override
  void dispose() {
    animationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAuthentication(); // Check token when app is resumed
    }
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Checking Auth Token :: ${token}');
    final authCubit = context.read<AuthCubit>();
    final state = context.read<AuthCubit>().state;

    if (token != null) {
      final apiService = await DashboardAPIService.create();
      final Map<String, dynamic> dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData.isEmpty) {
        await prefs.remove('token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
      bool auth = dashboardData['authenticated'];
      print('Authen: $auth');
      bool isValid = auth;

      if (isValid) {
        final profileData = await APIProfileService().fetchUserProfile(token);
        final userProfile = UserProfile.fromJson(profileData);

        // Emit Authenticated State
        authCubit.emit(AuthAuthenticated(
          userProfile: userProfile,
          token: token,
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    shouldRefresh: true,
                  )),
        );
      } else {
        await prefs.remove('token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } else {
      await prefs.remove('token');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(
                  shouldRefresh: true,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(246, 246, 246, 255),
            Color.fromRGBO(246, 246, 246, 255)
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                'Assets/Images/BCC-Logo.png',
              ),
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            SlideTransition(
              position: animatedpadding,
              child: const Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage(
                        'Assets/Images/ITEE_logo.png',
                      ),
                      width: 200,
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Stack(
              //fit: StackFit.expand,
              alignment: Alignment.bottomCenter,
              children: [
                FadeTransition(
                  opacity: FadeAnimation,
                  child: const Image(
                    image: AssetImage('Assets/Images/Powered by TNS.png'),
                    height: 100,
                    width: 150,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                /* SlideTransition(
                  position: SlideAnimation,
                  */ /*CurvedAnimation(
                    parent: animationController,
                    curve: Curves.easeInOutCirc, // Adjust values for desired timing
                  ).drive(Tween<Offset>(
                    begin: Offset(0, 2), // Start beyond the bottom edge
                    end: Offset(0, 0),
                  )),*/ /*
                  //position: SlideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              //side: BorderSide(color: Colors.black, width: 2),
                            ),
                            //elevation: 3,
                            fixedSize: Size(screenWidth*0.9, 70),
                          ),
                          child: const Text('Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'default',
                              ))),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Signup()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.black, width: 2),
                            ),
                            //elevation: 3,
                            fixedSize: Size(screenWidth*0.9, 70),
                          ),
                          child: const Text('Register',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'default',
                              )))
                    ],
                  ),
                ),*/
              ],
            ),
          ],
        ),
      ),
    );
  }
}
