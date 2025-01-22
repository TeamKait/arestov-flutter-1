import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, String>> getDeviceSpecificInfo(String deviceModel) async{
  try{
    final String response = await rootBundle.loadString('assets/device_info.json');
    final data = jsonDecode(response)
    return Map<String, String>.from(data[deviceModel] ?? {});
  }
  catch(e){
    print('Ошибка при чтении файла: $e');
    return {};
  }
}

Future<int> getTotalMemory() async{
  final lines = await File('/proc/meminfo').readAsLines();
  for(var line in lines){
    if(line.startsWith('MemTotal:')){
      var parts = line.split(RegExp(r'\s+'));
      return int.parse(parts[1])*1024;
    }
  }
  return 0;
}

Future<int> getFreeMemory() async{
  final lines = await File('/proc/meminfo').readAsLines();
  for(var line in lines){
    if(line.startsWith('MemAvailable:')){
      var parts = line.split(RegExp(r'\s+'));
      return int.parse(parts[1])*1024;
    }
  }
  return 0;
}

Future<Map<String, int>> getStorageInfo() async{
  try{
    ProcessResult result = await Process.run('df', ['/']);
    if(result.exitCode == 0){
      var lines = result.stdout.toString().split('\n');
      if (lines.length > 1){
        var data = lines[1].split(RegExp(r'\s+'));
        if(data.length >= 4){
          int totalBytes = int.parse(data[1])*1024;
          int freeBytes = int.parse(data[3])*1024;
          return{
            'total':totalBytes,
            'free':freeBytes
          };
        }
      }
    }
  }
  catch(e){
    print("Ошибка при получении информации о хранилище: $e");
  }
  return{
    'total':0,
    'free':0
  };
}

Future<Map<String, String>> getMemoryInfo() async{
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  int sdkInt = androidInfo.version.sdkInt;
  String ramType;
  String storageTechnology = 'Неизвестно';

  if(sdkInt >= 28){
    ramType = 'LPDDR4/LPDDR4X';
    storageTechnology = 'UFS 2.1';
  }
  else if(sdkInt >= 23){
    ramType = 'LPDDR3';
    storageTechnology = 'eMMC 5.1';
  }
  else{
    ramType = 'DDR3';
    storageTechnology = 'eMMC 4.5';
  }

  int totalRamBytes = await getTotalMemory();
  int freeRamBytes= await getFreeMemory();
  Map<String, int> storageInfo = await getStorageInfo();
}