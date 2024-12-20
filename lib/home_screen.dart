import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:io';
import 'dart:typed_data';

import 'processor_info_screen.dart';
import 'system_info_screen.dart';
import 'battery_info_screen.dart';

import 'login_page.dart';
import 'testing_screen.dart';
import 'about_screen.dart';
import 'device_feature_screen.dart';
import 'sensor_screen.dart';
import 'reports_screen.dart';
import 'register_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _appWithSizeAndIcon = [];
  String _deviceInfo = '';
  String _sortCriterion = 'name';

  @override
  void initState() {
    _loadInstalledAppsWithSizeAndIcon();
    _getDeviceInfo();
  }

  Future<void> _loadInstalledAppsWithSizeAndIcon() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      includeAppIcons: true,
    );
    List<Map<String, dynamic>> appsWithSizeAndIcon = [];
    for (var app in apps) {
      File apkFile = File(app.apkFilePath);
      double sizeInMb =
          apkFile.existsSync() ? apkFile.lengthSync() / (1024 * 1024) : 0.0;
      appsWithSizeAndIcon.add({
        'app': app,
        'size': sizeInMb > 0 ? '${sizeInMb.toStringAsFixed(2)} MB' : 'N/A',
        'sizeValue': sizeInMb,
        'icon': app is ApplicationWithIcon ? app.icon : null,
      });
    }
    _sortApps(appsWithSizeAndIcon);
    setState(() {
      _appWithSizeAndIcon = appsWithSizeAndIcon;
    });
  }

  void _sortApps(List<Map<String, dynamic>> apps) {
    if (_sortCriterion == 'name') {
      apps.sort((a, b) => a['app'].appName.compareTo(b['app'].appName));
    } else if (_sortCriterion == 'size') {
      apps.sort((a, b) =>
          (a['sizeValue'] as double).compareTo(b['sizeValue'] as double));
    }
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
                          title: Text("Sort by"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text("Name"),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  _onSortSelected('name');
                                },
                              ),
                              ListTile(
                                title: Text("Size"),
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
                icon: Icon(Icons.sort)),
            Expanded(
              child: Center(
                  child: StreamBuilder(
                stream: Stream.periodic(Duration(seconds: 1)),
                builder: (context, snapshot) {
                  String formattedDateTime =
                      DateFormat('dd.MM.yyyy HH:mm:ss').format(DateTime.now());
                  return Text(formattedDateTime,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
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
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_deviceInfo,
                style: TextStyle(fontSize: 16, color: Colors.white)),
            SizedBox(height: 20),
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
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text("Процессор"),
                  ),
                ),
                SizedBox(
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
                          padding: EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.teal[300],
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(fontSize: 14),
                        ),
                        child: Text("Аккумулятор"))),
                SizedBox(width: 8),
                Expanded(child: TextButton(style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.teal[300],
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 14 )
                ),onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SystemInfoScreen()))
                }, child: Text("Система",)))
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: TextButton(onPressed: () {
                  Navigator.push(
                    context, 
                  MaterialPageRoute(builder: (context) => TestingScreen()));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.teal[300],
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 14),
                ),
                child: Text("Тестирование"),
                )),
                Expanded(child: TextButton(
                  onPressed: () {
                  Navigator.push(
                    context, 
                  MaterialPageRoute(builder: (context) => AboutScreen()));
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.teal[300],
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 14),
                  ),
                  child: Text("О приложении"),
                  )
                ),
                Expanded(child: TextButton(onPressed: () {
                  Navigator.push(
                    context, 
                  MaterialPageRoute(builder: (context) => DeviceFeaturesScreen()));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.teal[300],
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(fontSize: 14),
                ),
                child: Text("Устройства"),
                )),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: 
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SensorsScreen()));
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.teal[300],
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 14),
                    ),
                    child: Text("Датчики")
                  )
                ),
                SizedBox(width: 8,),
                Expanded(child: child)
              ],
            )
          ],
        ),
      ),
    );
  }
}
