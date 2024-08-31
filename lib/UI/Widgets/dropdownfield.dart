import 'package:flutter/material.dart';

/// A custom form field that represents a dropdown menu with a [hintText]
/// and a list of selectable items. When an item is selected, the value
/// is passed to a callback function [onChanged].
class DropdownFormField extends StatefulWidget {
  final String hintText;
  final List<String> dropdownItems;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;

  DropdownFormField({
    required this.hintText,
    required this.dropdownItems,
    this.initialValue,
    this.onChanged,
  });

  @override
  _DropdownFormFieldState createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            value: _selectedValue,
            items: widget.dropdownItems.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'default',
                  ),
                  overflow: TextOverflow.visible,
                  maxLines: null,
                  softWrap: true,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
          ),
        ),
      ],
    );
  }
}
