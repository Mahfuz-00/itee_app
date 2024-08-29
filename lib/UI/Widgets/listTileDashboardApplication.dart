import 'package:flutter/material.dart';


//Convert
class ApplicationItemTemplate extends StatelessWidget {
  final String name;
  final String ExamineeID;
  final String Catagories;
  final int result;
  final int payment;
  final int admitcard;

  ApplicationItemTemplate({
    required this.name,
    required this.ExamineeID,
    required this.Catagories,
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
            Catagories,
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
