import 'package:flutter/material.dart';

Widget buildNoRequestsWidget(double screenWidth, String message) {
  return Container(
    height: 200, // Adjust height as needed
    width: screenWidth, // Adjust width as needed
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
  );
}
