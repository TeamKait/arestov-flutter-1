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

  
}
