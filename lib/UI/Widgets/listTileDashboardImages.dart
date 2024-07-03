import 'package:flutter/material.dart';

class ItemTemplateImages extends StatelessWidget {
  final String label;
  final String images;

  ItemTemplateImages({
    required this.label,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              images,
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
        ],
      ),
    );
  }
}
