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

/// A [SplashScreenUI] that handles the initial loading and authentication
/// checking for the app. It displays a logo and transitions to the
/// dashboard or login screen based on the authentication status of the user.
///
/// This widget uses [AnimationController] for fade and slide animations
/// and listens for app lifecycle changes to re-check authentication
/// when the app is resumed.
///
/// - **Fields:**
///   - [animationController]: Controls the animations for the splash screen.
///   - [FadeAnimation]: Controls the fade animation effect.
///   - [SlideAnimation]: Controls the slide animation effect.
///   - [animatedpadding]: Controls the padding animation effect.
///
/// - **Methods:**
///   - `didChangeAppLifecycleState`: Checks authentication when the app is resumed.
///   - `_checkAuthentication`: Checks if the user is authenticated and navigates accordingly.
class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController animationController;
  late Animation<double> FadeAnimation;
  late Animation<Offset> SlideAnimation;
  late Animation<Offset> animatedpadding;

  @override
  void initState() {
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
        WidgetsBinding.instance.addObserver(this);
        _checkAuthentication();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DashboardUI(
                    shouldRefresh: true,
                  )),
        );
      }
    });
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
      _checkAuthentication();
    }
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print('Checking Auth Token :: ${token}');
    final authCubit = context.read<AuthCubit>();

    if (token != null) {
      final apiService = await DashboardAPIService.create();
      final Map<String, dynamic> dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData.isEmpty) {
        await prefs.remove('token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginUI()),
        );
      }
      bool auth = dashboardData['authenticated'];
      print('Authen: $auth');
      bool isValid = auth;

      if (isValid) {
        final profileData = await ProfileAPIService().fetchUserProfile(token);
        final userProfile = UserProfile.fromJson(profileData);

        authCubit.emit(AuthAuthenticated(
          userProfile: userProfile,
          token: token,
        ));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardUI(
                  shouldRefresh: true,
                )),
          );
        }
      } else {
        await prefs.remove('token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginUI()),
        );
      }
    } else {
      await prefs.remove('token');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardUI(
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
