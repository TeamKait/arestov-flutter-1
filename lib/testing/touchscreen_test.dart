import 'package:flutter/material.dart';
import 'dart:math';

class TouchTestScreen extends StatefulWidget {
  @override
  _TouchTestScreenState createState() => _TouchTestScreenState();
}

class _TouchTestScreenState extends State<TouchTestScreen> {
  final Map<int, Offset> pointers = {};
  final Map<int, Color> pointerColors = {};
  final List<int> pointerOrder = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Тест сенсора касания"),
      ),
      body: Listener(
        onPointerDown: _handlePointerDown,
        onPointerMove: _handlePointerMove,
        onPointerUp: _handlePointerUp,
        onPointerCancel: _handlePointerCancel,
        child: CustomPaint(
          painter: TouchPainter(pointers, pointerColors, pointerOrder),
          child: Container(),
        ),
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    setState(() {
      pointers[event.pointer] = event.localPosition;
      pointerColors[event.pointer] = getRandomColor();
      pointerOrder.add(event.pointer);
    });
  }

  void _handlePointerMove(PointerMoveEvent event) {
    setState(() {
      pointers[event.pointer] = event.localPosition;
    });
  }

  void _handlePointerUp(PointerUpEvent event) {
    setState(() {
      pointers.remove(event.pointer);
      pointerColors.remove(event.pointer);
      pointerOrder.remove(event.pointer);
    });
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    setState(() {
      pointers.remove(event.pointer);
      pointerColors.remove(event.pointer);
      pointerOrder.remove(event.pointer);
    });
  }
}

class TouchPainter extends CustomPainter {
  final Map<int, Offset> pointers;
  final Map<int, Color> colors;
  final List<int> pointerOrder;

  TouchPainter(this.pointers, this.colors, this.pointerOrder);

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(color: Colors.white, fontSize: 16);

    pointers.forEach((id, position) {
      final color = colors[id] ?? Colors.grey;
      final index = pointerOrder.indexOf(id) + 1;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(position, 30, paint);

      final textSpan = TextSpan(
        text: "$index",
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, position + Offset(35, -10));
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Color getRandomColor() {
  final Random rand = Random();
  int r = 0, g = 0, b = 0;
  while (r + g + b < 300) {
    r = rand.nextInt(256);
    g = rand.nextInt(256);
    b = rand.nextInt(256);
  }
  return Color.fromARGB(255, r, g, b);
}
