import 'package:flutter/material.dart';

class ExamItemTemplate extends StatelessWidget {
  final String name;
  final String Catagories;
  final String price;
  final int priceID;
  final String Details;
  final String typeID;
  final String CatagoryID;

  ExamItemTemplate({
    required this.name,
    required this.Catagories,
    required this.price,
    required this.priceID,
    required this.Details,
    required this.typeID,
    required this.CatagoryID,
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
