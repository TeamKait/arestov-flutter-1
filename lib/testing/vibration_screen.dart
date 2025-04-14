import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class VibrationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VibrationScreenState();
}

class VibrationScreenState extends State<VibrationScreen> {
  static ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 14));

  bool isVibrating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Вибрация'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: CircularProgressIndicator(
                color: Colors.teal,
                value: isVibrating ? null : 0,
              ),
            ),
            Text(
              "Проверка вибромотора",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Vibrate(500);
                      Vibration.vibrate(duration: 500);
                    },
                    child: Text('Короткая'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Vibrate(2000);
                      Vibration.vibrate(duration: 2000);
                    },
                    child: Text('Длинная'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Vibrate(2000);
                      Vibration.vibrate(pattern: [500, 200, 1000, 200, 100]);
                    },
                    child: Text('Паттерн'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void Vibrate(int duration) {
    setState(() {
      isVibrating = true;
    });

    Future.delayed(Duration(milliseconds: duration), () {
      setState(() {
        isVibrating = false;
      });
    });
  }
}
