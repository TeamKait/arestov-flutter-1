import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'processor_info_screen.dart';

class ReportsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReportsScreenState();
  }
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _reportGenerated = false;
  File? _pdfFile;
  pw.Font? _customFont;

  @override
  void initState() {
    super.initState();

    _requestPermissions();
    _loadFont();
  }

  Future<void> _loadFont() async {
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);
    setState(() {
      _customFont = ttf;
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
  }

  Future<void> _generateReport() async {
    if (_customFont == null) {
      return;
    }

    final pdf = pw.Document();

    final processorInfo = await _getProcessorInfo();

    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
            pw.Text(
              'Отчёт о процессоре',
              style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  font: _customFont),
            ),
            pw.SizedBox(height: 20),
            pw.Text("Информация о процессоре:",
                style: pw.TextStyle(font: _customFont))
          ]));
    }));

    final directory = Directory('/storage/emulated/0/DCIM');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    final path = '${directory.path}/report.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    setState(() {
      _reportGenerated = true;
      _pdfFile = file;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Отчёт сохранен по пути: $path')));
  }

  Future<String> _getProcessorInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    int cpuCores = Platform.numberOfProcessors;
    List<String> cpuFrequencies = await _getCpuFrequencies();
    String? basebandVersion = await _getBasebandVersion();

    String processor = androidInfo.hardware ?? 'Неизвестно';
    String processorModel = androidInfo.supportedAbis.isNotEmpty
        ? androidInfo.supportedAbis.first
        : "Неизвестно";
    String cpuCoresText = cpuCores.toString();
    String cpuFrequenciesText = cpuFrequencies.join(', ');
    String androidId = androidInfo.id ?? 'Неизвестно';
    String host = androidInfo.host ?? 'Неизвестно';
    String bootloader = androidInfo.bootloader ?? 'Неизвестно';

    return '''
Процессор: $processor
Модель процессора: $processorModel
Количество ядер: $cpuCoresText
Частоты ядер: $cpuFrequenciesText
Идентификатор устройства: $androidId
Хост: $host
Загрузчик: $bootloader
Версия базовой полосы: ${basebandVersion ?? 'Неизвестно'}
    ''';
  }

  Future<List<String>> _getCpuFrequencies() async {
    List<String> frequencies = [];
    int coreIndex = 0;
    while (true) {
      try {
        final frequency = await _readFileAsString(
            '/sys/devices/system/cpu/cpu$coreIndex/cpufreq/cpuinfo_max_freq');
        if (frequency == null) break;
        final frequencyInGHz = (int.parse(frequency) / 1e6).toStringAsFixed(2);
        frequencies.add(frequencyInGHz);
        coreIndex++;
      } catch (e) {
        break;
      }
    }
    return frequencies.isEmpty ? ['Неверные данные'] : frequencies;
  }

  Future<String?> _readFileAsString(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<String?> _getBasebandVersion() async {
    try {
      ProcessResult result =
          await Process.run('getprop', ['gsm.version.baseband']);
      return result.stdout.trim();
    } catch (e) {
      return 'Неизвестно';
    }
  }

  Future<void> _downloadReport() async {
    if (_pdfFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Отчёт скачан в ${_pdfFile!.path}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отчёты'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _generateReport,
              child: Text('Формировать отчёт'),
            ),
            SizedBox(
              height: 20,
            ),
            if (_reportGenerated)
              ElevatedButton(
                onPressed: _downloadReport,
                child: Text('Скачать отчёт'),
              )
          ],
        ),
      ),
    );
  }
}
