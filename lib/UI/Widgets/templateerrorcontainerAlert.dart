import 'package:flutter/material.dart';

Widget buildNoRequestsWidgetAlert(double screenWidth, String message) {
  return Material(
    elevation: 5,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      height: 200,
      width: screenWidth,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
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
    ),
  );
}
