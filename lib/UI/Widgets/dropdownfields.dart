import 'package:flutter/material.dart';

/// A custom form field that represents a dropdown menu with a [hintText]
/// and a list of selectable items. When an item is selected, the value
/// is passed to a callback function [onChanged].
///
/// The [DropdownField] takes the following parameters:
/// - [hintText]: A string to display as a hint in the dropdown.
/// - [dropdownItems]: A list of [DropdownMenuItem<T>] representing the selectable items.
/// - [initialValue]: The initial value of the dropdown (optional).
/// - [onChanged]: A callback function that is called when a new item is selected (optional).
class DropdownField<T> extends StatefulWidget {
  final String hintText;
  final List<DropdownMenuItem<T>> dropdownItems;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;

  DropdownField({
    required this.hintText,
    required this.dropdownItems,
    this.initialValue,
    this.onChanged,
  });

  @override
  _DropdownFormFieldState<T> createState() => _DropdownFormFieldState<T>();
}

class _DropdownFormFieldState<T> extends State<DropdownField<T>> {
  late T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'default',
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Color.fromRGBO(143, 150, 158, 1),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'default',
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: _selectedValue,
      items: widget.dropdownItems,
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}
