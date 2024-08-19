import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../B-Jet Details UI/B-jetDetailsUI.dart';
import '../Dashboard UI/dashboardUI.dart';
import '../ITEE Training Program Details UI/trainingprogramdetails.dart';


class ITEEDetails extends StatefulWidget {
  const ITEEDetails({super.key});

  @override
  State<ITEEDetails> createState() => _ITEEDetailsState();
}

class _ITEEDetailsState extends State<ITEEDetails> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetChecker(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 162, 222, 1),
          titleSpacing: 5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'ITEE Training Program',
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
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ABOUT ITEE',
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 162, 222, 1),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('ITEE stands for Information Technology Engineers Examination. ITEE is the national level IT Engineers Examination governed by IPA, Japan. It is one of the largest scale national qualification examinations in Japan, with approximately 600,000 applicants each year. ITEE examination is conducted on the same date and time with the same set of questions among all the ITPEC (Information Technology Professionals Examination Council) member countries.The examination is conducted twice a year, generally in April and October.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'default',
                    ),),
                  SizedBox(height: 10),
                  Text(
                    'There are currently 4 exams being offered by ITPEC:',
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 162, 222, 1),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Level-1: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: 'IT Passport Exam ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '(IP): ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '[This examination is suitable for IT & non-IT professionals and graduates.]',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Level-2: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: 'Fundamental Information Technology Engineer Examination ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '(FE): ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '[This examination is suitable for IT professionals/graduates and 4th years’ CSE/IT related students.]',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Level-3: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: 'Applied Information Technology Engineer Examination ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '(AP) ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '[This examination is suitable for experienced IT professionals.]',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Level-4: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: 'Advanced Examination ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '(AE) ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '[This examination is suitable for domain specific experienced IT professionals.]',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(
                    'ITEE in Bangladesh',
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 162, 222, 1),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Bangladesh government is conducting and implementing ITEE in Bangladesh by Bangladesh IT-engineers Examination Center (BD-ITEC) of Bangladesh Computer Council under the umbrella of ICT Division, Ministry of Posts, Telecommunications & IT. It is the national level examination for IT professionals/graduates in Bangladesh. Non-IT Professionals/graduates also can achieve international recognition for their IT knowledge & skills. BD-ITEC is conducting ITEE in Bangladesh from October 2013 regularly. The following two exams are conducted in Bangladesh now:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'default',
                    ),),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Level-1: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: 'IT Passport Exam ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '(IP): ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '[This examination is suitable for IT & non-IT professionals and graduates.]',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Level-2: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: 'Fundamental Information Technology Engineer Examination ',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '(FE): ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        TextSpan(
                          text: '[This examination is suitable for IT professionals/graduates and 4th years’ CSE/IT related students.]',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,)
                ],
              ),
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
                  width: screenWidth / 4,
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
          /*    GestureDetector(
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
              ),*/
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BJetDetails()));
                },
                child: Container(
                  width: screenWidth / 4,
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
                  width: screenWidth / 4,
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
                  width: screenWidth / 4,
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

}

