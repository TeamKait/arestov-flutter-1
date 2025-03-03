// Импортирование библиотек
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:installed_apps/installed_apps.dart';
import 'dart:io';
import 'dart:typed_data';

// Импортирование сцен
import 'processor_info_screen.dart';
import 'system_info_screen.dart';
import 'battery_info_screen.dart';
import 'login_page.dart';
import 'testing_screen.dart';
import 'about_screen.dart';
import 'device_features_screen.dart';
import 'sensors_screen.dart';
import 'reports_screen.dart';
// import 'register_screen.dart';

// Класс сцены
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _appWithSizeAndIcon = [];
  String _deviceInfo = '';
  String _sortCriterion = 'name';

  @override
  void initState() {
    super.initState();
    _loadInstalledAppsWithSizeAndIcon();
    _getDeviceInfo();
  }

  // Метод, загружающий приложения и информацию о них
  Future<void> _loadInstalledAppsWithSizeAndIcon() async {
    print("Loading");
    List<AppInfo> apps = await InstalledApps.getInstalledApps(false, true);
    List<Map<String, dynamic>> appsWithSizeAndIcon = [];
    for (var app in apps) {
      print(app.builtWith);
      // File apkFile = File(app.apkFilePath);
      // double sizeInMb =
      //     apkFile.existsSync() ? apkFile.lengthSync() / (1024 * 1024) : 0.0;
      double sizeInMb = 0;

      appsWithSizeAndIcon.add({
        'app': app,
        'size': sizeInMb > 0 ? '${sizeInMb.toStringAsFixed(2)} MB' : 'N/A',
        'sizeValue': sizeInMb,
        'icon': app.icon,
      });
    }
    // print(appsWithSizeAndIcon);
    _sortApps(appsWithSizeAndIcon);
    setState(() {
      _appWithSizeAndIcon = appsWithSizeAndIcon;
    });
    // print(_appWithSizeAndIcon);
  }

  void _sortApps(List<Map<String, dynamic>> apps) {
    if (_sortCriterion == 'name') {
      apps.sort((a, b) => a['app'].name.compareTo(b['app'].name));
    } else if (_sortCriterion == 'size') {
      apps.sort((a, b) =>
          (a['sizeValue'] as double).compareTo(b['sizeValue'] as double));
    }
  }

  Future<void> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;

    setState(() {
      _deviceInfo =
          'Device: ${androidDeviceInfo.model}, Android version ${androidDeviceInfo.version.release}';
    });
  }

  void _onSortSelected(String criterion) {
    setState(() {
      _sortCriterion = criterion;
      _sortApps(_appWithSizeAndIcon);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Sort by"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text("Name"),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _onSortSelected('name');
                                },
                              ),
                              ListTile(
                                title: const Text("Size"),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _onSortSelected('size');
                                },
                              ),
                            ],
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.sort)),
            Expanded(
              child: Center(
                  child: StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  String formattedDateTime =
                      DateFormat('dd.MM.yyyy HH:mm:ss').format(DateTime.now());
                  return Text(formattedDateTime,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold));
                },
              )),
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoginPage(onLocaleChange: (locale) {})));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_deviceInfo,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProcessorInfoScreen()));
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    child: const Text("Процессор"),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BatteryInfoScreen()));
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.teal[300],
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                        child: const Text("Аккумулятор"))),
                const SizedBox(width: 8),
                Expanded(
                    child: TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: Colors.teal[300],
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(fontSize: 14)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SystemInfoScreen()));
                        },
                        child: const Text(
                          "Система",
                        )))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TestingScreen()));
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.teal[300],
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  child: const Text("Тестирование"),
                )),
                Expanded(
                    child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AboutScreen()));
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.teal[300],
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  child: const Text("О приложении"),
                )),
                Expanded(
                    child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DeviceFeaturesScreen()));
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.teal[300],
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                  child: const Text("Устройства"),
                )),
              ],
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Expanded(
                  child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SensorsScreen()));
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.teal[300],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text("Датчики"),
              )),
              Expanded(
                  child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ReportsScreen()));
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.teal[300],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text("Отчеты"),
              )),
            ]),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: _appWithSizeAndIcon.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _appWithSizeAndIcon.length,
                      itemBuilder: (context, index) {
                        var appWithSizeAndIcon = _appWithSizeAndIcon[index];
                        AppInfo app = appWithSizeAndIcon['app'];
                        String size = appWithSizeAndIcon['size'];
                        Uint8List? icon = appWithSizeAndIcon['icon'];

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3))
                              ],
                              border: Border.all(
                                  color: Colors.teal[300]!, width: 2)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      app.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      'Package: ${app.packageName}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(
                                      'Size: $size',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              if (icon != null)
                                Image.memory(icon, width: 40, height: 40),
                            ],
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
