import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('О приложении'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/image/app_logo.png',
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Название приложения: Мобильное Инфо',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.teal[300]!,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                'Это приложение предназначено для отображения информации о системе и устройствах, установленных на устройстве приложениях, а также для проведения тестирования. Вы можете получить подробные данные о процессоре, аккумуляторе',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Версия приложения 1.0.0',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(Icons.info, color: Colors.teal[700]),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Разработчики: Дерин Владислав и Лющенко Артем',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                _makePhoneCall('tel:+1234567890');
              },
              child: Row(
                children: [
                  Icon(Icons.phone, color: Colors.teal[700]),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Свяжитесь с нами: +1 (234) 567-890',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    final Uri launchUri = Uri(scheme: 'tel', path: '+1234567890');
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw "Не удалось открыть $url";
    }
  }
}
