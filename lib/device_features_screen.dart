import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceFeaturesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Функции устройства'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // _buildSectionTitle('Поддерживаемые функции', Icons.info),
              Divider(),
              // _buildFeaturesSection(),
            ],
          ),
        ),
      ),
    );
  }
}
