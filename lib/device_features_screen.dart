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
              _buildSectionTitle('Поддерживаемые функции', Icons.info),
              Divider(),
              _buildFeaturesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(children: [
      Icon(
        icon,
        size: 28,
        color: Colors.blue,
      ),
      SizedBox(
        width: 10,
      ),
      Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      )
    ]);
  }

  Widget _buildFeaturesSection() {
    return FutureBuilder<List<String>>(
        future: _getDeviceFeatures(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          } else {
            List<String> features = snapshot.data ?? [];
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Icon(
                      Icons.check,
                      color: Colors.blue,
                    ),
                    title: Text(feature),
                  ),
                );
              },
            );
          }
        });
  }

  Future<List<String>> _getDeviceFeatures() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androindInfo = await deviceInfo.androidInfo;

    return androindInfo.systemFeatures;
  }
}
