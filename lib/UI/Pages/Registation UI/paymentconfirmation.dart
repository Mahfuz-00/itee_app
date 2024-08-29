import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Payment)/apiServicePayment.dart';
import '../B-Jet Details UI/B-jetDetailsUI.dart';
import '../Dashboard UI/dashboardUI.dart';
import '../ITEE Details UI/iteedetailsui.dart';
import '../ITEE Training Program Details UI/trainingprogramdetails.dart';

class PaymentConfirmation extends StatefulWidget {
  final String ExamineeID;
  const PaymentConfirmation({Key? key, required this.ExamineeID})
      : super(key: key);

  @override
  State<PaymentConfirmation> createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _paymentConfirmationController =
      TextEditingController();
  bool buttonloading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetChecker(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[100],
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
            titleSpacing: 5,
            automaticallyImplyLeading: false,
            title: const Text(
              'Payment Confirmation',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'default',
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  //height: screenHeight,
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image(
                          image: AssetImage('Assets/Images/Success-Mark.png'),
                          height: 150,
                          width: 150,
                          alignment: Alignment.center,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Center(
                        child: Text(
                          'Congratulations, Your Registration Successfully Submitted',
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
                        child: Text(
                          'Your ID: ${widget.ExamineeID}',
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
                        height: 35,
                      ),
                      Center(
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.85,
                                  MediaQuery.of(context).size.height * 0.08),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () {
                              showSliderAlert(context);
                            },
                            child: const Text('Click here for payment',
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
              ],
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

  void showSliderAlert(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 600,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Bkash Payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 162, 222, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Trx ID',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: const Color.fromRGBO(0, 162, 222, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: 380,
                  height: 70,
                  child: TextFormField(
                    controller: _paymentConfirmationController,
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
                      labelText: 'Trx ID',
                      labelStyle: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                'Enter the Transaction ID from Bkash Payment',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Color.fromRGBO(143, 150, 158, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'default',
                ),
              ),
              SizedBox(height: 45),
              Center(
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                          MediaQuery.of(context).size.height * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        buttonloading = true;
                      });
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      int id = prefs.getInt('exam_registration_id') ?? 0;
                      print(id);
                      final apiService = await PaymentAPIService.create();

                      final registrationSuccessful =
                          await apiService.sendIdsFromSharedPreferences(
                              _paymentConfirmationController.text, id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Dashboard(
                                    shouldRefresh: true,
                                  )));
                    },
                    child: buttonloading
                        ? CircularProgressIndicator()
                        : const Text('Confirm',
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
        );
      },
    );
  }
}
