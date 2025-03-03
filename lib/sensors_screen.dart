import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class SensorsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _barometerValues;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  StreamSubscription<UserAccelerometerEvent>? _userAccelerometerSubscription;
  Stream<BarometerEvent>? _barometerSubscription;

  @override
  void initState() {
    super.initState();

    _barometerSubscription = barometerEventStream();
    _barometerSubscription?.asBroadcastStream().listen((data) {
      if (mounted) {
        setState(() {
          _barometerValues = [data.pressure];
        });
      }
    });

    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      if (mounted) {
        setState(() {
          _accelerometerValues = [event.x, event.y, event.z];
        });
      }
    });

    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      if (mounted) {
        setState(() {
          _gyroscopeValues = [event.x, event.y, event.z];
        });
      }
    });

    _magnetometerSubscription =
        magnetometerEvents.listen((MagnetometerEvent event) {
      if (mounted) {
        setState(() {
          _magnetometerValues = [event.x, event.y, event.z];
        });
      }
    });

    _userAccelerometerSubscription =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (mounted) {
        setState(() {
          _userAccelerometerValues = [event.x, event.y, event.z];
        });
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _magnetometerSubscription?.cancel();
    _userAccelerometerSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accelerometer = _accelerometerValues
            ?.map((v) => v.toStringAsFixed(2))
            .toList()
            .join(', ') ??
        "Данные недоступны";
    final gyroscope = _gyroscopeValues
            ?.map((v) => v.toStringAsFixed(2))
            .toList()
            .join(', ') ??
        "Данные недоступны";
    final magnetometer = _magnetometerValues
            ?.map((v) => v.toStringAsFixed(2))
            .toList()
            .join(', ') ??
        "Данные недоступны";
    final userAccelerometer = _userAccelerometerValues
            ?.map((v) => v.toStringAsFixed(2))
            .toList()
            .join(', ') ??
        "Данные недоступны";

    final barometer = _barometerValues
            ?.map((v) => v.toStringAsFixed(2))
            .toList()
            .join(', ') ??
        "Данные недоступны";
    return Scaffold(
      appBar: AppBar(
        title: Text("Датчики"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Акселерометр", Icons.trending_up),
              Divider(),
              _buildSensorCard("Значения $accelerometer"),
              SizedBox(
                height: 20,
              ),
              _buildSectionTitle("Гироскоп", Icons.sync),
              Divider(),
              _buildSensorCard("Значения: $gyroscope"),
              SizedBox(
                height: 20,
              ),
              _buildSectionTitle("Магнитометр", Icons.explore),
              Divider(),
              _buildSensorCard("Значения: $magnetometer"),
              SizedBox(
                height: 20,
              ),
              _buildSectionTitle(
                  "Пользовательский акселерометр", Icons.trending_flat),
              Divider(),
              _buildSensorCard("Значения: $userAccelerometer"),
              SizedBox(
                height: 20,
              ),
              _buildSectionTitle("Барометр", Icons.speed),
              Divider(),
              _buildSensorCard("Значения: $barometer"),
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

  Widget _buildSensorCard(String sensorData) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                sensorData,
                style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 255, 254, 254)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
