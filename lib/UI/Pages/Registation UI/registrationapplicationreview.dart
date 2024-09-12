import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Registration)/apiServiceRegistration.dart';
import '../../Bloc/combine_page_cubit.dart';
import '../../Widgets/custombottomnavbar.dart';
import 'paymentconfirmation.dart';

/// A screen that allows users to review and confirm their registration application.
///
/// This screen displays the details of the registration, including personal
/// information, educational qualifications, and selected exam details.
/// Users can review the information and submit their registration.
///
/// **Parameters:**
/// - `shouldRefresh` (bool): Determines whether the page should refresh its
///   content when loaded. Defaults to `false`.
///
/// **State Variables:**
/// - [Imagepath]: Path to the uploaded image.
/// - [venueName]: Name of the venue for the exam.
/// - [courseCategory]: Category of the course.
/// - [courseType]: Type of the exam.
/// - [examFee]: Fee for the exam.
/// - [examFeeID]: Identifier for the exam fee.
/// - [savedBookNames]: List of selected book names.
/// - [book]: Combined string of selected book names.
/// - [bookprice]: Price of the selected book.
/// - [venueID]: Identifier for the venue.
/// - [courseCategoryID]: Identifier for the course category.
/// - [courseTypeID]: Identifier for the course type.
/// - [fullName], [email], [mobileNumber], [dateOfBirth], [gender], [linkdin],
///   [address`, [postCode], [occupation]: Various personal details of the user.
/// - [educationQualification], [discipline], [subject], [passingYear],
///   [institute], [result]: Educational details of the user.
/// - [passingID]: Identifier for the passing details.
/// - [_pageLoading]: Indicates if the page is currently loading.
/// - [_isFetched]: Indicates if the data has been fetched.
/// - [buttonloading]: Indicates if the button is in loading state.
///
/// **Methods:**
/// - `fetchDataAndPrint`: Fetches data from the `CombinedDataCubit` and
///   updates state variables with the retrieved values.
/// - `_buildRow(String label, String value)`: Helper method to build a row
///   displaying a label and its corresponding value in the UI.
class RegistrationApplicationReviewUI extends StatefulWidget {
  final bool shouldRefresh;

  const RegistrationApplicationReviewUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<RegistrationApplicationReviewUI> createState() =>
      _RegistrationApplicationReviewUIState();
}

class _RegistrationApplicationReviewUIState
    extends State<RegistrationApplicationReviewUI>
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
    print('Book : $book');
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
        : InternetConnectionChecker(
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
                              'Exam Information Details',
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
                                    if( book.isNotEmpty) ...[
                                      _buildRow('Book', book),
                                      _buildRow('Book Price', 'TK $bookprice/-'),
                                    ],
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
                              print('Exam Registration: $registrationSuccessful');
                              if (registrationSuccessful != null &&
                                  registrationSuccessful['status'] == true) {
                                print('Status: ${registrationSuccessful['status']}');
                                print('Records: ${registrationSuccessful['records']}');
                                print(registrationSuccessful['records'][0]
                                    ?.toString()
                                    ?.trim()
                                    ?.toLowerCase());
                                if (registrationSuccessful['records'][0]
                                    ?.toString()
                                    ?.trim()
                                    ?.toLowerCase() ==
                                    'person is already registered for an exam previously.'.toLowerCase()) {
                                  setState(() {
                                    buttonloading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'You are already registered for an Exam'),
                                    ),
                                  );
                                } else if (registrationSuccessful['message'] == 'Exam Registration Successfully'){
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

                                  final combineDataCubit = context.read<CombinedDataCubit>();
                                  combineDataCubit.resetData();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PaymentConfirmationUI(
                                          ExamineeID: examineeID,
                                        )),
                                  );
                                }

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
                                            3),
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
              bottomNavigationBar: CustomBottomNavBar(),
            ),
          );
  }
}
