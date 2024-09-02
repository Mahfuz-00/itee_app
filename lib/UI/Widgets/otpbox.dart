import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Del
/// A custom text form field designed for entering a single-digit numeric value.
///
/// This widget provides a text field that restricts input to a single digit,
/// allowing only numeric input. It is primarily used for entering codes or
/// similar short numeric values.
///
/// **Parameters:**
/// - [textController]: The controller that manages the text being edited.
class CustomTextFormField extends StatelessWidget {
  final TextEditingController textController;

  const CustomTextFormField({
    Key? key,
    required this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      height: 70,
      alignment: Alignment.center,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: textController,
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
        decoration: InputDecoration(
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
      ),
    );
  }
}
