import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Registration)/apiServiceRegistration.dart';
import '../AdmitCard UI/downloadadmitcard.dart';
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
                                  if(educationQualification == 'SSC or Equivalent'  || educationQualification == 'HSC or Equivalent') ...[
                                    _buildRow('Decipine', discipline),
                                  ],
                                  if(educationQualification == 'BSc or Equivalent'  || educationQualification == 'Diploma or Equivalent') ...[
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
                                content: Text(
                                    'Processing'),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                prefs.setInt(
                                    'exam_registration_id', examRegistrationId);
                                print(
                                    'Saved exam registration ID: $examRegistrationId');
                                // If registration was successful, navigate to the next screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PaymentConfirmation()),
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
            ),
          );
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
                              builder: (context) => const AdmitCardDownload()));
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
