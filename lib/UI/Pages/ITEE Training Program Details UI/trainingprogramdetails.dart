import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';


class ITEETrainingProgramDetails extends StatefulWidget {
  const ITEETrainingProgramDetails({super.key});

  @override
  State<ITEETrainingProgramDetails> createState() => _ITEETrainingProgramDetailsState();
}

class _ITEETrainingProgramDetailsState extends State<ITEETrainingProgramDetails> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final String url = 'https://www.facebook.com/bjet.org/';

  void _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
                    'Special Training Program to Enhance Job Opportunity in JAPAN!\n',
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 162, 222, 1),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('The main objective of this training program is to develop ICT Engineers to work in theJapanese IT company in Japanwith the skillset such as Japanese Language, IT skills (including ITEE Level 2 Exam preparation) and Japanese business manner. ITEE (FE) certified Trainee will get preference.\n\n This training program is organized by JICA and Bangladesh Computer Council (BCC).',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Duration: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: 'default',
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: '3 Months',
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'default',
                            fontSize: 20,
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
                          text: 'Course Fee: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: 'default',
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: 'No Payment required (Funded by JICA)',
                          style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'default',
                            fontSize: 20,
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
                          text: 'For further information, please visit: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: 'default',
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: 'https://www.facebook.com/bjet.org/',
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'default',
                            fontSize: 20,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = _launchURL,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

