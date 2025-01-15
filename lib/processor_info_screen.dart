import 'dart:io';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'system_folder_screen.dart';
import 'codecs_screen.dart';

class ProcessorInfoScreen extends StatefulWidget {
  @override
  _ProcessorInfoScreenState createState() => _ProcessorInfoScreenState();
}

class _ProcessorInfoScreenState extends State<ProcessorInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Информация о процессоре')),
      body: FutureBuilder<Map<String, dynamic>>(
          future: _getDeviceInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Ошибка: ${snapshot.error}"));
            } else {
              String processor = snapshot.data?['processor'] ?? 'Неизвестно';
              String processorModel =
                  snapshot.data?['processorModel'] ?? 'Неизвестно';
              String cpuCores = snapshot.data?['cpuCores'] ?? 'Неизвестно';
              String androidId = snapshot.data?['androidId'] ?? 'Неизвестно';
              List<String>? cpuFrequencies = snapshot.data?['cpuFrequencies'];
              String host = snapshot.data?['host'] ?? 'Неизвестно';
              String bootLoader = snapshot.data?['bootloader'] ?? 'Неизвестно';
              String basebandVersion =
                  snapshot.data?['basebandVersion'] ?? 'Неизвестно';

              return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoCard('Процессор', processor, Icons.memory),
                        _buildInfoCard('Модель процессора', processorModel,
                            Icons.developer_board),
                        _buildInfoCard('Количество ядер', cpuCores,
                            Icons.settings_applications),
                        _buildInfoCard('Индентификатор хоста', androidId,
                            Icons.perm_device_info),
                        if (cpuFrequencies != null)
                          _buildCpuFrequenciesInfo(cpuFrequencies),
                        _buildInfoCard(
                            'Хост', host ?? 'Неизвестно', Icons.router),
                        _buildInfoCard('Загрузчик', bootLoader,
                            Icons.system_security_update),
                        _buildInfoCard('Версия базовой полосы', basebandVersion,
                            Icons.system_security_update),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: Icon(Icons.folder),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SystemFolderScreen()));
                          },
                          label: Text('Информация о системных папках'),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: Icon(Icons.audiotrack),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CodecsScreen()));
                          },
                          label: Text('Информация о кодеках'),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ],
                    ),
                  ));
            }
          }),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.blue),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildCpuFrequenciesInfo(List<String> cpuFrequencies) {
    List<Padding> frequencies = cpuFrequencies.asMap().entries.map((entry) {
      int index = entry.key + 1;
      String frequency = entry.value;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Частота ядра $index: $frequency GHz',
          style: TextStyle(fontSize: 16),
        ),
      );
    }).toList();
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: frequencies,
          ),
        ));
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    await _requestPermissions();

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

    String? processorModel;
    if (androidInfo.supportedAbis.isNotEmpty) {
      processorModel = androidInfo.supportedAbis.first;
    }

    int cpuCores = _getCpuCoreCount();
  }
}
