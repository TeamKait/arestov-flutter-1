import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'login_page.dart';
import 'app_localozations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  Locale _locale = Locale("ru", "RU");

  void _changeLanguage(Locale locale){
    setState(() {
      _locale = locale;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ИнфоТел",
      locale: _locale,
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        AppLocalizationsDelegate(),
      ],
      supportedLocales: [
        Locale("en", "US"),
        Locale("ru", "RU"),
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal
      ),
    );
  }
}