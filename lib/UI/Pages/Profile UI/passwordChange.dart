import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Data/Data Sources/API Service (User Info Update)/apiServicePasswordUpdate.dart';
import '../B-Jet Details UI/B-jetDetailsUI.dart';
import '../Dashboard UI/dashboardUI.dart';
import '../ITEE Details UI/iteedetailsui.dart';
import '../ITEE Training Program Details UI/trainingprogramdetails.dart';
import 'profileUI.dart';
import 'package:flutter/material.dart';

class PasswordChange extends StatefulWidget {
  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isObscuredCurrentPassword = true;
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  bool _isButtonClicked = false;

  IconData _getIconCurrentPassword() {
    return _isObscuredCurrentPassword ? Icons.visibility_off : Icons.visibility;
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
    _currentPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'default',
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Current Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                /* onSaved: (input) =>
                _registerRequest.password = input!,*/
                validator: (input) =>
                input!.length < 8
                    ? "Password should be more than 7 characters"
                    : null,
                controller: _currentPasswordController,
                obscureText: _isObscuredCurrentPassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter current password',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  suffixIcon: IconButton(
                    icon: Icon(_getIconCurrentPassword()),
                    onPressed: () {
                      setState(() {
                        _isObscuredCurrentPassword = !_isObscuredCurrentPassword;
                        _currentPasswordController.text =
                            _currentPasswordController.text;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'New Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                /* onSaved: (input) =>
                _registerRequest.password = input!,*/
                validator: (input) =>
                input!.length < 8
                    ? "Password should be more than 7 characters"
                    : null,
                controller: _passwordController,
                obscureText: _isObscuredPassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter new password',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
              SizedBox(height: 20),
              Text(
                'Confirm Password',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                /* onSaved: (input) =>
                _registerRequest.password = input!,*/
                validator: (input) =>
                input!.length < 8
                    ? "Password should be more than 7 characters"
                    : null,
                controller: _confirmPasswordController,
                obscureText: _isObscuredConfirmPassword,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Confirm new password',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
              SizedBox(height: 40),
              Center(
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                      fixedSize: Size(MediaQuery
                          .of(context)
                          .size
                          .width * 0.8,
                          MediaQuery
                              .of(context)
                              .size
                              .height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _updatePassword();
                    },
                    child: _isButtonClicked
                        ? CircularProgressIndicator() // Show circular progress indicator when button is clicked
                        : Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                ),
              ),
            ],
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

  bool checkConfirmPassword() {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _isButtonClicked =
        false; // Validation complete, hide circular progress indicator
      });
      const snackBar = SnackBar(
        content: Text('New Password and Confirm Password are not Matched!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;  // Return false if passwords do not match
    } else {
      return true;  // Return true if passwords match
    }
  }

  void _updatePassword() async {
    setState(() {
      _isButtonClicked =
      true; // Validation complete, hide circular progress indicator
    });
   if(checkConfirmPassword()){
     String currentPassword = _currentPasswordController.text;
     String newPassword = _passwordController.text;
     String confirmPassword = _confirmPasswordController.text;

     try {
       APIServicePasswordUpdate apiService = await APIServicePasswordUpdate
           .create();
       final response = await apiService.updatePassword(
         currentPassword: currentPassword,
         newPassword: newPassword,
         passwordConfirmation: confirmPassword,
       ).then((response) {
         setState(() {
           _isButtonClicked =
           false; // Validation complete, hide circular progress indicator
         });
         print("Submitted");
         print(response);
         if (response != null && response == "Password Update Successfully") {
           Navigator.pop(context);
           const snackBar = SnackBar(
             content: Text('Password Changed!'),
           );
           ScaffoldMessenger.of(context).showSnackBar(snackBar);
         }
         if (response != null && response == "The current password do not match.") {
           const snackBar = SnackBar(
             content: Text('Current Password is not Matched!'),
           );
           ScaffoldMessenger.of(context).showSnackBar(snackBar);
         }
       }).catchError((error) {
         // Handle registration error
         print(error);
         const snackBar = SnackBar(
           content: Text('Password Change failed!'),
         );
         ScaffoldMessenger.of(context).showSnackBar(snackBar);
       });
     } catch (e) {
       print('Error updating password: $e');
     }
   }
  }


}
