import 'package:chatapp/utils/app_colors.dart';
import 'package:chatapp/utils/enum/textformfiled_enum.dart';
import 'package:chatapp/utils/formatter/textformfield_inputformatter.dart';
import 'package:chatapp/utils/regular_expression_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AppTextformfieldWidget extends StatelessWidget {
  const AppTextformfieldWidget(
      {super.key,
      required this.controller,
      this.onChanged,
      this.hintText,
      this.suffixIcon,
      this.obscureText = false,
      this.keyboardType,
      this.prefixIcon,
      this.textAlign = TextAlign.start,
      this.prefixOnTap,
      this.suffixOnTap,
      this.type,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.isRequried = true,
      this.isEnable = true,
      this.maxLines,
      this.minLines,
      this.textStyle,
      this.contentPadding,
      this.focusNode,
      this.fillColor,
      this.maxLength,
      this.autocorrect = true,
      this.enableSuggestions = false});
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? hintText;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final TextAlign textAlign;
  final void Function()? prefixOnTap;
  final void Function()? suffixOnTap;
  final TextformfieldEnum? type;
  final AutovalidateMode? autovalidateMode;
  final bool? isRequried;
  final bool isEnable;
  final int? maxLines;
  final int? minLines;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final Color? fillColor;
  final int? maxLength;
  final bool autocorrect;
  final bool enableSuggestions;

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter>? inputFormatters = _getInputFormatters(type);

    return TextFormField(
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      focusNode: focusNode,
      maxLength: maxLength,
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      enabled: isEnable,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
      textAlign: textAlign,
      keyboardType: keyboardType,
      obscureText: obscureText!,
      controller: controller,
      style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        counterText: '', // Remove counter text
        errorStyle: const TextStyle(
          color: Colors.red, // Customize error text color
          fontSize: 14, // Customize error text size
        ),
        counterStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: HexColor("#f2f2f7"), fontWeight: FontWeight.w500),
        fillColor: fillColor ?? Theme.of(context).colorScheme.primaryContainer,
        filled: true,
        focusColor: HexColor("#f2f2f7"),
        hoverColor: HexColor("#f2f2f7"),
        prefixIconColor: Colors.grey,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        hintText: hintText ?? 'hint',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10)),
        suffixIcon: type == TextformfieldEnum.password
            ? GestureDetector(
                onTap: suffixOnTap,
                child: Icon(
                  obscureText == true
                      ? Icons.visibility_off
                      : Icons.remove_red_eye,
                  color: Colors.grey[800],
                ),
              )
            : suffixIcon == null
                ? null
                : GestureDetector(onTap: suffixOnTap, child: suffixIcon),
        prefixIcon: prefixIcon == null
            ? null
            : GestureDetector(onTap: prefixOnTap, child: prefixIcon),
      ),
      onChanged: onChanged,
      validator: validationMethod,
    );
  }

  List<TextInputFormatter>? _getInputFormatters(TextformfieldEnum? type) {
    switch (type) {
      // case TextformfieldEnum.phone:
      //   return [TextformfieldInputformatter.phoneInputFormatter()];
      case TextformfieldEnum.name:
        return [TextformfieldInputformatter.toUpperCaseFormatter()];
      case TextformfieldEnum.password:
      default:
        return []; // Default case, no special formatting
    }
  }

  String? validationMethod(String? value) {
    if (value == null || value.isEmpty && isRequried == true) {
      return 'field_required'.tr; // Improved error message
    }

    switch (type) {
      case TextformfieldEnum.email:
        if (!RegularExpressionConstant().emailRegex.hasMatch(value)) {
          return 'message.invalid_email_format'
              .tr; // Correct spelling and clearer message
        }
        break;
      case TextformfieldEnum.name:
        if (!RegularExpressionConstant().englishNameRegexp.hasMatch(value)) {
          return 'Name should contain English characters only'; // Improved message for clarity
        }
        break;
      case TextformfieldEnum
            .password: // Corrected the typo from 'passwoord' to 'password'
        if (!RegularExpressionConstant().passwordRegexp.hasMatch(value)) {
          return 'message.password_at_least'.tr; // Improved message
        }
        break;
      default:
        break; // Default case, no validation
    }

    return null; // Return null if validation passes
  }
}
