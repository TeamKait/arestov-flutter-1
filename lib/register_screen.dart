import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'app_details_screen.dart';
import 'dart:io';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _deviceInfo = '';
  List<Map<String, dynamic>> _installedApps = [];

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
    _loadInstalledApps();
  }

  Future<void> _loadDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    setState(() {
      _deviceInfo = '''
      Model: ${androidInfo.model}
      Android Version: ${androidInfo.version.release}
      Manufacturer: ${androidInfo.manufacturer}
      Brand: ${androidInfo.brand}
      Hardware: ${androidInfo.hardware}
      ''';
    });
  }

  // Future<void> _loadInstalledApps() async {
  //   List<Application> apps = await DeviceApps.getInstalledApplications(
  //       includeAppIcons: true, onlyAppsWithLaunchIntent: true);

  //   List<Map<String, dynamic>> appList = [];

  //   for (var app in apps) {
  //     File apkFile = File(app.apkFilePath);
  //     double sizeInMB =
  //         apkFile.existsSync() ? apkFile.lengthSync() / (1024 * 1024) : 0.0;
  //     appList.add({
  //       'appName': app.appName,
  //       'packageName': app.packageName,
  //       'size': sizeInMB > 0 ? '${sizeInMB.toStringAsFixed(2)} MB' : 'N/A'
  //     });
  //   }
  //   setState(() {
  //     _installedApps = appList;
  //   });
  // }

  Future<void> _loadInstalledApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps(false, true);

    List<Map<String, dynamic>> appList = [];

    for (var app in apps) {
      appList.add(
          {'appName': app.name, 'packageName': app.packageName, 'size': 'N/A'});
    }
    setState(() {
      _installedApps = appList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Реестр системы',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Информация об устройсте',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              _deviceInfo,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Установленные приложения',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: _installedApps.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _installedApps.length,
                      itemBuilder: (context, index) {
                        var app = _installedApps[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: Colors.blueGrey[900],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5),
                              ]),
                          child: ListTile(
                            title: Text(
                              app['appName'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Package: ${app['packageName']}\nSize: ${app['size']}',
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.info,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AppDetailsScreen(
                                            appName: app['appName'],
                                            packageName: app['packageName'],
                                            size: app['size'])));
                              },
                            ),
                          ),
                        );
                      }),
            )
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
