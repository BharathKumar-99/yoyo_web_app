import 'package:flutter/services.dart';

class ActivationCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove anything that's not alphanumeric
    String text = newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');

    // Limit to 6 characters
    if (text.length > 6) {
      text = text.substring(0, 6);
    }

    // Insert '-' after 3 characters
    if (text.length > 3) {
      text = '${text.substring(0, 3)}-${text.substring(3)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
