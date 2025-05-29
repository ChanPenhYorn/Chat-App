// import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextformfieldInputformatter {
  // static phoneInputFormatter() {
  //   String mask = 'HS##########'; // Mask for Khmer phone numbers

  //   return MaskTextInputFormatter(
  //     mask: mask,
  //     filter: {
  //       'H': RegExp(r'^(0||855)'), // Allow '0' or '855' at the start
  //       'S': RegExp(r'^[1-9]'), // Second character must be a digit 1-9
  //       '#': RegExp(r'[0-9]'), // Any digit can follow
  //     },
  //   );
  // }

  static TextInputFormatter englishNameFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final formattedText = newValue.text.toUpperCase(); // Convert to uppercase
      return TextEditingValue(
        text: formattedText,
        selection: newValue.selection,
      );
    });
  }

  static TextInputFormatter toUpperCaseFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      return TextEditingValue(
        text: newValue.text.toUpperCase(), // Converts the input to uppercase
        selection: newValue.selection,
      );
    });
  }

  static TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase().toString(),
      selection: newValue.selection,
    );
  }

  // static khmerCurrencyFormatter(double value) {
  //   final formatCurrency = NumberFormat.currency(
  //     locale: 'km_KH', // Khmer locale
  //     symbol: '៛', // Riel symbol
  //     decimalDigits: 0, // No decimal digits
  //   );
  //   return formatCurrency.format(value);
  // }

  static TextEditingValue khmerPhone(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    if (newValue.text.startsWith('0')) {
      final newText = '855${newValue.text.substring(1)}';
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
    return newValue;
  }
}
