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

  @override
  Widget build(BuildContext context) {}
}
