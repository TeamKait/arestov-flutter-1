import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CodecsScreen extends StatefulWidget {
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
                  child: child)
            ],
          );
        });
  }
}
