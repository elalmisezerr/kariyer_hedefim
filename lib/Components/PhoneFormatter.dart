import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    // Remove any non-digit characters from the input string
    text = text.replaceAll(RegExp(r'\D+'), '');

    var newText = '';
    var textLength = text.length;

    // Format the input string as a phone number
    if (textLength >= 1) {
      newText += '(' + text.substring(0, 3) + ') ';
    }
    if (textLength >= 4) {
      newText += text.substring(3, 6) + '-';
    }
    if (textLength >= 6) {
      newText += text.substring(5, 9);
    }
    if (textLength >= 10) {
      newText += text.substring(9, textLength);
    }

    // Return the updated text editing value
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
