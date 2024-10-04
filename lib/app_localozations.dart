import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class AppLocalozations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalozations(this.locale);

  static AppLocalozations? of(BuildContext context){
    return Localizations.of<AppLocalozations>(context, AppLocalozations);
  }

// ru.json
// "hello_msg": "Привет",
// en.json
// "hello_msg": "Hello",
  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json'); 
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }
}