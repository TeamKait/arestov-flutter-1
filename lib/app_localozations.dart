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
}