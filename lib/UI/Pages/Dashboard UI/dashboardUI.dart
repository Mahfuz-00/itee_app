import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itee_exam_app/Data/Models/imagemodel.dart';
import 'package:itee_exam_app/UI/Pages/Dashboard%20UI/ApplicationSection.dart';
import 'package:itee_exam_app/UI/Pages/Dashboard%20UI/ExamRegistrationSection.dart';
import 'package:itee_exam_app/UI/Pages/Dashboard%20UI/NoticeSection.dart';
import 'package:itee_exam_app/UI/Pages/Registation%20UI/registrationvenuefrommenu.dart';
import 'package:itee_exam_app/UI/Widgets/listcardview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiservicedashboard.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/Buttontemplate.dart';
import '../../Widgets/custombottomnavbar.dart';
import '../../Widgets/imagecardview.dart';
import '../../Widgets/listTileDashboardBook.dart';
import '../../Widgets/listTileDashboardApplication.dart';
import '../../Widgets/listTileDashboardExam.dart';
import '../../Widgets/listTileNotice.dart';
import '../AdmitCard UI/admitcardUI.dart';
import '../Exam Material UI/ExamMaterialUI.dart';
import '../Login UI/loginUI.dart';
import '../PaymentUI/paymentUI.dart';
import '../Profile UI/profileUI.dart';
import '../Result UI/resultUI.dart';
import '../Syllabus UI/syllabusUI.dart';
import 'ApplicationWidget.dart';
import 'BookSection.dart';
import 'ExamRegistrationWidget.dart';
import 'ImageSection.dart';
import 'PartnerSection.dart';

/// This class manages the [DashboardUI] functionality within the application.
/// It serves as the central hub for users to access various features related to their exams,
/// results, and training programs.
///
/// Key functionalities include:
/// - Displaying all applications of the user, allowing them to see [results], download [admitCard],
///   and pay for exams.
/// - Showcasing recent events, notices, available exams, training programs, and [BJet] programs.
/// - Providing navigation options to register for exams either from the [examList] or the app bar.
/// - Enabling access to syllabus and exam materials directly from the app bar.
///
/// Variables and actions:
/// - [results]: Holds the results of the user's exams, showcasing their performance.
/// - [admitCard]: Link for downloading the admit card PDF, essential for exam attendance.
/// - [recentEvents]: List of recent events relevant to the user, including updates and notifications.
/// - [notices]: Displays important notices related to exams and programs.
/// - [exams]: A collection of exams available for registration, including their details and status.
/// - [trainingPrograms]: Lists available training programs for user participation and learning.
/// - [BJetPrograms]: Shows information about BJet programs, enhancing user engagement and opportunities.
/// - [examList]: Navigates to the list of exams for user registration and viewing.
/// - [registerView]: Directs users to the registration view for exams.
/// - [appBar]: Provides navigation options for accessing syllabus and exam materials.
class DashboardUI extends StatefulWidget {
  final bool shouldRefresh;

  const DashboardUI({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late String userName = '';
  late String photoUrl = '';
  late bool auth = false;
  bool _isFetched = false;
  bool _pageLoading = true;
  bool _isLoading = false;
  List<String> notifications = [];
  List<Widget> _examFeeWidgets = [];
  List<Widget> _applicationWidgets = [];
  List<Widget> _bookWidgets = [];
  List<Widget> _noticeWidgets = [];
  late List<ImageModel> _eventWidgets = [];
  late List<ImageModel> _programWidgets = [];
  late List<ImageModel> _bjetWidgets = [];
  late int resultcheck = 2;
  late int admitcardcheck = 2;
  late int _currentapplicationpage = 0;
  late int _currentexamregitrationpage = 0;
  late int _currentbookpage = 0;

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await DashboardAPIService.create();

      final Map<String, dynamic> dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      auth = dashboardData['authenticated'];
      print(auth);

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final List<Widget> applicationWidgets;

      if (auth == true) {
        notifications = List<String>.from(records['notifications'] ?? []);
        final List<dynamic> applications = records['my_applications'];
        print('Applications: $applications');
        applicationWidgets = applications
            .map((item) => ApplicationTemplate(
                  name: item['exam_type'],
                  Categories: item['exam_category'],
                  result: item['result'],
                  payment: item['payment'],
                  admitcard: item['admit_card'],
                  ExamineeID: item['examine_id'],
                ))
            .toList();

        setState(() {
          _applicationWidgets = applicationWidgets;
        });
        for (var index = 0; index < applications.length; index++) {
          print('Application at index $index: ${applications[index]}\n');
        }
      }

      await Future.delayed(Duration(seconds: 1));

      final List<dynamic> noticeData = records['notices'] ?? [];
      final List<dynamic> examFeesData = records['examFees'] ?? [];
      final List<dynamic> booksData = records['books'] ?? [];
      print('Book :: $booksData');
      final List<dynamic> EventData = records['recentEvents'] ?? [];
      final List<dynamic> ProgramData = records['programs'] ?? [];
      final List<dynamic> BjetData = records['bjetEvents'] ?? [];
      print('Notices : $noticeData');
      print('Exam Fees : $examFeesData');
      print('Books : $booksData');
      print('Events : $EventData');
      print('Programs : $ProgramData');
      print('BJet : $BjetData');

      final List<Widget> noticeWidgets = noticeData
          .map((item) => NoticeTemplate(
                notice: item['message'],
              ))
          .toList();
      final List<Widget> examFeeWidgets = examFeesData
          .map((item) => ExamTemplate(
                name: item['exam_type'],
                Catagories: item['exam_category'],
                price: item['fees'],
                Details: item['exam_details'],
                typeID: item['exam_type_id'],
                CatagoryID: item['exam_category_id'],
                priceID: item['fee_id'],
                image: item['exam_image'],
              ))
          .toList();
      for (var index = 0; index < examFeesData.length; index++) {
        print('Exams at index $index: ${examFeesData[index]}\n');
      }

      for (var index = 0; index < examFeesData.length; index++) {
        print('Application at index $index: ${examFeesData[index]}\n');
      }

      final List<Widget> bookWidgets = booksData
          .map((item) => BookTemplate(
                id: item['id'],
                name: item['name'],
                price: item['price'],
              ))
          .toList();

      _eventWidgets = EventData.map((item) => ImageModel(
            imageUrl: item['image'],
            label: item['label'],
          )).toList();

      _programWidgets = ProgramData.map((item) => ImageModel(
            imageUrl: item['image'],
            label: item['label'],
          )).toList();

      _bjetWidgets = BjetData.map((item) => ImageModel(
            imageUrl: item['image'],
            label: item['label'],
          )).toList();

      setState(() {
        _examFeeWidgets = examFeeWidgets;
        _bookWidgets = bookWidgets;
        _noticeWidgets = noticeWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetched = true;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (!_isFetched) {
        fetchConnectionRequests().then((_) {
          if (widget.shouldRefresh && _isFetched) {
            setState(() {
              _pageLoading = false;
            });
          }
        });
      } else {
        if (widget.shouldRefresh && _isFetched) {
          setState(() {
            _pageLoading = false;
          });
        }
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
              child: CircularProgressIndicator(),
            ),
          )
        : BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final userProfile = state.userProfile;
                return InternetConnectionChecker(
                  child: PopScope(
                    /*   canPop: false,*/
                    child: Scaffold(
                      key: _scaffoldKey,
                      appBar: auth
                          ? AppBar(
                              backgroundColor:
                                  const Color.fromRGBO(0, 162, 222, 1),
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
                                            await NotificationReadApiService
                                                .create();
                                        notificationApiService
                                            .readNotification();
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
                                            borderRadius:
                                                BorderRadius.circular(6),
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
                                          builder: (context) => LoginUI(),
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
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            'https://bcc.touchandsolve.com${userProfile.photo}'),
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
                                        builder: (context) => const DashboardUI(
                                              shouldRefresh: true,
                                            )));
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Exam Registration',
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
                                        builder: (context) =>
                                            const RegistrationCenterUIFromMenu()));
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Payment',
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
                                        builder: (context) => const PaymentUI(
                                              shouldRefresh: true,
                                            )));
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Admit Card',
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
                                        builder: (context) => const AdmitCardUI(
                                              shouldRefresh: true,
                                            )));
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Result',
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
                                        builder: (context) => const ResultUI(
                                              shouldRefresh: true,
                                            )));
                              },
                            ),
                            Divider(),
                            ExpansionTile(
                              title: Text(
                                'Download Materials',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                              ),
                              children: [
                                Divider(),
                                ListTile(
                                  title: Text(
                                    '   Syllabus',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontFamily: 'default',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SyllabusUI(
                                            shouldRefresh: true),
                                      ),
                                    );
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  title: Text(
                                    '   Exam Material',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontFamily: 'default',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ExamMaterialUI(
                                                shouldRefresh: true),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Profile',
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
                                        builder: (context) => ProfileUI(
                                              shouldRefresh: true,
                                            )));
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
                                  content: Text('Logging out'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                var logoutApiService =
                                    await LogOutApiService.create();

                                logoutApiService.authToken;

                                if (await logoutApiService.signOut()) {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove('token');
                                  const snackBar = SnackBar(
                                    content: Text('Logged out'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  context.read<AuthCubit>().logout();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginUI()));
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
                            color: Colors.grey[100],
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 30),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Center(
                                    child: Text(
                                      'A National & Internationally recognized IT Skills Training & Exam Center',
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
                                NoticeSection(
                                  title: 'Notice(s)',
                                  contentWidget:
                                      ListCardView(items: _noticeWidgets),
                                  screenWidth:
                                      MediaQuery.of(context).size.width,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                if (auth == true) ...[
                                  ApplicationSection(
                                    title: 'My Application(s)',
                                    contentWidget: ApplicationCarousel(
                                        applicationWidgets:
                                            _applicationWidgets),
                                    screenWidth:
                                        MediaQuery.of(context).size.width,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                                ExamRegistrationSection(
                                  title: 'Exam Registration',
                                  carouselWidget: ExamRegistrationCarousel(
                                    examFeeWidgets: _examFeeWidgets,
                                    auth: auth,
                                  ),
                                  screenWidth:
                                      MediaQuery.of(context).size.width,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ImageSection(
                                  title: 'Recent Events',
                                  carouselWidget:
                                      ImageCarousel(items: _eventWidgets),
                                  screenWidth:
                                      MediaQuery.of(context).size.width,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ImageSection(
                                  title: 'Training Program',
                                  carouselWidget:
                                      ImageCarousel(items: _programWidgets),
                                  screenWidth:
                                      MediaQuery.of(context).size.width,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ImageSection(
                                  title: 'B-Jet Program',
                                  carouselWidget:
                                      ImageCarousel(items: _bjetWidgets),
                                  screenWidth:
                                      MediaQuery.of(context).size.width,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                if (auth == true) ...[
                                  BookSection(
                                    bookWidgets: _bookWidgets,
                                    screenWidth:
                                        MediaQuery.of(context).size.width,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Buttons(
                                    text: 'Syllabus',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SyllabusUI()),
                                      );
                                    },
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                  ),
                                  SizedBox(height: 20),
                                  Buttons(
                                    text: 'Exam Material',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ExamMaterialUI()),
                                      );
                                    },
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                                PartnersSection(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      bottomNavigationBar: CustomBottomNavBar(),
                    ),
                  ),
                );
              } else {
                return InternetConnectionChecker(
                  child: PopScope(
                    canPop: false,
                    child: Scaffold(
                      key: _scaffoldKey,
                      appBar: auth
                          ? AppBar(
                              backgroundColor:
                                  const Color.fromRGBO(0, 162, 222, 1),
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
                                            await NotificationReadApiService
                                                .create();
                                        notificationApiService
                                            .readNotification();
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
                                            borderRadius:
                                                BorderRadius.circular(6),
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
                                          builder: (context) => LoginUI(),
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
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            photoUrl),
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
                                        builder: (context) => const DashboardUI(
                                              shouldRefresh: true,
                                            )));
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
                                        builder: (context) =>
                                            const SyllabusUI()));
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Exam Material',
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
                                        builder: (context) =>
                                            const ExamMaterialUI()));
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
                                  content: Text('Logging out'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                var logoutApiService =
                                    await LogOutApiService.create();

                                logoutApiService.authToken;

                                if (await logoutApiService.signOut()) {
                                  const snackBar = SnackBar(
                                    content: Text('Logged out'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                  context.read<AuthCubit>().logout();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginUI()));
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
                            color: Colors.grey[100],
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 30),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
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
                                  ApplicationSection(
                                    title: 'My Application(s)',
                                    contentWidget: ApplicationCarousel(
                                        applicationWidgets:
                                            _applicationWidgets),
                                    screenWidth:
                                        MediaQuery.of(context).size.width,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                                NoticeSection(
                                  title: 'Notice(s)',
                                  contentWidget:
                                      ListCardView(items: _noticeWidgets),
                                  screenWidth:
                                      MediaQuery.of(context).size.width,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ImageSection(
                                  title: 'Recent Events',
                                  carouselWidget:
                                      ImageCarousel(items: _eventWidgets),
                                  screenWidth:
                                      MediaQuery.of(context).size.width,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ExamRegistrationSection(
                                  title: 'Exam Registration',
                                  carouselWidget: ExamRegistrationCarousel(
                                    examFeeWidgets: _examFeeWidgets,
                                    auth: auth,
                                  ),
                                  screenWidth:
                                      MediaQuery.of(context).size.width,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ImageSection(
                                  title: 'Training Program',
                                  carouselWidget:
                                      ImageCarousel(items: _programWidgets),
                                  screenWidth:
                                      MediaQuery.of(context).size.width,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                ImageSection(
                                  title: 'B-Jet Program',
                                  carouselWidget:
                                      ImageCarousel(items: _bjetWidgets),
                                  screenWidth:
                                      MediaQuery.of(context).size.width,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                if (auth == true) ...[
                                  BookSection(
                                    bookWidgets: _bookWidgets,
                                    screenWidth:
                                        MediaQuery.of(context).size.width,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Buttons(
                                    text: 'Syllabus',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SyllabusUI()),
                                      );
                                    },
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                  ),
                                  SizedBox(height: 20),
                                  Buttons(
                                    text: 'Exam Material',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ExamMaterialUI()),
                                      );
                                    },
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                                PartnersSection(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      bottomNavigationBar: CustomBottomNavBar(),
                    ),
                  ),
                );
              }
            },
          );
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

    Future.delayed(Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
