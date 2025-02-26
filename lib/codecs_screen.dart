import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'helpers.dart';

class CodecsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Информация о кодеках"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              _showDialog(context);
            },
          )
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _getCodecs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          } else {
            List<String> codecs = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Поддерживаемые кодеки',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ниже представлен список кодеков, поддерживаемых на вашем устройстве:',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Вы нажали кнопку оповещения!"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Text("Показать SnackBar"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      SuccessSnackBar(context, "Успех!");
                    },
                    child: Text("Показать Success SnackBar"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      WarningSnackBar(context, "Предупреждение");
                    },
                    child: Text("Показать Warning SnackBar"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ErrorSnackBar(context, "Ошибка!");
                    },
                    child: Text("Показать Error SnackBar"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showToast("Это уведомление Toast");
                    },
                    child: Text("Показать Toast!"),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: codecs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Icon(Icons.audiotrack,
                                color: Colors.blueAccent),
                            title: Text(
                              codecs[index],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Оповещение"),
            content: Text("Это диалоговое окно для демонстрации оповещения"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Закрыть"))
            ],
          );
        });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  Future<List<String>> _getCodecs() async {
    List<String> codecs = [];
    List<String> codecsFiles = [
      "/etc/media_codecs.xml",
      "/system/etc/media_codecs.xml",
      "/vendor/etc/media_codecs.xml",
    ];

    for (String filePath in codecsFiles) {
      try {
        final file = File(filePath);
        if (await file.exists()) {
          final content = await file.readAsString();
          codecs.addAll(_parseCodecs(content));
        }
      } catch (e) {
        codecs = ['Кодеки не найдены'];
      }
    }
    return codecs;
  }

  List<String> _parseCodecs(String content) {
    List<String> codecs = [];
    RegExp regExp = RegExp(r'<MediaCodec name="([^"]+)"');
    Iterable<RegExpMatch> matches = regExp.allMatches(content);

    for (RegExpMatch match in matches) {
      if (match.groupCount > 0) {
        codecs.add(match.group(1)!);
      }
    }

    return codecs;
  }
}
