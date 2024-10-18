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
  String sortCriterion = 'name';
}
