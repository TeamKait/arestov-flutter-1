import 'package:flutter/material.dart';

class BrokenPixelsScreen extends StatefulWidget {
  static ButtonStyle buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 14));

  @override
  State<StatefulWidget> createState() => BrokenPixelsScreenState();
}

class BrokenPixelsScreenState extends State<BrokenPixelsScreen> {
  Color bg = colors[0];
  Color textColor = inverseColors[0];
  static List<Color> colors = [
    Colors.black,
    Colors.white,
    const Color.fromARGB(255, 255, 0, 0),
    const Color.fromARGB(255, 0, 0, 255),
    const Color.fromARGB(255, 0, 255, 0)
  ];
  static List<Color> inverseColors = [
    Colors.white,
    Colors.black,
    Color.fromARGB(255, 0, 0, 255),
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 255, 0, 255)
  ];
  int currentColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          title: Text('Битые пиксели'),
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Нажмите для смены цвета\n\nЗажмите чтобы убрать текст",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => changeBG(),
              onLongPress: () => setState(() {
                textColor = textColor == Colors.transparent
                    ? inverseColors[currentColor]
                    : Colors.transparent;
              }),
            )
          ],
        ));
  }

  void changeBG() {
    setState(() {
      currentColor = (currentColor + 1) % colors.length;
      bg = colors[currentColor];
      textColor = textColor == Colors.transparent
          ? textColor
          : inverseColors[currentColor];
    });
  }
}
