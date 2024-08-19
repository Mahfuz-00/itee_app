import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Data/Data Sources/API Service (Registration)/apiservicegetpersonalinfo.dart';
import '../../Widgets/LabelText.dart';
import '../../Widgets/dropdownfields.dart';
import '../B-Jet Details UI/B-jetDetailsUI.dart';
import '../Dashboard UI/dashboardUI.dart';
import '../ITEE Details UI/iteedetailsui.dart';
import '../ITEE Training Program Details UI/trainingprogramdetails.dart';
import 'registrationacademicinfo.dart';
import 'registrationvenuefrompopularexam.dart';

class RegistrationPersonalInformation extends StatefulWidget {
  const RegistrationPersonalInformation({super.key});

  @override
  State<RegistrationPersonalInformation> createState() =>
      _RegistrationPersonalInformationState();
}

class _RegistrationPersonalInformationState
    extends State<RegistrationPersonalInformation>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _Datecontroller = TextEditingController();
  late TextEditingController _FullNamecontroller =
      TextEditingController(text: name);
  late TextEditingController _Emailcontroller =
      TextEditingController(text: email);
  late TextEditingController _Phonecontroller =
      TextEditingController(text: phone);
  late TextEditingController _Addresscontroller = TextEditingController();
  late TextEditingController _PostCodecontroller = TextEditingController();
  late TextEditingController _Occupationcontroller =
      TextEditingController(text: occupation);
  late TextEditingController _linkedincontroller =
      TextEditingController(text: linkedin);
  late TextEditingController _Gendercontroller = TextEditingController();
  File? _imageFile;
  bool _isFetched = false;
  bool _isLoading = false;
  late String name = '';
  late String email = '';
  late String phone = '';
  late String occupation = '';
  late String linkedin = '';

  List<DropdownMenuItem<String?>> gender = [
    DropdownMenuItem(child: Text("Male"), value: "Male"),
    DropdownMenuItem(child: Text("Female"), value: "Female"),
  ];

/*  List<String?> gender = ['Male', 'Female', null];*/

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await PersonalInfoAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic>? dashboardData =
          await apiService.getPersonalInfo();
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

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

      print(records);
      name = records['name'];
      email = records['email'];
      phone = records['phone'];
      occupation = records['occupation'] ?? '';
      linkedin = records['linkedin'] ?? '';
      print(name);
      print(email);
      print(phone);
      print(occupation);
      print(linkedin);
      _FullNamecontroller.text = name;
      _Emailcontroller.text = email;
      _Phonecontroller.text = phone;
      _Occupationcontroller.text = occupation;
      _linkedincontroller.text = linkedin;

/*      final List<dynamic> noticeData = records['notices'] ?? [];
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
      }).toList();*/

      setState(() {
        /*   _examFeeWidgets = examFeeWidgets;
        _bookWidgets = bookWidgets;
        _noticeWidgets = noticeWidgets;
        _eventWidgets = eventWidgets;
        _programWidgets = programWidgets;
        _bjetWidgets = bjetWidgets;*/
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
    fetchConnectionRequests();
  }

  @override
  void dispose() {
    _Datecontroller.dispose();
    super.dispose();
  }

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
          child: SafeArea(
        child: Container(
          //height: screenHeight-40,
          color: Colors.grey[100],
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Personal Information(s)',
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
                text: 'Your Full Name',
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: screenWidth * 0.9,
                height: 70,
                child: TextFormField(
                  controller: _FullNamecontroller,
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
                    labelText: 'Full Name',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              LabeledTextWithAsterisk(
                text: 'Your Email Address',
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: screenWidth * 0.9,
                height: 70,
                child: TextFormField(
                  controller: _Emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) {
                    if (input!.isEmpty) {
                      return 'Please enter your email address';
                    }
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(input)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
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
                    labelText: 'Email Address',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              LabeledTextWithAsterisk(
                text: 'Your Mobile Number',
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: screenWidth * 0.9,
                height: 70,
                child: TextFormField(
                  controller: _Phonecontroller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // Only allow digits
                    LengthLimitingTextInputFormatter(11),
                  ],
                  // Limit input length to 11 characters
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'Please enter your mobile number name';
                    }
                    if (input.length != 11) {
                      return 'Mobile number must be 11 digits';
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
                    labelText: 'Mobile No',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              LabeledTextWithAsterisk(
                text: 'Your Date of Birth',
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: screenWidth * 0.9,
                height: 60,
                child: TextFormField(
                  controller: _Datecontroller,
                  readOnly: true,
                  enableInteractiveSelection: false,
                  enableSuggestions: false,
                  style: const TextStyle(
                    color: Color.fromRGBO(143, 150, 158, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                    contentPadding: EdgeInsets.all(10),
                    //floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime(2010),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2010),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            final formattedDate =
                                DateFormat('yyyy-MM-dd').format(selectedDate);
                            _Datecontroller.text = formattedDate;
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        // Adjust the padding as needed
                        child: Icon(
                          Icons.calendar_today_outlined,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              LabeledTextWithAsterisk(
                text: 'Your Gender',
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
                      hintText: 'Gender',
                      dropdownItems: gender
                          .where((item) => item != null)
                          .map((item) => item!)
                          .toList(),
                      initialValue: null,
                      onChanged: (value) {
                        setState(() {
                          _Gendercontroller.text = value!;
                        });
                      }),
                ),
              ),
              const SizedBox(height: 15),
              LabeledTextWithAsterisk(
                text: 'Your Linkedin Profile',
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: screenWidth * 0.9,
                height: 70,
                child: TextFormField(
                  controller: _linkedincontroller,
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
                    labelText: 'LinkedIn Profile',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              LabeledTextWithAsterisk(
                text: 'Your Address',
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: screenWidth * 0.9,
                height: 70,
                child: TextFormField(
                  controller: _Addresscontroller,
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
                    labelText: 'Address',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              LabeledTextWithAsterisk(
                text: 'Your Area Post Code',
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: screenWidth * 0.9,
                height: 70,
                child: TextFormField(
                  controller: _PostCodecontroller,
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
                    labelText: 'Post Code',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              LabeledTextWithAsterisk(
                text: 'Your Occupation',
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: screenWidth * 0.9,
                height: 70,
                child: TextFormField(
                  controller: _Occupationcontroller,
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
                    labelText: 'Occupation',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              /*         const SizedBox(height: 5),
              LabeledTextWithAsterisk(text: 'Your Linkdin Profile ID',),
              SizedBox(
                height: 5,
              ),
              Container(
                width: screenWidth * 0.9,
                height: 70,
                child: TextFormField(
                  //controller: _Occupationcontroller,
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
                    labelText: 'Linkdin Profile',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              LabeledTextWithAsterisk(text: 'Your WhatsApp Number',),
              SizedBox(
                height: 5,
              ),
              Container(
                width: screenWidth * 0.9,
                height: 70,
                child: TextFormField(
                  //controller: _Occupationcontroller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // Only allow digits
                    LengthLimitingTextInputFormatter(11),
                  ],
                  // Limit input length to 11 characters
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'Please enter your WhatsApp mobile number name';
                    }
                    if (input.length != 11) {
                      return 'Mobile number must be 11 digits';
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
                    labelText: 'WhatsApp Number',
                    labelStyle: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),*/
              const SizedBox(height: 10),
              LabeledTextWithAsterisk(
                text: 'Upload Your Picture',
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: (_imageWidth != 0
                    ? (_imageWidth + 10).clamp(0, screenWidth * 0.9)
                    : screenWidth * 0.9),
                height: (_imageHeight != 0
                    ? (_imageHeight + 10).clamp(0, 200)
                    : 80),
                child: InkWell(
                  onTap: _selectImage,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      labelStyle: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'default',
                      ),
                      errorMaxLines: null,
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red), // Customize error border color
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _imageFile != null
                              ? Image.file(
                                  _imageFile!,
                                  width: null,
                                  height: null,
                                  fit: BoxFit.contain,
                                )
                              : Center(
                                  child: Icon(Icons.image,
                                      size: 60, color: Colors.grey),
                                ),
                        ),
                        SizedBox(width: 8),
                        VerticalDivider(
                          thickness: 5,
                        ),
                        Text(
                          'Upload',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 162, 222, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        // Customize upload text style
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.4,
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
                        backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.4,
                            MediaQuery.of(context).size.height * 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        if (validateInputs()) {
                          saveData();
                          print('validated');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationAcademicInformation()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Fill up all required fields'),
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
    if (_FullNamecontroller.text.isEmpty ||
        _Emailcontroller.text.isEmpty ||
        _Phonecontroller.text.isEmpty ||
        _Datecontroller.text.isEmpty ||
        _Gendercontroller.text.isEmpty ||
        _Addresscontroller.text.isEmpty ||
        _PostCodecontroller.text.isEmpty ||
        _Occupationcontroller.text.isEmpty ||
        _imageFile == null) {
      return false;
    }
    return true;
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('full_name', _FullNamecontroller.text);
    await prefs.setString('email', _Emailcontroller.text);
    await prefs.setString('phone', _Phonecontroller.text);
    await prefs.setString('date_of_birth', _Datecontroller.text);
    await prefs.setString('gender', _Gendercontroller.text);
    await prefs.setString('linkedin', _linkedincontroller.text);
    await prefs.setString('address', _Addresscontroller.text);
    await prefs.setString('post_code', _PostCodecontroller.text);
    await prefs.setString('occupation', _Occupationcontroller.text);
    // You can save the image path instead of the whole image if needed
    if (_imageFile != null) {
      await prefs.setString('image_path', _imageFile!.path);
    }

    print(await prefs.getString('full_name'));
    print(await prefs.getString('email'));
    print(await prefs.getString('phone'));
    print(await prefs.getString('date_of_birth'));
    print(await prefs.getString('gender'));
    print(await prefs.getString('linkedin'));
    print(await prefs.getString('address'));
    print(await prefs.getString('post_code'));
    print(await prefs.getString('occupation'));
    print(await prefs.getString('image_path'));
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Choose an option',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0, 162, 222, 1),
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
                fontSize: 22,
              ),),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                    fontSize: 18,
                  ),),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                    await _getImageDimensions();
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                    fontSize: 18,
                  ),),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                    await _getImageDimensions();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  double _imageHeight = 0;
  double _imageWidth = 0;

  // Function to load image dimensions
  Future<void> _getImageDimensions() async {
    if (_imageFile != null) {
      final data = await _imageFile!.readAsBytes();
      final image = await decodeImageFromList(data);
      setState(() {
        _imageHeight = image.height.toDouble();
        _imageWidth = image.width.toDouble();
      });
    }
  }
}
