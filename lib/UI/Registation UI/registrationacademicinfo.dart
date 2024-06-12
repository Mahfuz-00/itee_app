import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/LabelText.dart';
import '../Widgets/dropdownfields.dart';
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
                  LabeledTextWithAsterisk(text:  'Your Education Qualification',),
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
                    LabeledTextWithAsterisk(text: 'Decipline',),
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
                  if (Qualification == 'BSc or Equivalent' || Qualification == 'Diploma or Equivalent') ...[
                    LabeledTextWithAsterisk(text: 'Subject',),
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
                  LabeledTextWithAsterisk(text: 'Passing Year',),
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
                  LabeledTextWithAsterisk(text: 'Institute',),
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
                  LabeledTextWithAsterisk(text: 'Result',),
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
                            onPressed: () {
                              saveData();
                              if (validateInputs()) {
                                saveData();
                                print('validated');
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
                            child: const Text('Next',
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
    );
  }

  bool validateInputs() {
    if(Qualification == 'SSC or Equivalent'  || Qualification == 'HSC or Equivalent')  {
      if(_Deciplinecontroller.text.isEmpty){
        return false;
      }
      return true;
    }
    if(Qualification == 'BSc or Equivalent'  || Qualification == 'Diploma or Equivalent') {
      if(_SubjectNamecontroller.text.isEmpty){
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
    if(Qualification == 'SSC or Equivalent'  || Qualification == 'HSC or Equivalent')  {
      await prefs.setString('subject_name', _Deciplinecontroller.text);
    }
    if(Qualification == 'BSc or Equivalent'  || Qualification == 'Diploma or Equivalent') {
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
