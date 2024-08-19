import 'dart:convert';
import 'dart:io';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Registration)/apiServiceRegistration.dart';
import '../AdmitCard UI/admitcardUI.dart';
import '../B-Jet Details UI/B-jetDetailsUI.dart';
import '../Dashboard UI/dashboardUI.dart';
import '../ITEE Details UI/iteedetailsui.dart';
import '../ITEE Training Program Details UI/trainingprogramdetails.dart';
import 'paymentconfirmation.dart';

class RegistrationApplicationReview extends StatefulWidget {
  final bool shouldRefresh;

  const RegistrationApplicationReview({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<RegistrationApplicationReview> createState() =>
      _RegistrationApplicationReviewState();
}

class _RegistrationApplicationReviewState
    extends State<RegistrationApplicationReview>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String Imagepath = "";
  late String venueName = "";
  late String courseCategory = "";
  late String courseType = "";
  late String examFee = "";
  late int examFeeID = 0;
  late String book = "";
  late String bookprice = "";
  late String venueID = "";
  late String courseCategoryID = "";
  late String courseTypeID = "";
  late String bookID = "";
  late String fullName = "";
  late String email = "";
  late String mobileNumber = "";
  late String dateOfBirth = "";
  late String gender = "";
  late String linkdin = "";
  late String address = "";
  late String postCode = "";
  late String occupation = "";
  late String educationQualification = "";
  late String discipline = "";
  late String subject = "";
  late String passingYear = "";
  late String institute = "";
  late String result = "";
  late String passingID = "";
  bool _pageLoading = true;
  bool _isFetched = false;
  bool buttonloading = false;

  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Imagepath = prefs.getString('image_path') ?? '';
    venueID = prefs.getString('Venue') ?? '';
    venueName = prefs.getString('Venue_Name') ?? '';
    courseCategoryID = prefs.getString('Exam Catagories') ?? '';
    courseCategory = prefs.getString('Exam Catagories_Name') ?? '';
    courseTypeID = prefs.getString('Exam Type') ?? '';
    courseType = prefs.getString('Exam Type_Name') ?? '';
    examFee = prefs.getString('Exam Fee') ?? '';
    examFeeID = prefs.getInt('Exam Fee ID') ?? 0;
    bookID = prefs.getString('Book') ?? '';
    book = prefs.getString('Book_Name') ?? '';
    bookprice = prefs.getString('BookPrice') ?? '';
    fullName = prefs.getString('full_name') ?? '';
    email = prefs.getString('email') ?? '';
    mobileNumber = prefs.getString('phone') ?? '';
    dateOfBirth = prefs.getString('date_of_birth') ?? '';
    gender = prefs.getString('gender') ?? '';
    linkdin = prefs.getString('linkedin') ?? '';
    address = prefs.getString('address') ?? '';
    postCode = prefs.getString('post_code') ?? '';
    occupation = prefs.getString('occupation') ?? '';
    educationQualification = prefs.getString('qualification') ?? '';
    discipline = prefs.getString('subject_name') ?? '';
    subject = prefs.getString('subject_name') ?? '';
    passingYear = prefs.getString('passing_year') ?? '';
    institute = prefs.getString('institute') ?? '';
    result = prefs.getString('result') ?? '';
    passingID = prefs.getString('passing_id') ?? '';
    // Print the data for verification
    printData();
  }

  void printData() {
    print('Image Path: $Imagepath');
    print('Venue Name: $venueName');
    print('Course Category: $courseCategory');
    print('Course Type: $courseType');
    print('Exam Fee: $examFee');
    print('Exam Fee ID: $examFeeID');
    print('Book: $book');
    print('Book Price: $bookprice');
    print('Full Name: $fullName');
    print('Email: $email');
    print('Mobile Number: $mobileNumber');
    print('Date of Birth: $dateOfBirth');
    print('Gender: $gender');
    print('Linkdin: $linkdin');
    print('Address: $address');
    print('Post Code: $postCode');
    print('Occupation: $occupation');
    print('Education Qualification: $educationQualification');
    print('Discipline: $discipline');
    print('Subject: $subject');
    print('Passing Year: $passingYear');
    print('Institute: $institute');
    print('Result: $result');
    print('Passing ID: $passingID');
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Color.fromRGBO(143, 150, 158, 1),
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            ":",
            style: TextStyle(
              color: Color.fromRGBO(143, 150, 158, 1),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Color.fromRGBO(143, 150, 158, 1),
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Map<String, String> _formData = {};

  @override
  void initState() {
    super.initState();
    getDataFromSharedPreferences();
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh) {
        // Refresh logic here, e.g., fetch data again
        print('Page Loading Done!!');
        setState(() {
          print('Page Loading');
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
        : InternetChecker(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                titleSpacing: 5,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.white,
                    )),
                title: const Text(
                  'Registration Form',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'default',
                  ),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                  child: SafeArea(
                child: Container(
                  //height: screenHeight*1.35,
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Please Review and Confirm Your Application',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Container(
                          width: screenWidth * 0.3,
                          height: screenHeight * 0.17,
                          decoration: BoxDecoration(
                            /*shape: BoxShape.square,*/
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(Imagepath)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                          child: Container(
                        width: screenWidth * 0.85,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(143, 150, 158, 1),
                              width: 1,
                            )),
                        child: Column(
                          children: [
                            Text(
                              'Information Details',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 162, 222, 1),
                                letterSpacing: 1.2,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                            Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    _buildRow('Venue Name', venueName),
                                    _buildRow(
                                        'Exam Catagories', courseCategory),
                                    _buildRow('Exam Type', courseType),
                                    _buildRow('Exam Fee', examFee),
                                    _buildRow('Book', book),
                                    _buildRow('Book Price', 'TK $bookprice/-'),
                                    _buildRow('Full Name', fullName),
                                    _buildRow('Email', email),
                                    _buildRow('Mobile Number', mobileNumber),
                                    _buildRow('Date of Birth', dateOfBirth),
                                    _buildRow('Gender', gender),
                                    _buildRow('Linkdin', linkdin),
                                    _buildRow('Address', address),
                                    _buildRow('Post Code', postCode),
                                    _buildRow('Occupation', occupation),
                                  ],
                                )),
                          ],
                        ),
                      )),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                          child: Container(
                        width: screenWidth * 0.85,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Color.fromRGBO(143, 150, 158, 1),
                              width: 1,
                            )),
                        child: Column(
                          children: [
                            Text(
                              'Education Details',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 162, 222, 1),
                                letterSpacing: 1.2,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  _buildRow('Education Qualification',
                                      educationQualification),
                                  if (educationQualification ==
                                          'SSC or Equivalent' ||
                                      educationQualification ==
                                          'HSC or Equivalent') ...[
                                    _buildRow('Decipine', discipline),
                                  ],
                                  if (educationQualification ==
                                          'BSc or Equivalent' ||
                                      educationQualification ==
                                          'Diploma or Equivalent') ...[
                                    _buildRow('Subject', subject),
                                  ],
                                  _buildRow('Passing Year', passingYear),
                                  _buildRow('Institute', institute),
                                  _buildRow('Result', result),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(0, 162, 222, 1),
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.85,
                                  MediaQuery.of(context).size.height * 0.08),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                buttonloading = true;
                              });
                              const snackBar = SnackBar(
                                content: Text('Processing'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              final apiService =
                                  await ExamRegistrationAPIService.create();

                              final registrationSuccessful = await apiService
                                  .sendRegistrationDataFromSharedPreferences(
                                      File(Imagepath));
                              if (registrationSuccessful != null &&
                                  registrationSuccessful['status'] == true) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                int examRegistrationId =
                                    registrationSuccessful['records']
                                        ['exam_registration_id'];
                                print(
                                    'Saved exam registration ID: $examRegistrationId');
                                prefs.setInt(
                                    'exam_registration_id', examRegistrationId);
                                String examineeID =
                                registrationSuccessful['records']
                                ['examine_id'];
                                print(
                                    'Examinee ID: $examineeID');
                                prefs.setString(
                                    'examinee_id', examineeID);
                                // If registration was successful, navigate to the next screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                           PaymentConfirmation(ExamineeID: examineeID,)),
                                );
                              } else {
                                setState(() {
                                  buttonloading = false;
                                });
                                // If registration failed, show a snackbar indicating the failure
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Failed to submit registration data. Please try again.'),
                                    duration: Duration(
                                        seconds:
                                            3), // Adjust the duration as needed
                                  ),
                                );
                              }
                            },
                            child: buttonloading
                                ? CircularProgressIndicator()
                                : const Text('Procced',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
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

  void showSliderAlert(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 600,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Bkash Payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 162, 222, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Trx ID',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(0, 162, 222, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: 380,
                  height: 70,
                  child: TextFormField(
                    style: const TextStyle(
                      color: Color.fromRGBO(143, 150, 158, 1),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: 'Trx ID',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'Enter the Transaction ID from Bkash Payment',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(143, 150, 158, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(height: 45),
              Center(
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                          MediaQuery.of(context).size.height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Dashboard(shouldRefresh: true,)));
                    },
                    child: const Text('Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
