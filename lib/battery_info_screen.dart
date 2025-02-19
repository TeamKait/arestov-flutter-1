import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
// import 'package:battery_info/battery_info_plugin.dart';
// import 'package:battery_info/model/android_battery_info.dart';

class BatteryInfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BatteryInfoScreenState();
}

class _BatteryInfoScreenState extends State<BatteryInfoScreen> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  BatteryState _batteryState = BatteryState.unknown;
  double _batteryTemperature = 0.0;
  double _batteryVoltage = 0.0;
  bool _isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getBatteryInfo();
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      if (mounted) {
        setState(() {
          _batteryState = state;
        });
      }
    });
  }

  Future<void> _getBatteryInfo() async {
    try {
      final batteryLevel = await _battery.batteryLevel;
      final batteryState = await _battery.batteryState;
      print(batteryState);

      // final AndroidBatteryInfo? androidBatteryInfo =
      //     await BatteryInfoPlugin().androidBatteryInfo;

      if (mounted) {
        setState(() {
          _batteryLevel = batteryLevel;
          _batteryState = batteryState;
          // _batteryTemperature =
          //     androidBatteryInfo?.temperature?.toDouble() ?? 0.0;
          // _batteryVoltage = (androidBatteryInfo?.voltage ?? 0) / 1000;
        });
      }
    } catch (e) {
      print('Ошибка получения информации об аккумуляторе: $e');
    }
  }

  void _startUpdatingBatteryInfo() {
    setState(() {
      _isLoading = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      await _getBatteryInfo();
      if (timer.tick >= 10) {
        timer.cancel();
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  String _getBatteryStateDescription(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return 'Заряжается';
      case BatteryState.discharging:
        return 'Разряжается';
      case BatteryState.full:
        return 'Полный заряд';
      case BatteryState.connectedNotCharging:
        return "Подключен";
      case BatteryState.unknown:
      default:
        return "Неизвестно";
    }
  }

  Color _getBatteryLevelColor(int level) {
    if (level > 75) {
      return Colors.green;
    } else if (level < 20) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация об аккумуляторе'),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: CircularProgressIndicator(
                      value: _batteryLevel / 100,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                          _getBatteryLevelColor(_batteryLevel)),
                    ),
                  ),
                  Text(
                    '$_batteryLevel%',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getBatteryLevelColor(_batteryLevel)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _buildInfoCard(
              title: 'Состояние',
              value: _getBatteryStateDescription(_batteryState),
              icon: Icons.power,
              backgroundColor: Colors.orange[300],
            ),
            SizedBox(
              height: 20,
            ),
            _buildInfoCard(
              title: 'Температура',
              value: '$_batteryTemperature C',
              icon: Icons.thermostat,
              backgroundColor: Colors.orange[300],
            ),
            SizedBox(
              height: 20,
            ),
            _buildInfoCard(
              title: 'Напряжение',
              value: '$_batteryVoltage V',
              icon: Icons.electrical_services,
              backgroundColor: Colors.orange[300],
            ),
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                  onPressed: () {
                    _startUpdatingBatteryInfo();
                  },
                  icon: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.0)
                      : Icon(Icons.refresh),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[300],
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  label: Text(
                    _isLoading ? 'Обновляется...' : 'Обновить информацию',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color? backgroundColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 3))
          ]),
      child: Row(
        children: [
          Icon(
            icon,
            size: 40,
            color: Colors.blueGrey[800],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[800]),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900]),
              )
            ],
          ),
        ],
      ),
    );
  }
}
