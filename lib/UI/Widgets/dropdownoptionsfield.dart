import 'package:flutter/material.dart';

/// A helper class to build a dropdown form field based on a map of options
/// and a selected value. It provides a label text and an [onChanged] callback
/// for handling changes in the selected value.
///
/// The [DropdownFormFieldBuilder] takes the following parameters:
/// - [options]: A map where the key is a string representing the category,
///   and the value is a list of strings representing the selectable options.
/// - [labelText]: A string to display as the label for the dropdown.
/// - [selectedValue]: The currently selected value, which can be null.
/// - [onChanged]: A callback function that is triggered when the selected
///   value changes.
class DropdownFormFieldBuilder {
  final Map<String, List<String>> options;
  final String labelText;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;

  DropdownFormFieldBuilder({
    required this.options,
    required this.labelText,
    required this.selectedValue,
    required this.onChanged,
  });

  Widget build(BuildContext context) {
    final List<String> items = selectedValue != null ? options[selectedValue!]! : [];

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.085,
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
