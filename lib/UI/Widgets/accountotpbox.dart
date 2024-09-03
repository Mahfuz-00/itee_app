import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom text form field designed for single-digit numeric input
/// commonly used in account number fields.
///
/// This widget is used to create a text field that restricts input to
/// single digits and allows for automatic focus shifting to the
/// next field when filled.
///
/// The [textController] controls the text displayed in the field,
/// while [currentFocusNode] manages the focus state of this field.
/// If [nextFocusNode] is provided, it will automatically receive focus
/// when the current field is filled.
class CustomTextBox extends StatelessWidget {
  final TextEditingController textController;
  /// The FocusNode associated with this text field.
  final FocusNode currentFocusNode;
  /// The optional FocusNode to automatically focus on when the
  /// current field is filled.
  final FocusNode? nextFocusNode;

  const CustomTextBox({
    Key? key,
    required this.textController,
    required this.currentFocusNode,
    this.nextFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: 65,
      alignment: Alignment.center,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: textController,
        focusNode: currentFocusNode,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: const TextStyle(
          color: Color.fromRGBO(143, 150, 158, 1),
          fontSize: 35,
          fontWeight: FontWeight.bold,
          fontFamily: 'default',
        ),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(0, 162, 222, 1),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(0, 162, 222, 1),
              width: 2.0,
            ),
          ),
          labelText: '',
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            nextFocusNode!.requestFocus();
          }
        },
      ),
    );
  }
}
