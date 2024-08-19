import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ResultCard extends StatelessWidget {
  final String PasserID;
  final String ExamineeID;
  final String Name;
  final String DateOfBirth;
  final String MorningPasser;
  final String AfternoonPasser;
  final String PassingSession;
  final String ExamType;

  const ResultCard({
    Key? key,
    required this.PasserID,
    required this.ExamineeID,
    required this.Name,
    required this.DateOfBirth,
    required this.MorningPasser,
    required this.AfternoonPasser,
    required this.PassingSession,
    required this.ExamType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white, // Sets the background color of the card.
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow('Examinee ID', ExamineeID),
                _buildRow('Name', Name),
                _buildRow('Date of Birth', DateOfBirth),
                _buildRow('Exam Type', ExamType),
                _buildRow('Exam Session', PassingSession),
                if (MorningPasser == 1 && AfternoonPasser == 0) ...[
                  _buildRow('Result', 'Morning Passed'),
                ]
                else
                  if (MorningPasser == 0 && AfternoonPasser == 1) ...[
                    _buildRow('Result', 'Afternoon Passed'),
                  ]
                  else
                    if (MorningPasser == 1 && AfternoonPasser == 1) ...[
                      _buildRow('Result', 'Both Passed'),
                    ]
                    else
                      ... [
                        _buildRow('Result', 'Not Passed'),
                      ],
                if(MorningPasser == 1 || AfternoonPasser == 1) ...[
                  _buildRow('Passing ID', PasserID)
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildRow(String label, String value) {
  return Container(
    child: Row(
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
    ),
  );
}

Widget _buildRowApplicationID(String label, int value) {
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
                text: value.toString(),
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

Widget _buildRowTime(String label, String value) {
  //String formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a').format(value); // 'a' for AM/PM

  // Option 2: Using separate methods for date and time
  DateTime date = DateTime.parse(value);
  DateFormat dateFormat = DateFormat.yMMMMd('en_US');
  DateFormat timeFormat = DateFormat.jm();
  String formattedDate = dateFormat.format(date);
  String formattedTime = timeFormat.format(date);
  String formattedDateTime = '$formattedDate, $formattedTime';
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
      Expanded(
        child: Text(
          formattedDateTime, // Format date as DD/MM/YYYY
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            height: 1.6,
            letterSpacing: 1.3,
            fontWeight: FontWeight.bold,
            fontFamily: 'default',
          ),
        ),
      ),
    ],
  );
}
