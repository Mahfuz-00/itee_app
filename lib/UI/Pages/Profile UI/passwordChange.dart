import '../../../Data/Data Sources/API Service (User Info Update)/apiServicePasswordUpdate.dart';
import '../../Widgets/custombottomnavbar.dart';
import 'package:flutter/material.dart';

/// A screen that allows users to change their password.
///
/// The [PasswordChangeUI] screen provides fields for entering the current password,
/// new password, and confirming the new password. It also includes password visibility
/// toggles and validation to ensure that the passwords meet the required criteria.
///
/// ## Parameters:
/// - [_currentPasswordController]: A controller for the current password field.
/// - [_passwordController]: A controller for the new password field.
/// - [_confirmPasswordController]: A controller for the confirm password field.
/// - [_isObscuredCurrentPassword]: A boolean that controls the visibility of the current password field.
/// - [_isObscuredPassword]: A boolean that controls the visibility of the new password field.
/// - [_isObscuredConfirmPassword]: A boolean that controls the visibility of the confirm password field.
/// - [_isButtonClicked]: A boolean that indicates whether the update button has been clicked.
///
/// ## Actions:
/// - Toggles the visibility of the password fields using icon buttons.
/// - Validates the passwords to ensure that they are at least 8 characters long and that the new password
///   and confirm password fields match.
/// - Submits the password update request to the API service when the update button is clicked.
/// - Displays appropriate success or error messages based on the API response.
class PasswordChangeUI extends StatefulWidget {
  @override
  State<PasswordChangeUI> createState() => _PasswordChangeUIState();
}

class _PasswordChangeUIState extends State<PasswordChangeUI> {
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
                        ? CircularProgressIndicator()
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
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  bool checkConfirmPassword() {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _isButtonClicked =
        false;
      });
      const snackBar = SnackBar(
        content: Text('New Password and Confirm Password are not Matched!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    } else {
      return true;
    }
  }

  void _updatePassword() async {
    setState(() {
      _isButtonClicked =
      true;
    });
   if(checkConfirmPassword()){
     String currentPassword = _currentPasswordController.text;
     String newPassword = _passwordController.text;
     String confirmPassword = _confirmPasswordController.text;

     try {
       PasswordUpdateAPIService apiService = await PasswordUpdateAPIService
           .create();
       final response = await apiService.updatePassword(
         currentPassword: currentPassword,
         newPassword: newPassword,
         passwordConfirmation: confirmPassword,
       ).then((response) {
         setState(() {
           _isButtonClicked =
           false;
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
