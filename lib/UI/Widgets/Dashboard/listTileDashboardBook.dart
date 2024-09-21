import 'package:flutter/material.dart';

//Convert
/// A widget that displays a book template using a ListTile with
/// title and price.
///
/// This widget is designed to present book details in a structured format,
/// displaying the book's [name] and [price].
///
/// **Parameters:**
/// - [name]: The title of the book.
/// - [price]: The price of the book.
class BookTemplate extends StatelessWidget {
  final int id;
  final String name;
  final String price;
  final String city;

  BookTemplate({
    required this.id,
    required this.name,
    required this.price,
    required this.city,
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
