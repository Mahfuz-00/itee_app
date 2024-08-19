import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentCard extends StatelessWidget {
  final String ExamineeID;
  final String ExamType;
  final String ExamCatagory;
  final String BookName;
  final String BookFee;


  const PaymentCard({
    Key? key,
    required this.ExamineeID,
    required this.ExamType,
    required this.ExamCatagory,
    required this.BookName,
    required this.BookFee,
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
                _buildRow('Exam Type', ExamType),
                _buildRow('Exam Catagories', ExamCatagory),
                _buildRow('Book Name', BookName),
                _buildRow('Book Fee', BookFee),
                ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(0, 162, 222, 1), // Background color
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                    side: BorderSide(color: Colors.white, width: 2.0), // Border
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.7,
                    alignment: Alignment.center,
                    child: Text(
                      'Pay Now',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                )
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
