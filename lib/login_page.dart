import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_localizations.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'database_helper.dart';
import 'home_screen.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final Function(Locale) onLocaleChange;
  LoginPage({required this.onLocaleChange});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final dbHelper = DatabaseHelper();
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateFormat('dd MMMM yyy HH:mm:ss',
                Localizations.localeOf(context).toString())
            .format(DateTime.now());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(localizations!.translate('title')),
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              widget.onLocaleChange(
                  Localizations.localeOf(context).languageCode == 'en'
                      ? Locale("ru", "RU")
                      : Locale("en", "EN"));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(
                size: 100,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                _currentTime,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: localizations.translate('username'),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: localizations.translate('password'),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        String username = emailController.text;
                        String password = passwordController.text;
                        bool isAuthenticated =
                            await dbHelper.authUser(username, password);
                        if (isAuthenticated) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(localizations.translate("login")),
                            backgroundColor: Colors.redAccent,
                          ));
                        }
                      },
                      child: Text(localizations.translate("login")),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage(
                                  onLocaleChange: widget.onLocaleChange)));
                    },
                    child: Text(localizations.translate('register')),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
