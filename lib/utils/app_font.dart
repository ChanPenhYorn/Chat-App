import 'package:flutter/material.dart';

class AppFont {
  static String fontFamily = 'KantumruyPro';

  static TextStyle getTextStyle({
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    double fontSize = 14.0,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle bold({
    double fontSize = 14.0,
    Color color = Colors.black,
  }) {
    return getTextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle medium({
    double fontSize = 14.0,
    Color color = Colors.black,
  }) {
    return getTextStyle(
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle italic({
    double fontSize = 14.0,
    Color color = Colors.black,
  }) {
    return getTextStyle(
      fontStyle: FontStyle.italic,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle regular({
    double fontSize = 14.0,
    Color color = Colors.black,
  }) {
    return getTextStyle(
      fontWeight: FontWeight.normal,
      fontSize: fontSize,
      color: color,
    );
  }

  static TextStyle semiBold({
    double fontSize = 14.0,
    Color color = Colors.black,
  }) {
    return getTextStyle(
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
      color: color,
    );
  }
}
