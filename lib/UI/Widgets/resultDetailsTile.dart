import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Del
/// A widget that displays a card with an examinee's result information
/// including [Name], [ExamName], and [Result].
class ResultInfoCard extends StatelessWidget {
  final String Name;
  final String ExamName;
  final String Result;

  const ResultInfoCard({
    Key? key,
    required this.Name,
    required this.ExamName,
    required this.Result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Result',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  height: 1.6,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
            ),
            Divider(),
            _buildRow('Name', Name),
            _buildRow('Exam', ExamName),
            _buildRow('Result', Result.toString()),
          ],
        ),
      ),
    );
  }
}

Widget _buildRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  height: 1.6,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          ":",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  height: 1.6,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
