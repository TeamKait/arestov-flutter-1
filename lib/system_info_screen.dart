import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'system_helper.dart';

class SystemInfoScreen extends StatefulWidget {
  const SystemInfoScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SystemInfoState();
}

class _SystemInfoState extends State<SystemInfoScreen> {
  late Timer periodicTimer;

  void _copyClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Скопировано в буфер обмена')));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    periodicTimer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _getInformation();
    periodicTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _getInformation();
    });
  }

  Map<String, String> data = {};

  Future<void> _saveAsPdf(Map<String, String> data) async {
    if (await Permission.storage.request().isGranted) {
      final pdf = pw.Document();
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: data.entries.map((entry) {
                  return pw.Text('${entry.key}: ${entry.value}');
                }).toList()));
      }));
      final output = Directory('/storage/emulated/0/DCIM');
      final file = File('${output.path}/system_info.pdf');
      await file.writeAsBytes(await pdf.save());
      print('Файл сохранён по пути: ${file.path}');
    } else {
      print('Разрешение на запись не предоставлено.');
    }
  }

  Future<void> _getInformation() async {
    Future.wait([getMemoryInfo(), getSystemInfo()]).then((result) {
      setState(() {
        data = {
          ...result[0],
          ...result[1],
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Информация о системе"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back))
          ],
        ),
        body: Container(
            child: data.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionTile(
                          title: Text(
                            'Память',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Тип ОЗУ: ${data['ramType']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Объем ОЗУ: ${data['totalRamGB']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Свободная ОЗУ: ${data['freeRamGB']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                      "Общее хранилище: ${data['totalStorageGB']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                      "Свободное хранилище: ${data['freeStorageGB']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                      "Технология: ${data['storageTechnology']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () => _copyClipboard(
                                    "Тип ОЗУ: ${data['ramType']}\n"
                                    "Объем ОЗУ: ${data['totalRamGB']} ГБ\n"
                                    "Свободная ОЗУ: ${data['freeRamGB']} ГБ\n"
                                    "Общее хранилище: ${data['totalStorageGB']} ГБ\n"
                                    "Свободное хранилище: ${data['freeStorageGB']} ГБ\n"
                                    "Технология: ${data['storageTechnology']}\n",
                                    context),
                                child: Text("Скопировать данные о системе"),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue))
                          ],
                        ),
                        SizedBox(height: 20),
                        ExpansionTile(
                          title: Text(
                            'Система',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8.0),
                                  border:
                                      Border.all(color: Colors.grey.shade100)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Версия Android: ${data['androidVersion']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                      "Модель устройства: ${data['deviceModel']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Производитель: ${data['manufacturer']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                      "Название устройства: ${data['deviceModel']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Версия SDK: ${data['androidSdkInt']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Плата: ${data['board']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Дисплей: ${data['display']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Разрешение: ${data['resolution']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Плотность: ${data['density']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                      "Частота обновления: ${data['refreshRate']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("HDR: ${data['hdr']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Размер телефона: ${data['phonesize']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text("Вес телефона: ${data['weight']}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => _copyClipboard(
                                  "Версия Android: ${data['androidVersion']}\n"
                                  "Модель устройства: ${data['deviceModel']}\n"
                                  "Производитель: ${data['manufacturer']}\n"
                                  "Название устройства: ${data['deviceModel']}\n"
                                  "Версия SDK: ${data['androidSdkInt']}\n"
                                  "Плата: ${data['board']}\n"
                                  "Дисплей: ${data['display']}\n"
                                  "Разрешение: ${data['resolution']}\n"
                                  "Плотность: ${data['density']}\n"
                                  "Частота обновления: ${data['refreshRate']}\n"
                                  "HDR: ${data['hdr']}\n"
                                  "Размер телефона: ${data['phonesize']}\n"
                                  "Вес телефона: ${data['weight']}",
                                  context),
                              child: Text("Копировать данные о системе"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: (() => _saveAsPdf(data)),
                          child: Text('Сохранить данные в PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  )));
  }
}
