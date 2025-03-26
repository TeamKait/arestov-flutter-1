import 'package:flutter/material.dart';
import 'package:path/path.dart';

class TestMenu extends StatelessWidget{
  static ButtonStyle buttonStyle = TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 14)
                    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TODO();
                        )
                      );
                    },
                    style: buttonStyle,
                    child: const Text("Экран"),
                  ),
                ),

                Expanded(
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TODO();
                        )
                      );
                    },
                    style: buttonStyle,
                    child: const Text("Аудио"),
                  ),
                ),

                Expanded(
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TODO();
                        )
                      );
                    },
                    style: buttonStyle,
                    child: const Text("Камера"),
                  ),
                ),

                Expanded(
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TODO();
                        )
                      );
                    },
                    style: buttonStyle,
                    child: const Text("Связь"),
                  ),
                ),

                Expanded(
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TODO();
                        )
                      );
                    },
                    style: buttonStyle,
                    child: const Text("Вибрация"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    )
  }
}