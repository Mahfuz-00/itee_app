import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:footer/footer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itee_exam_app/UI/Pages/Sign%20Up%20UI/accountOTPverficationUI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Sign Up)/apiserviceregister.dart';
import '../../../Data/Models/registermodels.dart';
import '../Login UI/loginUI.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  late RegisterRequestmodel _registerRequest;
  late TextEditingController _fullNameController;
  late TextEditingController _occupationController;
  late TextEditingController _linkedinController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  File? _imageFile;
  var globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalfromkey = GlobalKey<FormState>();
  bool _isLoading = false;
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


  IconData _getIconPassword() {
    return _isObscuredPassword ? Icons.visibility_off : Icons.visibility;
  }

  IconData _getIconConfirmPassword() {
    return _isObscuredConfirmPassword ? Icons.visibility_off : Icons.visibility;
  }

  @override
  void initState() {
    super.initState();
    _registerRequest = RegisterRequestmodel(
      fullName: '',
      email: '',
      phone: '',
      password: '',
      confirmPassword: '',
      occupation: '',
      linkedin: '',
    );
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _occupationController = TextEditingController();
    _linkedinController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetChecker(
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: PopScope(
          canPop: false,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children : [
                            const Text(
                              'Hello! Register to get started!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(0, 162, 222, 1),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Sign in to see how we manage',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromRGBO(143, 150, 158, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                            const SizedBox(height: 50),
                            Form(
                              key: globalfromkey,
                              child: Column(
                                children: [
                                  Container(
                                    width: screenWidth*0.9,
                                    height: 70,
                                    child: TextFormField(
                                      controller: _fullNameController,
                                      validator: (input) {
                                        if (input == null || input.isEmpty) {
                                          return 'Please enter your full name';
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
                                  Container(
                                    width: screenWidth*0.9,
                                    height: 70,
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,
                                      validator: (input) {
                                        if (input!.isEmpty) {
                                          return 'Please enter your email address';
                                        }
                                        final emailRegex = RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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
                                        labelText: 'Email',
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
                                  Container(
                                    width: screenWidth*0.9,
                                    height: 70,
                                    child: TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        // Only allow digits
                                        LengthLimitingTextInputFormatter(11),
                                      ],
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
                                        labelText: 'Mobile Number',
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
                                  Container(
                                    width: screenWidth*0.9,
                                    height: 70,
                                    child: TextFormField(
                                      controller: _occupationController,
                                      validator: (input) {
                                        if (input == null || input.isEmpty) {
                                          return 'Please enter your occupation';
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
                                  const SizedBox(height: 5),
                                  Container(
                                    width: screenWidth*0.9,
                                    height: 70,
                                    child: TextFormField(
                                      controller: _linkedinController,
                                      validator: (input) {
                                        if (input == null || input.isEmpty) {
                                          return 'Please enter your linkedin profile';
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
                                        labelText: 'Linkedin Profile',
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
                                  Container(
                                    width: screenWidth*0.9,
                                    height: 70,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      //onSaved: (input) => _registerRequest.password = input!,
                                      validator: (input) => input!.length < 8
                                          ? "Password should be more than 8 characters"
                                          : null,
                                      controller: _passwordController,
                                      obscureText: _isObscuredPassword,
                                      style: const TextStyle(
                                        color: Color.fromRGBO(143, 150, 158, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(),
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: 'default',
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(_getIconPassword()),
                                          onPressed: () {
                                            setState(() {
                                              _isObscuredPassword = !_isObscuredPassword;
                                              _passwordController.text =
                                                  _passwordController.text;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: screenWidth*0.9,
                                    height: 70,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      //onSaved: (input)=> _registerRequest.Password = input!,
                                      validator: (input) => input!.length < 8 ? "Password should be more than 7 characters": null,
                                      controller: _confirmPasswordController,
                                      obscureText: _isObscuredConfirmPassword,
                                      style: const TextStyle(
                                        color: Color.fromRGBO(143, 150, 158, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      ),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(),
                                        labelText: 'Confirm Password',
                                        labelStyle: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: 'default',
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(_getIconConfirmPassword()),
                                          onPressed: () {
                                            setState(() {
                                              _isObscuredConfirmPassword = !_isObscuredConfirmPassword;
                                              _confirmPasswordController.text =
                                                  _confirmPasswordController.text;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: (_imageWidth != 0 ? (_imageWidth + 10).clamp(0, screenWidth*0.9) : screenWidth*0.9),
                                    height: (_imageHeight != 0 ? (_imageHeight + 10).clamp(0, 200) : 80),
                                    child: InkWell(
                                      onTap: _selectImage,
                                      child: InputDecorator(
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderSide:
                                              Divider.createBorderSide(context)),
                                          labelText: 'Add Profile Picture',
                                          labelStyle: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            fontFamily: 'default',
                                          ),
                                          errorMaxLines: null,
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .red), // Customize error border color
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
                                            VerticalDivider(thickness: 5,),
                                            Text('Upload',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(0, 162, 222, 1),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'default',
                                                ),),
                                            // Customize upload text style
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 50),
                            ElevatedButton(
                                onPressed: _registerUser,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(0, 162, 222, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fixedSize: Size(screenWidth*0.9, 70),
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator() // Show circular progress indicator when button is clicked
                                    : const Text('Register',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'default',
                                    ))),
                          ]
                        )
                      ),
                      Footer(
                        backgroundColor: Color.fromRGBO(246, 246, 246, 255),
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(bottom: 20,top: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account?  ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => Login()));
                                  },
                                  child: const Text(
                                    'Login now',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 162, 222, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });
    const snackBar = SnackBar(
      content: Text(
          'Processing'),
    );
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('Email', _emailController.text);
      print('User Name: ${_emailController.text}');
    } catch (e) {
      print('Error saving user profile: $e');
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    if (validateAndSave() && checkConfirmPassword()) {
      final registerRequest = RegisterRequestmodel(
        fullName: _fullNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        occupation: _occupationController.text,
        linkedin: _linkedinController.text,
      );

      final apiService = APIService();
      // Call register method passing registerRequestModel, _imageFile, and authToken
      apiService.register(registerRequest, _imageFile).then((response) {
        print("Submitted");
        if (response != null && response == "User Registration Successfully. Verification is pending.") {
          clearForm();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AccountOPTVerfication()),
          );
        } else if (response != null && response == "The email has already been taken."){
          setState(() {
            _isLoading = false;
          });
          const snackBar = SnackBar(
            content: Text('The Email is Taken!, Please Try entering a different Email'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (response != null && response == "The phone has already been taken."){
          setState(() {
            _isLoading = false;
          });
          const snackBar = SnackBar(
            content: Text('The Phone Number is Taken!, Please Try a different Number'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else{
          setState(() {
            _isLoading = false;
          });
          const snackBar = SnackBar(
            content: Text('Registration Failed!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        // Handle registration error
        print(error);
        const snackBar = SnackBar(
          content: Text('Registration failed!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  bool validateAndSave() {
    final form = globalfromkey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool checkConfirmPassword() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _getImageDimensions();
    }
  }

  void clearForm() {
    _fullNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _imageFile = null;
    });
  }
}
