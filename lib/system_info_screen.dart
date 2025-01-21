import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'system_helper.dart';

class SystemInfoScreen extends StatelessWidget {
  void _copyClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Скопировано в буфер обмена')));
  }

  Future<void> saveAsPdf(Map<String, String> data) async {
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
      body: FutureBuilder<Map<String, String>>(
        future: Future.wait([getMemoryInfo(), getSystemInfo()]).then((result) {
          return {
            ...result[0],
            ...result[1],
          };
        }),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator())
          }
          else if(snapshot.hasError){
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          else{
            Map<String, String> data = snapshot.data ?? {};
            return Padding(
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
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.0)
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
