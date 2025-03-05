import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/codecs_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  const mockCodecs = [
    'CMX.qcom.video.decoder.avc',
    'CMX.google.aac.decoder',
    'CMX.google.amrnb.decoder'
  ];

  Future<List<String>> mockGetCodecs() async {
    return mockCodecs;
  }

  Widget createCodecsScreen() {
    return MaterialApp(
      home: CodecsScreenWithMock(mockGetCodecs),
    );
  }

  testWidgets('Тест: Отображение списка кодеков и функциональность элементов',
      (WidgetTester tester) async {
    await tester.pumpWidget(createCodecsScreen());

    expect(find.text('Информация о кодеках'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Поддерживаемые кодеки'), findsOneWidget);

    for (var codec in mockCodecs) {
      expect(find.text(codec), findsOneWidget);
    }

    await tester.tap(find.byIcon(Icons.notifications));
    await tester.pumpAndSettle();
    expect(find.text('Оповещение'), findsOneWidget);
    expect(find.text('Это диалоговое окно для демонстрации оповещения.'),
        findsOneWidget);

    await tester.tap(find.text('Закрыть'));
    await tester.pumpAndSettle();
    expect(find.text('Оповещение'), findsNothing);

    await tester.tap(find.text('Показать SnackBar'));
    await tester.pump();
    expect(find.text('Вы нажали на кнопку оповещения!'), findsOneWidget);

    Fluttertoast.cancel();
    await tester.tap(find.text('Показать Toast'));
    await tester.pump();
  });
}

class CodecsScreenWithMock extends StatelessWidget {
  final Future<List<String>> Function() mockGetCodecs;

  CodecsScreenWithMock(this.mockGetCodecs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Информация о кодеках"),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              _showDialog(context);
            },
          )
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: mockGetCodecs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Ошибка: ${snapshot.error}"));
          } else {
            List<String> codecs = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Поддерживаемые кодеки',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ниже представлен список кодеков, поддерживаемых на вашем устройстве:',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Вы нажали на кнопку оповещения!"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Text("Показать SnackBar"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showToast("Это уведомление Toast");
                    },
                    child: Text("Показать Toast"),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: codecs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 4.0,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Icon(Icons.audiotrack,
                                color: Colors.blueAccent),
                            title: Text(
                              codecs[index],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Оповещение"),
            content: Text("Это диалоговое окно для демонстрации оповещения."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Закрыть"))
            ],
          );
        });
  }
}
