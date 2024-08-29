import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Registration)/apiServiceRegistration.dart';
import '../../Bloc/combine_page_cubit.dart';
import '../../Widgets/custombottomnavbar.dart';
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
  late List<String>? savedBookNames = [];
  late String book = "";
  late double? bookprice = 0.0;
  late String venueID = "";
  late String courseCategoryID = "";
  late String courseTypeID = "";
  late List<String>? bookID = [];
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

/*  Future<void> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedBookNames = prefs.getStringList('selectedBookNames');
    book = savedBookNames?.join(', ') ?? 'No books selected';

    Imagepath = prefs.getString('image_path') ?? '';
    venueID = prefs.getString('Venue') ?? '';
    venueName = prefs.getString('Venue_Name') ?? '';
    courseCategoryID = prefs.getString('Exam Catagories') ?? '';
    courseCategory = prefs.getString('Exam Catagories_Name') ?? '';
    courseTypeID = prefs.getString('Exam Type') ?? '';
    courseType = prefs.getString('Exam Type_Name') ?? '';
    examFee = prefs.getString('Exam Fee') ?? '';
    examFeeID = prefs.getInt('Exam Fee ID') ?? 0;
    bookID = prefs.getStringList('selectedBookIds');
    bookprice = prefs.getDouble('totalPrice');
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
  }*/

  void fetchDataAndPrint() async {
    final combinedDataCubit = context.read<CombinedDataCubit>();

    combinedDataCubit.getCombinedData();

    Imagepath = combinedDataCubit.state.imagePath;
    print(combinedDataCubit.state.imagePath);
    venueID = combinedDataCubit.state.venueID;
    venueName = combinedDataCubit.state.venueName;
    courseCategoryID = combinedDataCubit.state.courseCategoryID;
    courseCategory = combinedDataCubit.state.courseCategory;
    courseTypeID = combinedDataCubit.state.courseTypeID;
    courseType = combinedDataCubit.state.courseType;
    examFee = combinedDataCubit.state.examFee;
    examFeeID = combinedDataCubit.state.examFeeID;
    savedBookNames = combinedDataCubit.state.savedBookNames;
    bookID = combinedDataCubit.state.bookID;
    bookprice = combinedDataCubit.state.bookPrice;
    fullName = combinedDataCubit.state.fullName;
    email = combinedDataCubit.state.email;
    mobileNumber = combinedDataCubit.state.mobileNumber;
    dateOfBirth = combinedDataCubit.state.dateOfBirth;
    gender = combinedDataCubit.state.gender;
    linkdin = combinedDataCubit.state.linkedin;
    address = combinedDataCubit.state.address;
    postCode = combinedDataCubit.state.postCode;
    occupation = combinedDataCubit.state.occupation;
    educationQualification = combinedDataCubit.state.educationQualification;
    subject = combinedDataCubit.state.subject;
    discipline = combinedDataCubit.state.discipline;
    passingYear = combinedDataCubit.state.passingYear;
    institute = combinedDataCubit.state.institute;
    result = combinedDataCubit.state.result;
    passingID = combinedDataCubit.state.passingID;
    book = savedBookNames?.join(', ') ?? 'No books selected';

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
    print('LinkedIn: $linkdin');
    print('Address: $address');
    print('Post Code: $postCode');
    print('Occupation: $occupation');
    print('Education Qualification: $educationQualification');
    print('Subject: $subject');
    print('Discipline: $discipline');
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

  @override
  void initState() {
    super.initState();
    //getDataFromSharedPreferences();
    Future.delayed(Duration(seconds: 2), () {
      fetchDataAndPrint();
    });
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh) {
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
                                    _buildRow('Exam Fee', 'TK $examFee/-'),
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
                                    _buildRow('discipline', discipline),
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

                              final combinedDataCubit =
                                  context.read<CombinedDataCubit>();
                              final registrationSuccessful = await apiService
                                  .sendRegistrationDataFromCubit(
                                      combinedDataCubit, File(Imagepath));
                              if (registrationSuccessful != null &&
                                  registrationSuccessful['status'] == true) {
                                if (registrationSuccessful['records'] == 'Person is already registered for an exam previously.'){
                                  setState(() {
                                    buttonloading = false;
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'You are already registered for The Exam'),
                                    ),
                                  );
                                }
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
                                print('Examinee ID: $examineeID');
                                prefs.setString('examinee_id', examineeID);

                                print(registrationSuccessful['records']);

                                await prefs.remove('selectedBookNames');
                                await prefs.remove('image_path');
                                await prefs.remove('Venue');
                                await prefs.remove('Venue_Name');
                                await prefs.remove('Exam Catagories');
                                await prefs.remove('Exam Catagories_Name');
                                await prefs.remove('Exam Type');
                                await prefs.remove('Exam Type_Name');
                                await prefs.remove('Exam Fee');
                                await prefs.remove('Exam Fee ID');
                                await prefs.remove('selectedBookIds');
                                await prefs.remove('totalPrice');
                                await prefs.remove('full_name');
                                await prefs.remove('email');
                                await prefs.remove('phone');
                                await prefs.remove('date_of_birth');
                                await prefs.remove('gender');
                                await prefs.remove('linkedin');
                                await prefs.remove('address');
                                await prefs.remove('post_code');
                                await prefs.remove('occupation');
                                await prefs.remove('qualification');
                                await prefs.remove('subject_name');
                                await prefs.remove('passing_year');
                                await prefs.remove('institute');
                                await prefs.remove('result');
                                await prefs.remove('passing_id');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentConfirmation(
                                            ExamineeID: examineeID,
                                          )),
                                );
                              } else {
                                setState(() {
                                  buttonloading = false;
                                });
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
              bottomNavigationBar: CustomBottomNavigationBar(),
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
                              builder: (context) => const Dashboard(
                                    shouldRefresh: true,
                                  )));
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
