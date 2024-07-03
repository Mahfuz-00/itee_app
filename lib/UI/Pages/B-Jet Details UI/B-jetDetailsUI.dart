import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';


class BJetDetails extends StatefulWidget {
  const BJetDetails({super.key});

  @override
  State<BJetDetails> createState() => _BJetDetailsState();
}

class _BJetDetailsState extends State<BJetDetails> with SingleTickerProviderStateMixin{
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
            'B-Jet Program',
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
                    'What is B-JET (Bangladesh-Japan ICT Engineers\' Training Program)?\n',
                    style: TextStyle(
                      color: const Color.fromRGBO(0, 162, 222, 1),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('The B-JET Program was launched in 2017 as a technical cooperation project by JICA, with the Bangladesh Computer Council as its counterpart.\n\nThe purpose of this project is to implement a human resources development program for talented ICT engineers in Bangladesh targeting the Japanese market.\n\nAfter completing the three-month training program, students are expected to find employment in Japan, participate in study abroad or internship programs, or find employment at a Japanese company in Bangladesh.\n\nThe course began in November 2017 with a first class of 20 students, followed by 40 students in the second class and onwards, with the aim of producing a total of more than 300 graduates by 2020, with a final class of 9 students.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),),
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
