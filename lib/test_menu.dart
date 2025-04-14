import 'package:flutter/material.dart';
import 'testing/broken_pixels_screen.dart';
import 'package:path/path.dart';
import 'testing/vibration_screen.dart';
import 'testing/touchscreen_test.dart';

class TestMenu extends StatelessWidget {
  static ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 14));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Доступные тесты",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VibrationScreen(),
                          ));
                    },
                    style: buttonStyle,
                    child: const Text("Вибрация"),
                  ),
                ),

                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BrokenPixelsScreen(),
                          ));
                    },
                    style: buttonStyle,
                    child: const Text("Битые пиксели"),
                  ),
                ),

                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TouchTestScreen(),
                          ));
                    },
                    style: buttonStyle,
                    child: const Text("Сенсорный экран"),
                  ),
                ),

                // Expanded(
                //   child: TextButton(
                //     onPressed: (){
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => TODO();
                //         )
                //       );
                //     },
                //     style: buttonStyle,
                //     child: const Text("Связь"),
                //   ),
                // ),

                // Expanded(
                //   child: TextButton(
                //     onPressed: (){
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => TODO();
                //         )
                //       );
                //     },
                //     style: buttonStyle,
                //     child: const Text("Вибрация"),
                //   ),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
