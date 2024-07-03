import 'package:flutter/material.dart';

class ExamItemTemplate extends StatelessWidget {
  final String name;
  final String Catagories;
  final String price;

  ExamItemTemplate({
    required this.name,
    required this.Catagories,
    required this.price,
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
            price,
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
