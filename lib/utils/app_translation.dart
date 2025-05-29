import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AppTranslation extends Translations {
  final Map<String, Map<String, String>> _translations = {};

  @override
  Map<String, Map<String, String>> get keys => _translations;

  Future<void> loadTranslations() async {
    _translations['en'] = await loadJson('en');
    _translations['km'] = await loadJson('km');
  }

  Future<Map<String, String>> loadJson(String lang) async {
    String jsonData = await rootBundle.loadString('assets/locales/$lang.json');
    Map<String, dynamic> data = json.decode(jsonData);
    return data.map((key, value) => MapEntry(key, value.toString()));
  }
}
