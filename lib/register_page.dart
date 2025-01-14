// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// Импортирование библиотек
import 'package:flutter/material.dart';
import 'package:win32/win32.dart';
import 'app_localizations.dart';

// Импортирование сцен
import 'database_helper.dart';

// Класс виджета
class RegisterPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  const RegisterPage({super.key, required this.onLocaleChange});
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

// Класс статуса страницы
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
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: localization.translate('username')),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: localization.translate('password')),
                obscureText: true,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                  onPressed: () async {
                    String username = emailController.text.trim();
                    String password = passwordController.text.trim();
                    if (username.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Введите имя и пароль')));
                      return;
                    }
                    try {
                      await dbHelper.registerUser(username, password);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text(localization.translate('register_success')),
                        backgroundColor: Colors.teal,
                      ));
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text(localization.translate('register_failure')),
                        backgroundColor: Colors.redAccent,
                      ));
                    }
                  },
                  child: Text(localization.translate('register_button')))
            ],
          )),
    );
  }
}
