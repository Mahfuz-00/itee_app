import 'package:flutter/material.dart';

/// A widget that displays a [notice] using a ListTile with centered content.
///
/// This widget is designed to present a single [notice] in a structured
/// format, allowing for easy readability and clear presentation.
///
/// **Parameters:**
/// - [notice]: The text content of the notice to be displayed.
class ItemTemplateNotice extends StatelessWidget {
  final String notice;

  ItemTemplateNotice({
    required this.notice,
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
              notice,
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
