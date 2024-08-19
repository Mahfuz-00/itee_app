import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Course Outline)/apiserviceCourseOutline.dart';
import '../B-Jet Details UI/B-jetDetailsUI.dart';
import '../Dashboard UI/dashboardUI.dart';
import '../ITEE Details UI/iteedetailsui.dart';
import '../ITEE Training Program Details UI/trainingprogramdetails.dart';

class ExamMaterial extends StatefulWidget {
  final bool shouldRefresh;

  const ExamMaterial({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<ExamMaterial> createState() => _ExamMaterialState();
}

class _ExamMaterialState extends State<ExamMaterial> {
  bool _isLoading = false;
  late final String name;
  bool isloaded = false;
  bool _pageLoading = true;
  bool _isFetched = false;
  List<Map<String, dynamic>> records = [];

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await ExamMaterialAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic> dashboardData =
          await apiService.fetchExamMaterialItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      records = List<Map<String, dynamic>>.from(dashboardData['records']);
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        return;
      }
      print(records);

      // Set isLoading to true while fetching data
      setState(() {
        _isLoading = true;
      });

      // Simulate fetching data for 5 seconds
      await Future.delayed(Duration(seconds: 1));

      setState(() {
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
    super.initState();
    print('initState called');
    if (!_isFetched) {
      fetchConnectionRequests();
      //_isFetched = true; // Set _isFetched to true after the first call
    }
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        _pageLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return  _pageLoading
        ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Show circular loading indicator while waiting
        child: CircularProgressIndicator(),
      ),
    )
        : InternetChecker(
      child: PopScope(
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
              'Exam Material',
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
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Download Exam Material',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final syllabusItem = records[index];
                          return _buildDotPointItem(syllabusItem['name'],
                              syllabusItem['download_link']);
                        },
                      )
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
                          image: AssetImage(
                              'Assets/Images/Bjet-Small.png'),
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
                          image: AssetImage(
                              'Assets/Images/ITEE-Small.png'),
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

  _callNumber() async {
    const number = '+8801857321122'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  // Function to make a phone call
  Future<void> _makePhoneCall(BuildContext context, String url) async {
    print('Attempting to launch: $url');

    if (await canLaunch(url)) {
      print('Launching: $url');
      await launch(url);
    } else {
      print('Could not launch $url');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not Call $url')),
      );
    }
  }

  Widget _buildDotPointItem(String name, String link) {
    return Container(
      padding: EdgeInsets.only(left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                generatePDF(context, link);
              },
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.blue,
                  // Change color to blue for links
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                  decoration:
                  TextDecoration.underline, // Add underline for links
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> generatePDF(BuildContext context, String link) async {
    const snackBar = SnackBar(
      content: Text(
          'Preparing Printing, Please wait'),
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

}
