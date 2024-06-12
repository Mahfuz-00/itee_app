import 'package:flutter/material.dart';

class ItemTemplate extends StatelessWidget {
  final int serialNumber;
  final String name;
  final String price;

  ItemTemplate({
    required this.serialNumber,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$serialNumber.',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color.fromRGBO(
                    143, 150, 158, 1),
                fontSize: 16,
                fontFamily: 'default',
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              name,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color.fromRGBO(
                    143, 150, 158, 1),
                fontSize: 16,
                fontFamily: 'default',
              ),
            ),
          ),
         // Spacer(), // Add a spacer to fill the remaining space
          Expanded(
            flex: 2,
            child: Text(
              price,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color.fromRGBO(
                    143, 150, 158, 1),
                fontSize: 16,
                fontFamily: 'default',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
