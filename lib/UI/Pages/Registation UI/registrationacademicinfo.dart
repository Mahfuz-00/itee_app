import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Widgets/LabelText.dart';
import '../../Widgets/dropdownfields.dart';
import '../B-Jet Details UI/B-jetDetailsUI.dart';
import '../Dashboard UI/dashboardUI.dart';
import '../ITEE Details UI/iteedetailsui.dart';
import '../ITEE Training Program Details UI/trainingprogramdetails.dart';
import 'registrationapplicationreview.dart';

class RegistrationAcademicInformation extends StatefulWidget {
  const RegistrationAcademicInformation({super.key});

  @override
  State<RegistrationAcademicInformation> createState() =>
      _RegistrationAcademicInformationState();
}

class _RegistrationAcademicInformationState
    extends State<RegistrationAcademicInformation>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DropdownMenuItem<String>> education = [
    DropdownMenuItem(
        child: Text("SSC or Equivalent"), value: "SSC or Equivalent"),
    DropdownMenuItem(
        child: Text("HSC or Equivalent"), value: "HSC or Equivalent"),
    DropdownMenuItem(
        child: Text("BSc or Equivalent"), value: "BSc or Equivalent"),
    DropdownMenuItem(
        child: Text("Diploma or Equivalent"), value: "Diploma or Equivalent"),
  ];

  List<DropdownMenuItem<String>> decipline = [
    DropdownMenuItem(child: Text("Science"), value: "Science"),
    DropdownMenuItem(child: Text("Commerce"), value: "Commerce"),
    DropdownMenuItem(child: Text("Arts"), value: "Arts"),
  ];

  late TextEditingController _Qulificationcontroller = TextEditingController();
  late TextEditingController _Deciplinecontroller = TextEditingController();
  late TextEditingController _SubjectNamecontroller = TextEditingController();
  late TextEditingController _PassingYearcontroller = TextEditingController();
  late TextEditingController _Institutecontroller = TextEditingController();
  late TextEditingController _Resultcontroller = TextEditingController();
  late TextEditingController _PassingIDcontroller = TextEditingController();

  late String? Qualification = '';
  late bool isdelayed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Container(
              //height: screenHeight + 40,
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Academic Information(s)',
                      style: TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  LabeledTextWithAsterisk(
                    text: 'Your Education Qualification',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.075,
                      padding: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownField(
                          hintText: 'Education Qualification',
                          dropdownItems: education,
                          initialValue: null,
                          onChanged: (value) {
                            setState(() {
                              _Qulificationcontroller.text = value!;
                              Qualification = value!;
                            });
                          }),
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (Qualification == 'SSC or Equivalent' ||
                      Qualification == 'HSC or Equivalent') ...[
                    LabeledTextWithAsterisk(
                      text: 'Decipline',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownField(
                            hintText: 'Decipline',
                            dropdownItems: decipline,
                            initialValue: null,
                            onChanged: (value) {
                              setState(() {
                                _Deciplinecontroller.text = value!;
                              });
                            }),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                  if (Qualification == 'BSc or Equivalent' ||
                      Qualification == 'Diploma or Equivalent') ...[
                    LabeledTextWithAsterisk(
                      text: 'Subject',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: screenWidth * 0.9,
                      height: 70,
                      child: TextFormField(
                        controller: _SubjectNamecontroller,
                        style: const TextStyle(
                          color: Color.fromRGBO(143, 150, 158, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: 'Subject Name',
                          labelStyle: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                  LabeledTextWithAsterisk(
                    text: 'Passing Year',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: 70,
                    child: TextFormField(
                      controller: _PassingYearcontroller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter your Passing year';
                        }
                        if (input.length != 4) {
                          return 'passing year must be 4 digits';
                        }
                        return null; // Return null if the input is valid
                      },
                      style: const TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: 'Passing Year',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  LabeledTextWithAsterisk(
                    text: 'Institute',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: 70,
                    child: TextFormField(
                      controller: _Institutecontroller,
                      style: const TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: 'Institute',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  LabeledTextWithAsterisk(
                    text: 'Result',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: 70,
                    child: TextFormField(
                      controller: _Resultcontroller,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: 'Result',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Previous Passing ID (If any)',
                    style: TextStyle(
                      color: Color.fromRGBO(143, 150, 158, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: 70,
                    child: TextFormField(
                      controller: _PassingIDcontroller,
                      style: const TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        labelText: 'Passing Id',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Row(
                      children: [
                        Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.08),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Back',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(0, 162, 222, 1),
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  MediaQuery.of(context).size.height * 0.08),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                isdelayed = true;
                              });
                              saveData();
                              if (validateInputs()) {
                                saveData();
                                print('validated');
                                await Future.delayed(Duration(seconds: 2));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegistrationApplicationReview(
                                              shouldRefresh: true,
                                            )));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Fill up all required fields'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: isdelayed
                                ? CircularProgressIndicator() // Show circular progress indicator when button is clicked
                                : const Text('Next',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    )),
                          ),
                        ),
                      ],
                    ),
                  )
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

  bool validateInputs() {
    if (Qualification == 'SSC or Equivalent' ||
        Qualification == 'HSC or Equivalent') {
      if (_Deciplinecontroller.text.isEmpty) {
        return false;
      }
      return true;
    }
    if (Qualification == 'BSc or Equivalent' ||
        Qualification == 'Diploma or Equivalent') {
      if (_SubjectNamecontroller.text.isEmpty) {
        return false;
      }
      return true;
    }
    if (_Qulificationcontroller.text.isEmpty ||
        _PassingYearcontroller.text.isEmpty ||
        _Institutecontroller.text.isEmpty ||
        _Resultcontroller.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('qualification', _Qulificationcontroller.text);
    if (Qualification == 'SSC or Equivalent' ||
        Qualification == 'HSC or Equivalent') {
      await prefs.setString('subject_name', _Deciplinecontroller.text);
    }
    if (Qualification == 'BSc or Equivalent' ||
        Qualification == 'Diploma or Equivalent') {
      await prefs.setString('subject_name', _SubjectNamecontroller.text);
    }

    await prefs.setString('passing_year', _PassingYearcontroller.text);
    await prefs.setString('institute', _Institutecontroller.text);
    await prefs.setString('result', _Resultcontroller.text);
    await prefs.setString('passing_id', _PassingIDcontroller.text);

    print(await prefs.getString('qualification'));
    print(await prefs.getString('decipline'));
    print(await prefs.getString('subject_name'));
    print(await prefs.getString('passing_year'));
    print(await prefs.getString('institute'));
    print(await prefs.getString('result'));
    print(await prefs.getString('passing_id'));
  }
}
