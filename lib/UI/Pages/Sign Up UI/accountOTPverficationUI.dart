import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:footer/footer.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Sign Up)/apiServiceAccountOTPVerification.dart';
import '../../Widgets/accountotpbox.dart';
import 'AccountCreatedUI.dart';

/// A screen for OTP (One Time Password) verification during account creation.
///
/// This widget prompts the user to enter the OTP sent to their email address.
/// It handles the OTP input through eight separate text fields, verifies the OTP
/// against the server, and provides feedback to the user about the verification status.
///
/// - **Fields:**
///   - [_isLoading]: A boolean indicating whether the loading spinner is displayed.
///   - [_controllers]: A list of [TextEditingController] for managing the OTP input fields.
///   - [_focusNodes]: A list of [FocusNode] for managing the focus of the OTP input fields.
///
/// - **Methods:**
///   - `_sendOTP(String email, String OTP)`: Sends the entered [OTP] to the server for verification.
class AccountOPTVerfication extends StatefulWidget {
  const AccountOPTVerfication({super.key});

  @override
  State<AccountOPTVerfication> createState() => _AccountOPTVerficationState();
}

class _AccountOPTVerficationState extends State<AccountOPTVerfication> {
  bool _isLoading = true;

  final List<TextEditingController> _controllers = List.generate(8, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(8, (index) => FocusNode());

  @override
  void initState() {
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
      const snackBar = SnackBar(
        content: Text('OTP did not Match. Try again!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return _isLoading
        ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios),
                          iconSize: 30,
                          padding: EdgeInsets.all(10),
                          splashRadius: 30,
                          color: Color.fromRGBO(0, 162, 222, 1),
                          splashColor: Colors.grey,
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
                                padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(8, (index) {
                                    return Row(
                                      children: [
                                        CustomFocusedTextFormField(
                                          textController: _controllers[index],
                                          currentFocusNode: _focusNodes[index],
                                          nextFocusNode: index < 7 ? _focusNodes[index + 1] : null,
                                        ),
                                        if (index < 7) SizedBox(width: 5),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(height: 50),
                              ElevatedButton(
                                  onPressed: () async {
                                    bool allFieldsFilled = _controllers.every((controller) => controller.text.isNotEmpty);

                                    if (allFieldsFilled) {
                                      String OTP = _controllers.map((controller) => controller.text).join();
                                      final prefs = await SharedPreferences.getInstance();
                                      String email = prefs.getString('Email') ?? '';
                                      _sendOTP(email, OTP);
                                    } else {
                                      const snackBar = SnackBar(
                                        content: Text('Please fill all OTP fields'),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(0, 162, 222, 1),
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
                    const SizedBox(height: 20),
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
                              const Text(
                                'Didn\'t receive code?  ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: const Text(
                                  'Resend',
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
            )),
      ),
    );
  }
}
