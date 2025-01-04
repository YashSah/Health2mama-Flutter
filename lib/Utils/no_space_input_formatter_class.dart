import 'package:flutter/services.dart';

// Custom InputFormatter to prevent spaces
class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.contains(' ')) {
      // If newValue contains space, return oldValue to prevent updating the value
      return oldValue;
    }
    return newValue;
  }
}
