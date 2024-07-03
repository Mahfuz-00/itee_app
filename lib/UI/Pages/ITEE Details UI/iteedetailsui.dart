import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';


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
      ),
    );
  }
}

