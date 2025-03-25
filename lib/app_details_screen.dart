import 'package:flutter/material.dart';

class AppDetailsScreen extends StatelessWidget {
  final String appName;
  final String packageName;
  final String size;

  AppDetailsScreen({
    required this.appName,
    required this.packageName,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Подробности приложения',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Подсказка'),
                        content: Text(
                            'Это страница с подробной информацией о приложении.'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Закрыть'))
                        ],
                      );
                    });
              },
              icon: Icon(Icons.help_outline, color: Colors.white))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5)
              ]),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.apps,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    'Название: $appName',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(Icons.code, color: Colors.blueAccent, size: 30),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    'Пакет: $packageName',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(Icons.storage, color: Colors.blueAccent, size: 30),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    'Размер: $size',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
