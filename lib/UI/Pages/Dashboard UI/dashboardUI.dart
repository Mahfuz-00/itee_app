import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:itee_exam_app/UI/Pages/B-Jet%20Details%20UI/B-jetDetailsUI.dart';
import 'package:itee_exam_app/UI/Pages/Exam%20Details%20UI/examDetailsUI.dart';
import 'package:itee_exam_app/UI/Pages/ITEE%20Details%20UI/iteedetailsui.dart';
import 'package:itee_exam_app/UI/Pages/ITEE%20Training%20Program%20Details%20UI/trainingprogramdetails.dart';
import 'package:itee_exam_app/UI/Widgets/listTileDashboardImages.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Admit Card)/apiserviceAdmitCard.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiservicedashboard.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../../Data/Data Sources/API Service (Result)/apiserviceResult.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/appilcationcard.dart';
import '../../Widgets/bookcard.dart';
import '../../Widgets/examcard.dart';
import '../../Widgets/listTileDashboard.dart';
import '../../Widgets/listTileDashboardApplication.dart';
import '../../Widgets/listTileDashboardExam.dart';
import '../../Widgets/listTileNotice.dart';
import '../AdmitCard UI/downloadadmitcard.dart';
import '../Course Outline UI/courseOutlineUI.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Registation UI/registrationvenue.dart';
import '../Result UI/resultUI.dart';
import '../Syllabus UI/syllabusUI.dart';

class Dashboard extends StatefulWidget {
  final bool shouldRefresh;

  const Dashboard({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late String userName = '';
  late String photoUrl = '';
  late bool auth = false;
  bool _isFetched = false;
  bool _isFetchedResult = false;
  bool _pageLoading = true;
  bool _isLoading = false;
  bool _isFetchedPrint = false;
  late String link = "";
  List<String> notifications = [];
  List<Widget> _examFeeWidgets = [];
  List<Widget> _applicationWidgets = [];
  List<Widget> _bookWidgets = [];
  List<Widget> _noticeWidgets = [];
  List<Widget> _eventWidgets = [];
  List<Widget> _programWidgets = [];
  List<Widget> _bjetWidgets = [];
  late int resultcheck = 2;
  late int admitcardcheck = 2;

  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';
      photoUrl = 'https://bcc.touchandsolve.com' + photoUrl;
      print('User Name: $userName');
      print('Photo URL: $photoUrl');
      print('User profile got it!!!!');
    });
  }

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await DashboardAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic> dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      auth = dashboardData['authenticated'];
      print(auth);

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        return;
      }

      // Set isLoading to true while fetching data
      setState(() {
        _isLoading = true;
      });

      final List<Widget> applicationWidgets;

      if (auth == true) {
        notifications = List<String>.from(records['notifications'] ?? []);
        final List<dynamic> applications = records['my_applications'];
        print('Applications: $applications');
        applicationWidgets = applications.map((item) {
          int index = applications.indexOf(item);
          return ApplicationItemTemplate(
            name: item['exam_type'],
            Catagories: item['exam_category'],
            result: item['result'],
            payment: item['payment'],
            admitcard: item['admit_card'],
          );
        }).toList();

        setState(() {
          _applicationWidgets = applicationWidgets;
        });
      }
/*      resultcheck = records['result'];
      admitcardcheck = records['admit_card'];

      print('Result check : $resultcheck');
      print('Admit Card : $admitcardcheck');*/
      // Simulate fetching data for 5 seconds
      await Future.delayed(Duration(seconds: 1));

      final List<dynamic> noticeData = records['notices'] ?? [];
      final List<dynamic> examFeesData = records['examFees'] ?? [];
      final List<dynamic> booksData = records['books'] ?? [];
      final List<dynamic> EventData = records['recentEvents'] ?? [];
      final List<dynamic> ProgramData = records['programs'] ?? [];
      final List<dynamic> BjetData = records['bjetEvents'] ?? [];
      print('Notices : $noticeData');
      print('Exam Fees : $examFeesData');
      print('Books : $booksData');
      print('Events : $EventData');
      print('Programs : $ProgramData');
      print('BJet : $BjetData');

      // Map exam fees to widgets
      final List<Widget> noticeWidgets = noticeData.map((item) {
        int index = examFeesData.indexOf(item);
        return ItemTemplateNotice(
          notice: item['message'],
        );
      }).toList();
      // Map exam fees to widgets
      final List<Widget> examFeeWidgets = examFeesData.map((item) {
        int index = examFeesData.indexOf(item);
        return ExamItemTemplate(
          name: item['exam_type'],
          Catagories: item['exam_category'],
          price: item['fees'],
          Details: item['exam_details'],
          typeID: item['exam_type_id'],
          CatagoryID: item['exam_category_id'],
        );
      }).toList();

      // Map books to widgets
      final List<Widget> bookWidgets = booksData.map((item) {
        int index = booksData.indexOf(item);
        return ItemTemplate(
          name: item['name'],
          price: item['price'],
        );
      }).toList();

      final List<Widget> eventWidgets = EventData.map((item) {
        int index = EventData.indexOf(item);
        return ItemTemplateImages(
          images: item['image'],
          label: item['label'],
        );
      }).toList();

      final List<Widget> programWidgets = ProgramData.map((item) {
        int index = ProgramData.indexOf(item);
        return ItemTemplateImages(
          images: item['image'],
          label: item['label'],
        );
      }).toList();

      final List<Widget> bjetWidgets = BjetData.map((item) {
        int index = BjetData.indexOf(item);
        return ItemTemplateImages(
          images: item['image'],
          label: item['label'],
        );
      }).toList();

      setState(() {
        _examFeeWidgets = examFeeWidgets;
        _bookWidgets = bookWidgets;
        _noticeWidgets = noticeWidgets;
        _eventWidgets = eventWidgets;
        _programWidgets = programWidgets;
        _bjetWidgets = bjetWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetched = true;
      // Handle error as needed
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!_isFetched) {
      fetchConnectionRequests();
    }
    loadUserProfile();
    Future.delayed(Duration(seconds: 2), () {
      if (widget.shouldRefresh) {
        setState(() {
          _pageLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return _pageLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              // Show circular loading indicator while waiting
              child: CircularProgressIndicator(),
            ),
          )
        : BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated){
          final userProfile = state.userProfile;
          return InternetChecker(
            child: PopScope(
              canPop: false,
              child: Scaffold(
                key: _scaffoldKey,
                appBar: auth
                    ? AppBar(
                  backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                  titleSpacing: 5,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'default',
                    ),
                  ),
                  actions: [
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            _showNotificationsOverlay(context);
                            var notificationApiService =
                            await NotificationReadApiService.create();
                            notificationApiService.readNotification();
                          },
                        ),
                        if (notifications.isNotEmpty)
                          Positioned(
                            right: 11,
                            top: 11,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${notifications.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
                    : AppBar(
                  backgroundColor: Colors.white,
                  titleSpacing: 5,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      Image(
                        image: AssetImage(
                          'Assets/Images/BCC-Logo.png',
                        ),
                        height: 40,
                      ),
                      Image(
                        image: AssetImage(
                          'Assets/Images/ITEC-Logo.png',
                        ),
                        height: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        },
                        child: Text(
                          'Login/Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 162, 222, 1),
                            fontFamily: 'default',
                          ),
                        ))
                  ],
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 162, 222, 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60, // Adjust width as needed
                              height: 60, // Adjust height as needed
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider('https://bcc.touchandsolve.com${userProfile.photo}'),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              userProfile.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text('Home',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Dashboard(
                                    shouldRefresh: true,
                                  ))); // Close the drawer
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Syllabus',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Syllabus()));
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Course Outline',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CourseOutline()));
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Logout',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () async {
                          Navigator.pop(context);
                          const snackBar = SnackBar(
                            content: Text(
                                'Logging out'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          /*   // Clear user data from SharedPreferences
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('userName');
                                await prefs.remove('organizationName');
                                await prefs.remove('photoUrl');*/
                          // Create an instance of LogOutApiService
                          var logoutApiService =
                          await LogOutApiService.create();

                          // Wait for authToken to be initialized
                          logoutApiService.authToken;

                          // Call the signOut method on the instance
                          if (await logoutApiService.signOut()) {
                            const snackBar = SnackBar(
                              content: Text(
                                  'Logged out'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            // Call logout method in AuthCubit/AuthBloc
                            context.read<AuthCubit>().logout();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Login())); // Close the drawer
                          }
                        },
                      ),
                      Divider(),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: SafeArea(
                    child: Container(
                      //height: screenHeight,
                      color: Colors.grey[100],
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Welcome to ITEE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(0, 162, 222, 1),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Center(
                              child: Text(
                                'A Local & Internally recognized IT Skills Training & Exam Center',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  letterSpacing: 1.1,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          if (auth == true) ...[
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: screenWidth * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                        width: screenWidth * 0.9,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(0, 162, 222, 1),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'My Application(s)',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'default',
                                            ),
                                          ),
                                        )),
                                    Container(
                                      height: 250,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: PageView.builder(
                                        controller:
                                        PageController(viewportFraction: 1),
                                        itemCount: _applicationWidgets.length,
                                        itemBuilder: (context, index) {
                                          ApplicationItemTemplate Applicant =
                                          _applicationWidgets[index]
                                          as ApplicationItemTemplate;
                                          return ApplicationCard(
                                            examName: Applicant.name,
                                            examCatagories:
                                            Applicant.Catagories,
                                            Payment: Applicant.payment,
                                            AdmitCard: Applicant.admitcard,
                                            Result: Applicant.result,
                                            onPaymentPressed: () {},
                                            onAdmitCardPressed: () {
                                              GetAdmitCardLinkandPrint(
                                                  Applicant.Catagories,
                                                  Applicant.name);
                                            },
                                            onResultPressed: () {
                                              GetResult(Applicant.Catagories,
                                                  Applicant.name);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      width: screenWidth * 0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 162, 222, 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'গুরুত্বপূর্ণ নোটিশ',
                                          /*বিজ্ঞপ্তি*/
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      )),
                                  _buildList(_noticeWidgets),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      width: screenWidth * 0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 162, 222, 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Recent Events',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      )),
                                  _buildImageList(_eventWidgets),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      width: screenWidth * 0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 162, 222, 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Popular Exam',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      )),
                                  Container(
                                    height: 250,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: PageView.builder(
                                      controller:
                                      PageController(viewportFraction: 1),
                                      itemCount: _examFeeWidgets.length,
                                      itemBuilder: (context, index) {
                                        ExamItemTemplate exam =
                                        _examFeeWidgets[index]
                                        as ExamItemTemplate;
                                        return ExamCard(
                                          examName: exam.name,
                                          examCatagories: exam.Catagories,
                                          examFee: exam.price,
                                          onDetailsPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ExamDetails(
                                                          details: exam.Details,
                                                        )));
                                          },
                                          onSharePressed: () async {
                                            Share.share(
                                              exam.Details,
                                              subject: 'Exam Details',
                                            );
                                          },
                                          onRegistrationPressed: () {
                                            print(exam.Catagories);
                                            print(exam.name);
                                            print(exam.price);
                                            print(exam.Details);
                                            print(exam.CatagoryID);
                                            print(exam.typeID);
                                            if (auth == true) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RegistrationCenter(
                                                            Catagory:
                                                            exam.Catagories,
                                                            Type: exam.name,
                                                            Fee: exam.price,
                                                            CatagoryId:
                                                            exam.CatagoryID,
                                                            TypeId: exam.typeID,
                                                          )));
                                            } else if (auth == false) {
                                              const snackBar = SnackBar(
                                                content: Text(
                                                    'Please Login First!!'),
                                              );
                                              ScaffoldMessenger.of(
                                                  context as BuildContext)
                                                  .showSnackBar(snackBar);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Login()));
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      width: screenWidth * 0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 162, 222, 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Training Program',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      )),
                                  _buildImageList(_programWidgets),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      width: screenWidth * 0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 162, 222, 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'B-Jet Program',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      )),
                                  _buildImageList(_bjetWidgets),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          if (auth == true) ...[
                            Text(
                              'Candidate can also purchase books from the following offices on cash payment',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(143, 150, 158, 1),
                                fontFamily: 'default',
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              children: [
                                Container(
                                    width: screenWidth * 0.9,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 162, 222, 1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Book',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'default',
                                        ),
                                      ),
                                    )),
                                Container(
                                  height: 150,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: PageView.builder(
                                    controller:
                                    PageController(viewportFraction: 1),
                                    itemCount: _bookWidgets.length,
                                    itemBuilder: (context, index) {
                                      ItemTemplate book =
                                      _bookWidgets[index] as ItemTemplate;
                                      return BookCard(
                                        bookName: book.name,
                                        bookPrice: book.price,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color.fromRGBO(0, 162, 222, 1),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width * 0.9,
                                        MediaQuery.of(context).size.height *
                                            0.08),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const Syllabus()));
                                  },
                                  child: const Text('Syllabus',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color.fromRGBO(0, 162, 222, 1),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width * 0.9,
                                        MediaQuery.of(context).size.height *
                                            0.08),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const CourseOutline()));
                                  },
                                  child: const Text('Course Outline',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                          Center(
                            child: Text(
                              'Partners',
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default'),
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('Assets/Images/Itpec.png'),
                                width: 100,
                                height: 100,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Image(
                                  image: AssetImage('Assets/Images/Jica.png'),
                                  width: 70,
                                  height: 70),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  height: screenHeight * 0.08,
                  color: const Color.fromRGBO(0, 162, 222, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard(
                                    shouldRefresh: true,
                                  )));
                        },
                        child: Container(
                          width: screenWidth / 5,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.home,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ITEEDetails()));
                        },
                        child: Container(
                          width: screenWidth / 5,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'ITEE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BJetDetails()));
                        },
                        child: Container(
                          width: screenWidth / 5,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                image:
                                AssetImage('Assets/Images/Bjet-Small.png'),
                                height: 30,
                                width: 50,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'B-Jet',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ITEETrainingProgramDetails()));
                        },
                        child: Container(
                          width: screenWidth / 5,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                image:
                                AssetImage('Assets/Images/ITEE-Small.png'),
                                height: 30,
                                width: 60,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Training',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard(
                                    shouldRefresh: true,
                                  )));
                        },
                        child: Container(
                          width: screenWidth / 5,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Contact',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        else {
          return InternetChecker(
            child: PopScope(
              canPop: false,
              child: Scaffold(
                key: _scaffoldKey,
                appBar: auth
                    ? AppBar(
                  backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                  titleSpacing: 5,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'default',
                    ),
                  ),
                  actions: [
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            _showNotificationsOverlay(context);
                            var notificationApiService =
                            await NotificationReadApiService.create();
                            notificationApiService.readNotification();
                          },
                        ),
                        if (notifications.isNotEmpty)
                          Positioned(
                            right: 11,
                            top: 11,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${notifications.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
                    : AppBar(
                  backgroundColor: Colors.white,
                  titleSpacing: 5,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      Image(
                        image: AssetImage(
                          'Assets/Images/BCC-Logo.png',
                        ),
                        height: 40,
                      ),
                      Image(
                        image: AssetImage(
                          'Assets/Images/ITEC-Logo.png',
                        ),
                        height: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        },
                        child: Text(
                          'Login/Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(0, 162, 222, 1),
                            fontFamily: 'default',
                          ),
                        ))
                  ],
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 162, 222, 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60, // Adjust width as needed
                              height: 60, // Adjust height as needed
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(photoUrl),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              userName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text('Home',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Dashboard(
                                    shouldRefresh: true,
                                  ))); // Close the drawer
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Syllabus',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Syllabus()));
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Course Outline',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CourseOutline()));
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Logout',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () async {
                          Navigator.pop(context);
                          const snackBar = SnackBar(
                            content: Text(
                                'Logging out'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          /*   // Clear user data from SharedPreferences
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('userName');
                                await prefs.remove('organizationName');
                                await prefs.remove('photoUrl');*/
                          // Create an instance of LogOutApiService
                          var logoutApiService =
                          await LogOutApiService.create();

                          // Wait for authToken to be initialized
                          logoutApiService.authToken;

                          // Call the signOut method on the instance
                          if (await logoutApiService.signOut()) {
                            const snackBar = SnackBar(
                              content: Text(
                                  'Logged out'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            // Call logout method in AuthCubit/AuthBloc
                            context.read<AuthCubit>().logout();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Login())); // Close the drawer
                          }
                        },
                      ),
                      Divider(),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: SafeArea(
                    child: Container(
                      //height: screenHeight,
                      color: Colors.grey[100],
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Welcome to ITEE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(0, 162, 222, 1),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Center(
                              child: Text(
                                'A Local & Internally recognized IT Skills Training & Exam Center',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  letterSpacing: 1.1,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          if (auth == true) ...[
                            Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: screenWidth * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                        width: screenWidth * 0.9,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(0, 162, 222, 1),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'My Application(s)',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontFamily: 'default',
                                            ),
                                          ),
                                        )),
                                    Container(
                                      height: 250,
                                      width: screenWidth,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: PageView.builder(
                                        controller:
                                        PageController(viewportFraction: 1),
                                        itemCount: _applicationWidgets.length,
                                        itemBuilder: (context, index) {
                                          ApplicationItemTemplate Applicant =
                                          _applicationWidgets[index]
                                          as ApplicationItemTemplate;
                                          return ApplicationCard(
                                            examName: Applicant.name,
                                            examCatagories:
                                            Applicant.Catagories,
                                            Payment: Applicant.payment,
                                            AdmitCard: Applicant.admitcard,
                                            Result: Applicant.result,
                                            onPaymentPressed: () {},
                                            onAdmitCardPressed: () {
                                              GetAdmitCardLinkandPrint(
                                                  Applicant.Catagories,
                                                  Applicant.name);
                                            },
                                            onResultPressed: () {
                                              GetResult(Applicant.Catagories,
                                                  Applicant.name);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      width: screenWidth * 0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 162, 222, 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'গুরুত্বপূর্ণ নোটিশ',
                                          /*বিজ্ঞপ্তি*/
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      )),
                                  _buildList(_noticeWidgets),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      width: screenWidth * 0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 162, 222, 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Recent Events',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      )),
                                  _buildImageList(_eventWidgets),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      width: screenWidth * 0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 162, 222, 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Popular Exam',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      )),
                                  Container(
                                    height: 250,
                                    width: screenWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: PageView.builder(
                                      controller:
                                      PageController(viewportFraction: 1),
                                      itemCount: _examFeeWidgets.length,
                                      itemBuilder: (context, index) {
                                        ExamItemTemplate exam =
                                        _examFeeWidgets[index]
                                        as ExamItemTemplate;
                                        return ExamCard(
                                          examName: exam.name,
                                          examCatagories: exam.Catagories,
                                          examFee: exam.price,
                                          onDetailsPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ExamDetails(
                                                          details: exam.Details,
                                                        )));
                                          },
                                          onSharePressed: () async {
                                            Share.share(
                                              exam.Details,
                                              subject: 'Exam Details',
                                            );
                                          },
                                          onRegistrationPressed: () {
                                            print(exam.Catagories);
                                            print(exam.name);
                                            print(exam.price);
                                            print(exam.Details);
                                            print(exam.CatagoryID);
                                            print(exam.typeID);
                                            if (auth == true) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RegistrationCenter(
                                                            Catagory:
                                                            exam.Catagories,
                                                            Type: exam.name,
                                                            Fee: exam.price,
                                                            CatagoryId:
                                                            exam.CatagoryID,
                                                            TypeId: exam.typeID,
                                                          )));
                                            } else if (auth == false) {
                                              const snackBar = SnackBar(
                                                content: Text(
                                                    'Please Login First!!'),
                                              );
                                              ScaffoldMessenger.of(
                                                  context as BuildContext)
                                                  .showSnackBar(snackBar);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Login()));
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      width: screenWidth * 0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 162, 222, 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Training Program',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      )),
                                  _buildImageList(_programWidgets),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      width: screenWidth * 0.9,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 162, 222, 1),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'B-Jet Program',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      )),
                                  _buildImageList(_bjetWidgets),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          if (auth == true) ...[
                            Text(
                              'Candidate can also purchase books from the following offices on cash payment',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(143, 150, 158, 1),
                                fontFamily: 'default',
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              children: [
                                Container(
                                    width: screenWidth * 0.9,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 162, 222, 1),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Book',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'default',
                                        ),
                                      ),
                                    )),
                                Container(
                                  height: 150,
                                  width: screenWidth,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: PageView.builder(
                                    controller:
                                    PageController(viewportFraction: 1),
                                    itemCount: _bookWidgets.length,
                                    itemBuilder: (context, index) {
                                      ItemTemplate book =
                                      _bookWidgets[index] as ItemTemplate;
                                      return BookCard(
                                        bookName: book.name,
                                        bookPrice: book.price,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color.fromRGBO(0, 162, 222, 1),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width * 0.9,
                                        MediaQuery.of(context).size.height *
                                            0.08),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const Syllabus()));
                                  },
                                  child: const Text('Syllabus',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color.fromRGBO(0, 162, 222, 1),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width * 0.9,
                                        MediaQuery.of(context).size.height *
                                            0.08),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const CourseOutline()));
                                  },
                                  child: const Text('Course Outline',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                          Center(
                            child: Text(
                              'Partners',
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default'),
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('Assets/Images/Itpec.png'),
                                width: 100,
                                height: 100,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Image(
                                  image: AssetImage('Assets/Images/Jica.png'),
                                  width: 70,
                                  height: 70),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  height: screenHeight * 0.08,
                  color: const Color.fromRGBO(0, 162, 222, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard(
                                    shouldRefresh: true,
                                  )));
                        },
                        child: Container(
                          width: screenWidth / 5,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.home,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ITEEDetails()));
                        },
                        child: Container(
                          width: screenWidth / 5,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'ITEE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BJetDetails()));
                        },
                        child: Container(
                          width: screenWidth / 5,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                image:
                                AssetImage('Assets/Images/Bjet-Small.png'),
                                height: 30,
                                width: 50,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'B-Jet',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ITEETrainingProgramDetails()));
                        },
                        child: Container(
                          width: screenWidth / 5,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                image:
                                AssetImage('Assets/Images/ITEE-Small.png'),
                                height: 30,
                                width: 60,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Training',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard(
                                    shouldRefresh: true,
                                  )));
                        },
                        child: Container(
                          width: screenWidth / 5,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Contact',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildList(List<Widget> items) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width * 0.9,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.95),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return items[index];
        },
      ),
    );
  }

  Widget _buildImageList(List<Widget> items) {
    return Container(
      height: 200,
      child: PageView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          ItemTemplateImages images = items[index] as ItemTemplateImages;
          final String fullImageUrl =
              'https://www.bcc.touchandsolve.com/' + images.images;
          return Image.network(
            fullImageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              }
            },
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Center(
                child: Icon(Icons.error), // Error icon for image load failure
              );
            },
          );
           return FadeInImage.assetNetwork(
            placeholder: 'Assets/Images/loading.gif',
            image: fullImageUrl,
            fit: BoxFit.cover,
          );
           Image.network(
            fullImageUrl,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  Future<void> GetResult(String category, String type) async {
    if (_isFetchedResult) return;

    try {
      const snackBar = SnackBar(
        content: Text('Processing, Please wait'),
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      final apiService = await ResultAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic>? ResultData =
          await apiService.getResult(category, type);
      if (ResultData == null || ResultData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      final Map<String, dynamic> result = await ResultData['result'];
      print(result);
      final String name = result['name'];
      final String examName = result['exam_name'];
      final String showresult = result['result'];

      showResultDialog(context, name, examName, showresult);

      setState(() {
        _isFetchedResult = true;
      });
      setState(() {
        _isFetchedResult = false;
      });
    } catch (e) {
      print('Error fetching results: $e');
      setState(() {
        _isFetchedResult = true;
      });
      setState(() {
        _isFetchedResult = false;
      });
      // Handle error as needed
    }
  }

  void showResultDialog(
      BuildContext context, String name, String examName, String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Exam Result',
              style: TextStyle(
                color: Color.fromRGBO(0, 162, 222, 1),
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'default',
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Text(
                'Name: $name',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Exam Name: $examName',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Result: $result',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.45,
                      MediaQuery.of(context).size.height * 0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'default',
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> GetAdmitCardLinkandPrint(
      String categoryId, String typeId) async {
    if (_isFetchedPrint) return;

    try {
      const snackBar = SnackBar(
        content: Text('Processing, Please wait'),
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      final apiService = await AdmitCardAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic> dashboardData =
          await apiService.fetchAdmitCardItems(categoryId, typeId);
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      link = dashboardData['download'].toString();

      if (link != null)
        generatePDF(context, link);
      else {
        const snackBar = SnackBar(
          content: Text('You did not Registered in this Exam'),
        );
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      }

      // Set isLoading to true while fetching data
      setState(() {
        _isLoading = true;
      });

      // Simulate fetching data for 5 seconds
      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _isFetchedPrint = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetchedPrint = true;
      // Handle error as needed
    }
  }

  Future<void> generatePDF(BuildContext context, String link) async {
    const snackBar = SnackBar(
      content: Text('Preparing Printing, Please wait'),
    );
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
    print('Print Triggered!!');

    try {
      print('PDF generated successfully. Download URL: ${link}');
      final Uri url = Uri.parse(link);
      var data = await http.get(url);
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => data.bodyBytes);
    } catch (e) {
      // Handle any errors
      print('Error generating PDF: $e');
    }
  }

  void _showNotificationsOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: kToolbarHeight + 10.0,
        right: 10.0,
        width: 250,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: notifications.isEmpty
                ? Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'No new notifications',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text(notifications[index]),
                            onTap: () {
                              // Handle notification tap if necessary
                              overlayEntry.remove();
                            },
                          ),
                          if (index < notifications.length - 1) Divider()
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    // Remove the overlay when tapping outside
    Future.delayed(Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
