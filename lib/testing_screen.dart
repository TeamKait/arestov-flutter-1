import 'dart:async';
import 'dart:developer' as developers;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_speedtest/flutter_speedtest.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/pdf.dart';

class TestingScreen extends StatefulWidget {
  @override
  _TestingScreenState createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  String _connectionStatus = 'Hensser-no';
  final NetworkInfo _networkInfo = NetworkInfo();
  final FlutterSpeedtest _speedtest = FlutterSpeedtest(
    baseUrl: 'https://speedtest.globalxtreme.net:8088',
    pathDownload: '/download',
    pathUpload: '/upload',
    pathResponseTime: '/ping',
  );
  String? wifiName,
      wifiBSSID,
      wifiIPv4,
      wifiIPv6,
      wifiGatewayIP,
      wifiBroadcast,
      wifiSubmask;
  double _progressDownload = 0;
  double _progressUpload = 0;
  int _ping = 0;
  int _jitter = 0;
  bool _isTesting = false;
  bool _showDownloadButton = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initNetworkInfo();
  }

  Future<void> _initNetworkInfo() async {
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.status;
    if (!permissionStatus.isGranted) {
      permissionStatus = await Permission.locationWhenInUse.request();
    }
    if (permissionStatus.isGranted) {
      try {
        wifiName = await _networkInfo.getWifiName();
        wifiBSSID = await _networkInfo.getWifiBSSID();
        wifiIPv4 = await _networkInfo.getWifiIP();
        wifiIPv6 = await _networkInfo.getWifiIPv6();
        wifiSubmask = await _networkInfo.getWifiSubmask();
        wifiBroadcast = await _networkInfo.getWifiBroadcast();
        wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      } on PlatformException catch (e) {
        developers.log('Не удалось получить информацию о сети', error: e);
      }
    } else {
      setState(() {
        _connectionStatus = 'Нет разрешения на доступ к Wi-Fi';
      });
      return;
    }
    setState(() {
      _connectionStatus = "Имя Wi-Fi: $wifiName\n"
          'BSSID $wifiBSSID\n'
          'IPv4 $wifiIPv4\n'
          'IPv6 $wifiIPv6\n'
          'Широковещательный адрес $wifiBroadcast\n'
          'IP шлюза $wifiGatewayIP\n'
          'Маска подсети $wifiSubmask\n';
    });
  }

  void _startSpeedTest() async {
    setState(() {
      _isTesting = true;
      _progressDownload = 0;
      _progressUpload = 0;
      _ping = 0;
      _jitter = 0;
      _showDownloadButton = false;
    });

    try {
      _speedtest.getDataspeedtest(
        downloadOnProgress: (percent, transferRate) {
          if (transferRate < 1000) {
            setState(() {
              _progressDownload = transferRate;
            });
          }
        },
        uploadOnProgress: (percent, transferRate) {
          if (transferRate < 1000) {
            setState(() {
              _progressUpload = transferRate;
            });
          }
        },
        progressResponse: (responseTime, jitter) {
          setState(() {
            _ping = responseTime;
            _jitter = jitter;
          });
        },
        onError: (errorMessage) {
          developers.log("Ошибка при тестировании скорости: $errorMessage");
        },
        onDone: () {
          developers.log("Тест скорости завершён.");
          _stopSpeedTest();
        },
      );
    } catch (e) {
      developers.log("Ошибка при тестировании: $e");
    }

    _timer = Timer(Duration(seconds: 40), () {
      _stopSpeedTest();
    });
  }

  void _stopSpeedTest() {
    if (_isTesting) {
      setState(() {
        _isTesting = false;
        _showDownloadButton = true;
      });
      _timer?.cancel();
      developers.log("Тест завершён через 40 секунд.");
    }
  }

  Future<void> _generateAndSavePDF() async {
    await _requestPermission();
    final robotoFont =
        pw.Font.ttf(await rootBundle.load("assets/fonts/Roboto-Regular.ttf"));

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text('Результаты теста скорости',
                    style: pw.TextStyle(fontSize: 24, font: robotoFont)),
                pw.SizedBox(height: 30),
                pw.Text('Имя Wi-Fi: ${wifiName ?? 'Неизвестно'}',
                    style: pw.TextStyle(font: robotoFont)),
                pw.Text('BSSID: ${wifiBSSID ?? 'Неизвестно'}',
                    style: pw.TextStyle(font: robotoFont)),
                pw.Text('IPv4: ${wifiIPv4 ?? 'Неизвестно'}',
                    style: pw.TextStyle(font: robotoFont)),
                pw.Text('IPv6: ${wifiIPv6 ?? 'Неизвестно'}',
                    style: pw.TextStyle(font: robotoFont)),
                pw.Text(
                    'Широковещательный адрес: ${wifiBroadcast ?? 'Неизвестно'}',
                    style: pw.TextStyle(font: robotoFont)),
                pw.Text('Маска подсети: ${wifiSubmask ?? 'Неизвестно'}',
                    style: pw.TextStyle(font: robotoFont)),
                pw.Text('Broadcast: ${wifiBroadcast ?? 'Неизвестно'}',
                    style: pw.TextStyle(font: robotoFont)),
                pw.SizedBox(height: 20),
                pw.Text(
                    'Скорость загрузки: ${_progressDownload.toStringAsFixed(2)} Mbps',
                    style: pw.TextStyle(font: robotoFont)),
                pw.Text(
                    'Скорость отдачи: ${_progressUpload.toStringAsFixed(2)} Mbps',
                    style: pw.TextStyle(font: robotoFont)),
                pw.Text('Пинг: $_ping мс',
                    style: pw.TextStyle(font: robotoFont)),
                pw.Text('Задержка: $_jitter мс',
                    style: pw.TextStyle(font: robotoFont)),
              ],
            ),
          );
        },
      ),
    );

    Directory directory;
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/DCIM");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory != null) {
      final file = File(path.join(directory.path, 'speedtest_results.pdf'));
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('PDF файл успешно сохранён в папке DCIM: ${file.path}'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Не удалось сохранить PDF файл'),
      ));
    }
  }

  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        if (await Permission.manageExternalStorage.isGranted ||
            await Permission.manageExternalStorage.request().isGranted) {
          return;
        } else {
          await Permission.storage.request();
        }
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Тестирование сети"),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Информация о сети",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _connectionStatus,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isTesting ? null : _startSpeedTest,
                  child: Text("Начать тест скорости"),
                ),
                SizedBox(height: 20),
                Container(
                    // TODO: Дописать
                    ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: _isTesting ? null : _startSpeedTest,
                    child: Text('Начать тест скорости')),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Text(
                        'Результаты теста скорости:',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Скорость загрузки: ${_progressDownload.toStringAsFixed(2)} Мбит/с',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Скорость отдачи: ${_progressUpload.toStringAsFixed(2)} Мбит/с',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Пинг: ${_ping} мс',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Задержка $_jitter мс',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_showDownloadButton)
                  ElevatedButton(
                      onPressed: _generateAndSavePDF,
                      child: Text('Скачать результаты в PDF'))
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
