import 'package:flutter/material.dart';

//Convert
/// A widget that displays an exam item template using a ListTile with
/// important details like [image], [name], [Catagories], and [price].
///
/// This widget is designed to present exam details in a structured format,
/// displaying the exam's [image], [name], [Catagories], and [price].
///
/// **Parameters:**
/// - [image]: The URL of the exam's image.
/// - [name]: The name of the exam.
/// - [Catagories]: The categories the exam belongs to.
/// - [price]: The price of the exam.
/// - [priceID]: The ID associated with the price.
/// - [Details]: Additional details about the exam.
/// - [typeID]: The ID representing the type of exam.
/// - [CatagoryID]: The ID representing the category of the exam.
class ExamItemTemplate extends StatelessWidget {
  final String image;
  final String name;
  final String Catagories;
  final String price;
  final int priceID;
  final String Details;
  final String typeID;
  final String CatagoryID;

  ExamItemTemplate({
    required this.image,
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
