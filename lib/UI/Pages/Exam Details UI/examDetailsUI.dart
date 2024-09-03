import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../Widgets/custombottomnavbar.dart';

/// Represents the Exam Details screen that displays specific details about an exam.
///
/// This widget takes the exam details as a parameter and displays it in the UI.
///
/// **Variables:**
/// - [details]: Contains the details of the exam to be displayed.
class ExamDetailsUI extends StatefulWidget {
  final String details;
  const ExamDetailsUI({Key? key, required this.details}) : super(key: key);

  @override
  State<ExamDetailsUI> createState() => _ExamDetailsUIState();
}

class _ExamDetailsUIState extends State<ExamDetailsUI> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetConnectionChecker(
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
            'Exam Details',
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
                    widget.details,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontFamily: 'default',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(),
      ),
    );
  }
}
