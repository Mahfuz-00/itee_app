import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../Data/Data Sources/API Service (Registration)/apiservicegetpersonalinfo.dart';
import '../../Bloc/second_page_cubit.dart';
import '../../Widgets/LabelText.dart';
import '../../Widgets/custombottomnavbar.dart';
import '../../Widgets/dropdownfields.dart';
import 'registrationacademicinfo.dart';

/// A widget that represents the personal information registration form.
///
/// This class provides a user interface for users to input their personal information,
/// including full name, email, phone number, date of birth, gender, LinkedIn profile,
/// address, and occupation. It fetches existing user data using an API service and allows
/// users to update their information. It validates the email and phone number inputs
/// and ensures required fields are filled in before submission. The UI is responsive
/// and adapts to different screen sizes.
///
/// **State Variables:**
/// - [_Datecontroller]: Controller for the date of birth field.
/// - [_FullNamecontroller]: Controller for the full name field.
/// - [_Emailcontroller]: Controller for the email address field.
/// - [_Phonecontroller]: Controller for the mobile number field.
/// - [_Addresscontroller]: Controller for the address field.
/// - [_PostCodecontroller]: Controller for the postcode field.
/// - [_Occupationcontroller]: Controller for the occupation field.
/// - [_linkedincontroller]: Controller for the LinkedIn profile field.
/// - [_Gendercontroller]: Controller for the gender field.
/// - [_imageFile]: Holds the selected image file for profile picture.
/// - [_isFetched]: Indicates whether the data has been fetched from the API.
/// - [_isLoading]: Indicates whether data is currently being loaded.
///
/// **Methods:**
/// - `fetchConnectionRequests`: Fetches personal information from the API and populates
///   the corresponding text fields.
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

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await PersonalInfoAPIService.create();

      final Map<String, dynamic>? dashboardData =
          await apiService.getPersonalInfo();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      print(records);
      name = records['name'];
      email = records['email'];
      phone = records['phone'];
      occupation = records['occupation'] ?? '';
      linkedin = records['linkedin'] ?? '';
      _FullNamecontroller.text = name;
      _Emailcontroller.text = email;
      _Phonecontroller.text = phone;
      _Occupationcontroller.text = occupation;
      _linkedincontroller.text = linkedin;

      setState(() {
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
                    LengthLimitingTextInputFormatter(11),
                  ],
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return 'Please enter your mobile number name';
                    }
                    if (input.length != 11) {
                      return 'Mobile number must be 11 digits';
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
                            color: Colors.red),
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
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
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
    final secondPageCubit = context.read<SecondPageCubit>();

    context.read<SecondPageCubit>().updateUserInfo(
      fullName: _FullNamecontroller.text,
      email: _Emailcontroller.text,
      phone: _Phonecontroller.text,
      dateOfBirth: _Datecontroller.text,
      gender: _Gendercontroller.text,
      linkedin: _linkedincontroller.text,
      address: _Addresscontroller.text,
      postCode: _PostCodecontroller.text,
      occupation: _Occupationcontroller.text,
      imagePath: _imageFile!.path ?? '',
    );

    print('Full Name from State: ${secondPageCubit.state.fullName}');
    print('Email from State: ${secondPageCubit.state.email}');
    print('Phone from State: ${secondPageCubit.state.phone}');
    print('Date of Birth from State: ${secondPageCubit.state.dateOfBirth}');
    print('Gender from State: ${secondPageCubit.state.gender}');
    print('LinkedIn from State: ${secondPageCubit.state.linkedin}');
    print('Address from State: ${secondPageCubit.state.address}');
    print('Post Code from State: ${secondPageCubit.state.postCode}');
    print('Occupation from State: ${secondPageCubit.state.occupation}');
    print('Image Path from State: ${secondPageCubit.state.imagePath}');
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
