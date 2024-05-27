import 'package:flutter/material.dart';

Widget buildNoRequestsWidget(double screenWidth, String message) {
  return Material(
    elevation: 5,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      height: 200, // Adjust height as needed
      width: screenWidth, // Adjust width as needed
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
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
          Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
