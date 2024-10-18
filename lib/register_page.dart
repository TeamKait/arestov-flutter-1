// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:win32/win32.dart';
import 'app_localizations.dart';

class RegisterPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  RegisterPage({required this.onLocaleChange});
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true, title: Text(localization!.translate('register'))),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[TextField()],
          )),
    );
  }
}
