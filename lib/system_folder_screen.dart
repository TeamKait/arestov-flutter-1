import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class SystemFolderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Информация о файловой системе"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Системные папки", Icons.folder),
              Divider(),
              _buildFolderSection(_getSystemFolders()),
              SizedBox(height: 20),
              _buildSectionTitle('Внешнее хранилище', Icons.sd_storage),
              Divider(),
              _buildFolderSection(_getExternalStorage()),
              SizedBox(height: 20),
              _buildSectionTitle('Точки монтирования', Icons.storage),
              Divider(),
              _buildMountPointsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget _buildFolderSection(Future<List<Map<String, String>>> folderFuture) {
    return FutureBuilder<List<Map<String, String>>>(
      future: folderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        } else {
          List<Map<String, String>> folders = snapshot.data ?? [];
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: folders.length,
            itemBuilder: (context, index) {
              final folder = folders[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(Icons.folder, color: Colors.blue),
                  title: Text(folder['name'] ?? 'Нет данных'),
                  trailing: Text(folder['path'] ?? 'Нет данных'),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildMountPointsSection() {
    return FutureBuilder<List<Map<String, String>>>(
        future: _getMountPoint(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            List<Map<String, String>> mountPoints = snapshot.data ?? [];
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: mountPoints.length,
                itemBuilder: (context, index) {
                  final mount = mountPoints[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                        leading: Icon(Icons.storage, color: Colors.blue),
                        title: Text(mount['filesystem'] ?? 'Нет данных'),
                        subtitle: Text(mount['path'] ?? 'Нет данных'),
                        trailing: Text(mount['access'] ?? 'Неизвестно')),
                  );
                });
          }
        });
  }

  Future<List<Map<String, String>>> _getSystemFolders() async {
    List<Map<String, String>> systemFolders = [
      {'name': 'System', 'path': '/system'},
      {'name': 'Data', 'path': '/data'},
      {'name': 'Cache', 'path': '/cache'},
      {'name': 'Root', 'path': '/'},
    ];

    List<Map<String, String>> existingFolders = [];
    for (var folder in systemFolders) {
      if (await Directory(folder['path']!).exists()) {
        existingFolders.add(folder);
      }
    }

    return existingFolders;
  }

  Future<List<Map<String, String>>> _getExternalStorage() async {
    List<Map<String, String>> externalStorage = [];
    String internalStorage = Directory('/storage/emulated/0').path;
    if (await Directory(internalStorage).exists()) {
      externalStorage
          .add({'name': "Основное внешнее хранилище", 'path': internalStorage});
    }

    List<Map<String, String>> subFolders = [
      {
        'name': 'Внешние файлы #1',
        'path': '$internalStorage/data/com.finalware.aida64/files'
      },
      {'name': 'Сигналы', 'path': '$internalStorage/Alarms'},
      {'name': 'DCIM', 'path': '$internalStorage/DCIM'},
      {'name': 'Документы', 'path': '$internalStorage/Documents'},
      {'name': 'Загрузки', 'path': '$internalStorage/Download'},
      {'name': 'Кино', 'path': '$internalStorage/Movies'},
      {'name': 'Музыка', 'path': '$internalStorage/Music'},
      {'name': 'Оповещения', 'path': '$internalStorage/Notifications'},
      {'name': 'Картинки', 'path': '$internalStorage/Pictures'},
      {'name': 'Подкасты', 'path': '$internalStorage/Podcasts'},
      {'name': 'Рингтоны', 'path': '$internalStorage/Ringtones'},
    ];

    for (var folder in subFolders) {
      if (await Directory(folder['path']!).exists()) {
        externalStorage.add(folder);
      }
    }

    String sdCardStorage = '/storage/sdcard1';
    if (await Directory(sdCardStorage).exists()) {
      externalStorage.add({'name': 'SD Card', 'path': sdCardStorage});
    }

    return externalStorage;
  }

  Future<List<Map<String, String>>> _getMountPoint() async {
    List<Map<String, String>> mountPoints = [];

    try {
      final mounts = await File('/proc/mounts').readAsLines();

      for (var line in mounts) {
        var parts = line.split(' ');
        if (parts.length > 3) {
          String filesystem = parts[0];
          String path = parts[1];
          String options = parts[3];

          String access = 'Неизменен';
          if (options.contains('rw')) {
            access = 'Чтение/Запись';
          } else if (options.contains('ro')) {
            access = 'Только чтение';
          }

          mountPoints
              .add({'filesystem': filesystem, 'path': path, 'access': access});
        }
      }
    } catch (e) {
      mountPoints.add({
        'filesystem': 'Ошибка',
        'path': 'Ошибка',
        'access': "Ошибка чтения"
      });
    }
    return mountPoints;
  }
}
