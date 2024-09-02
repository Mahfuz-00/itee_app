import 'package:flutter/material.dart';

//Convert
/// A widget that displays an application item template using a ListTile with
/// applicant [name], [ExamineeID], [Categories], [result], [payment], and [admitcard] status.
///
/// This widget is designed to present application details in a structured format,
/// displaying the applicant's name, ID, and categories along with their result,
/// payment, and admit card status.
///
/// **Parameters:**
/// - [name]: The name of the applicant.
/// - [ExamineeID]: The ID of the examinee.
/// - [Categories]: The categories associated with the application.
/// - [result]: The result status of the application.
/// - [payment]: The payment status of the application.
/// - [admitcard]: The admit card status of the application.
class ApplicationItemTemplate extends StatelessWidget {
  final String name;
  final String ExamineeID;
  final String Categories;
  final int result;
  final int payment;
  final int admitcard;

  ApplicationItemTemplate({
    required this.name,
    required this.ExamineeID,
    required this.Categories,
    required this.result,
    required this.payment,
    required this.admitcard,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          Text(
            name,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color.fromRGBO(
                  143, 150, 158, 1),
              fontSize: 16,
              fontFamily: 'default',
            ),
          ),
          SizedBox(height: 5),
          Text(
            ExamineeID,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color.fromRGBO(
                  143, 150, 158, 1),
              fontSize: 16,
              fontFamily: 'default',
            ),
          ),
          SizedBox(height: 5),
          Text(
            Categories,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Color.fromRGBO(
                  143, 150, 158, 1),
              fontSize: 16,
              fontFamily: 'default',
            ),
          ),
        ],
      ),
    );
  }
}
