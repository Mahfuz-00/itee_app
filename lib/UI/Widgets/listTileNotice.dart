import 'package:flutter/material.dart';

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
