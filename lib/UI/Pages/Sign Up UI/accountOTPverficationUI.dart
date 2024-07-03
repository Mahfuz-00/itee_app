import 'package:flutter/services.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:itee_exam_app/UI/Pages/Sign%20Up%20UI/AccountCreatedUI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Sign Up)/apiServiceAccountOTPVerification.dart';
import '../../Widgets/accountotpbox.dart';


class AccountOPTVerfication extends StatefulWidget {
  const AccountOPTVerfication({super.key});

  @override
  State<AccountOPTVerfication> createState() => _AccountOPTVerficationState();
}

class _AccountOPTVerficationState extends State<AccountOPTVerfication> {
  bool _isLoading = true;
  late TextEditingController _firstdigitcontroller = TextEditingController();
  late TextEditingController _seconddigitcontroller = TextEditingController();
  late TextEditingController _thirddigitcontroller = TextEditingController();
  late TextEditingController _forthdigitcontroller = TextEditingController();
  late TextEditingController _fifthdigitcontroller = TextEditingController();
  late TextEditingController _sixthdigitcontroller = TextEditingController();
  late TextEditingController _seventhdigitcontroller = TextEditingController();
  late TextEditingController _eighthdigitcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _sendOTP(String email, String OTP) async {
    final apiService = await APIServiceAccountOTPVerification.create();
    apiService.AccountOTPVerification(email, OTP).then((response) {
      if (response == 'User Registration Successfully') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccountCreated()));
      } else if (response ==
          'Otp not match. Please resend forget password otp') {
        const snackBar = SnackBar(
          content: Text('OTP did not Match. Try again!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).catchError((error) {
      // Handle registration error
      print(error);
      const snackBar = SnackBar(
        content: Text('OTP did not Match. Try again!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    // Navigate to OTP verification screen
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return _isLoading
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
              body: SafeArea(
                  child: Container(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(0, 162, 222, 1),
                                width: 2),
                            // Border properties
                            borderRadius: BorderRadius.circular(
                                10), // Optional: Rounded border
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Handle back button press here
                              Navigator.pop(
                                  context); // This will pop the current route off the navigator stack
                            },
                            icon: Icon(Icons.arrow_back_ios),
                            iconSize: 30,
                            padding: EdgeInsets.all(10),
                            splashRadius: 30,
                            color: Color.fromRGBO(0, 162, 222, 1),
                            splashColor: Colors.grey,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  'OTP Verification',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 162, 222, 1),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default'),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, right: 30.0),
                                  child: Text(
                                    'Enter the Verification code we just sent on your email address',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(143, 150, 158, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                                Container(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AccountCustomTextFormField(
                                            textController:
                                                _firstdigitcontroller,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          AccountCustomTextFormField(
                                            textController:
                                                _seconddigitcontroller,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          AccountCustomTextFormField(
                                            textController:
                                                _thirddigitcontroller,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          AccountCustomTextFormField(
                                            textController:
                                                _forthdigitcontroller,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          AccountCustomTextFormField(
                                            textController:
                                                _fifthdigitcontroller,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          AccountCustomTextFormField(
                                            textController:
                                                _sixthdigitcontroller,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          AccountCustomTextFormField(
                                            textController:
                                                _seventhdigitcontroller,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          AccountCustomTextFormField(
                                            textController:
                                                _eighthdigitcontroller,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      if (_firstdigitcontroller.text.isNotEmpty &&
                                          _seconddigitcontroller
                                              .text.isNotEmpty &&
                                          _thirddigitcontroller
                                              .text.isNotEmpty &&
                                          _forthdigitcontroller
                                              .text.isNotEmpty &&
                                          _fifthdigitcontroller
                                              .text.isNotEmpty &&
                                          _sixthdigitcontroller
                                              .text.isNotEmpty &&
                                          _seventhdigitcontroller
                                              .text.isNotEmpty &&
                                          _eighthdigitcontroller
                                              .text.isNotEmpty) {
                                        String OTP =
                                            _firstdigitcontroller.text +
                                                _seconddigitcontroller.text +
                                                _thirddigitcontroller.text +
                                                _forthdigitcontroller.text +
                                                _fifthdigitcontroller.text +
                                                _sixthdigitcontroller.text +
                                                _seventhdigitcontroller.text +
                                                _eighthdigitcontroller.text;
                                        print(OTP);
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        String email =
                                            await prefs.getString('Email') ??
                                                '';
                                        print(email);
                                        _sendOTP(email, OTP);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(0, 162, 222, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fixedSize: Size(screenWidth * 0.9, 70),
                                    ),
                                    child: const Text('Verify',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'default',
                                        ))),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Footer(
                        backgroundColor: Color.fromRGBO(246, 246, 246, 255),
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Didn\'t recived code?  ',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    /*Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Login()));*/
                                  },
                                  child: Text(
                                    'Resend',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
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
              )),
            ),
          );
  }
}
