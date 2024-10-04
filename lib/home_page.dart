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
  final MaterialColor _MAIN_COLOR = Colors.teal;
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
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.black87,
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: _MAIN_COLOR),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.grey),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _MAIN_COLOR)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _MAIN_COLOR)
          ),
          labelStyle: TextStyle(color: _MAIN_COLOR) ,
          filled: true,
          fillColor: Colors.grey[800],
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _MAIN_COLOR[300],
            foregroundColor: Colors.black,
            elevation: 8,
            textStyle: TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20)
          )
        )
      ),
      home: LoginPage(onLocalChange: _changeLanguage),
    );
  }
}