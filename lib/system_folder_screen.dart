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
              _buildFolderSection('Внешнее хранилище', Icons.sd_storage),
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
    return FutureBuilder <
        List<Map<String, String>>(
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
}
