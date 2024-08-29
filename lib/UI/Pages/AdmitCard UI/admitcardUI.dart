import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:itee_exam_app/UI/Widgets/CardWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Data/Data Sources/API Service (Admit Card)/apiserviceadmitcardview.dart';
import '../../Widgets/admitcardCard.dart';
import '../B-Jet Details UI/B-jetDetailsUI.dart';
import '../Dashboard UI/dashboardUI.dart';
import '../ITEE Details UI/iteedetailsui.dart';
import '../ITEE Training Program Details UI/trainingprogramdetails.dart';

class AdmitCard extends StatefulWidget {
  final bool shouldRefresh;

  const AdmitCard({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<AdmitCard> createState() => _AdmitCardState();
}

class _AdmitCardState extends State<AdmitCard> {
  bool _isLoading = false;
  late final String name;
  bool isloaded = false;
  bool buttonClicked = false;
  bool _isFetched = false;
  List<Widget> _admitcardWidgets = [];

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await AdmitCardViewAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic>? dashboardData =
      await apiService.getallAdmitCard();
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      final List<dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        setState(() {
          _admitcardWidgets = [];
          _isFetched = true;
        });
        return;
      }

      for (var index = 0; index < records.length; index++) {
        print('Admit Card at index $index: ${records[index]}\n');
      }

      // Set isLoading to true while fetching data
      setState(() {
        _isLoading = true;
      });

      final List<Widget> AdmitCardWidgets = records.map((item) {
        int index = records.indexOf(item);
        print(records[index]);
        return AdmitCardCard(
          ExamineeID: item['examine_id'],
          ExamType: item['exam_type'],
          ExamCatagory: item['exam_category'],
          Name: item['examine_name'],
          URL: item['admit_download'],

        );
      }).toList();

      setState(() {
        _admitcardWidgets = AdmitCardWidgets;
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
    print('initState called');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              )),
          title: Text(
            'Download Admit Card',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'default',
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                          'Your Admit Card(s)',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 162, 222, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        )),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        CardWidget(
                          loading: _isLoading,
                          fetch: _isFetched,
                          errorText: 'Please Register a Exam. If You did then Pay First',
                          listWidget: _admitcardWidgets,
                          fetchData: fetchConnectionRequests(),
                        )
                      ],
                    ),
                  ],
                ),
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ITEEDetails()));
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BJetDetails()));
                },
                child: Container(
                  width: screenWidth / 5,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('Assets/Images/Bjet-Small.png'),
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
                          builder: (context) => ITEETrainingProgramDetails()));
                },
                child: Container(
                  width: screenWidth / 5,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('Assets/Images/ITEE-Small.png'),
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
                onTap: () async {
                  showPhoneNumberDialog(context);
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
    );
  }

  void showPhoneNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Select a Number to Call',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 162, 222, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                    fontSize: 22,
                  ),
                ),
              ),
              Divider()
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                phoneNumberTile(context, '0255006847'),
                Divider(),
                phoneNumberTile(context, '028181032'),
                Divider(),
                phoneNumberTile(context, '028181033'),
                Divider(),
                phoneNumberTile(context, '+8801857321122'),
                Divider(),
              ],
            ),
          ),
          actions: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(0, 162, 222, 1)),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget phoneNumberTile(BuildContext context, String phoneNumber) {
    return ListTile(
      title: Text(
        phoneNumber,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'default',
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 162, 222, 1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: IconButton(
          icon: Icon(
            Icons.call,
            color: Colors.white,
          ),
          onPressed: () async {
            try {
              await FlutterPhoneDirectCaller.callNumber(phoneNumber);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling $phoneNumber...')),
              );
            } catch (e) {
              print('Error: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to make the call: $e')),
              );
            }
          },
        ),
      ),
    );
  }
}
