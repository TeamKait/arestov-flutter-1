// lib/battery_info_screen.dart

import 'dart:async'; // Подключаем для использования таймера.
import 'package:flutter/material.dart'; // Импортируем пакет Flutter для работы с материалами (UI-компоненты).
import 'package:battery_plus/battery_plus.dart'; // Импортируем пакет для работы с информацией о батарее.
import 'package:battery_info/battery_info_plugin.dart'; // Импортируем плагин для получения информации о батарее.
import 'package:battery_info/model/android_battery_info.dart'; // Импортируем модель для информации о батарее Android.

class BatteryInfoScreen extends StatefulWidget {
  // Определяем StatefulWidget для экрана информации о батарее.
  @override
  _BatteryInfoScreenState createState() =>
      _BatteryInfoScreenState(); // Создаем состояние для BatteryInfoScreen.
}

class _BatteryInfoScreenState extends State<BatteryInfoScreen> {
  // Определяем состояние для экрана информации о батарее.
  final Battery _battery =
      Battery(); // Создаем экземпляр Battery для получения информации о батарее.
  int _batteryLevel = 0; // Уровень заряда батареи.
  BatteryState _batteryState = BatteryState.unknown; // Состояние батареи.
  double _batteryTemperature = 0.0; // Температура батареи.
  double _batteryVoltage = 0.0; // Напряжение батареи.
  bool _isLoading = false; // Флаг для индикации загрузки.
  Timer? _timer; // Таймер для обновления информации.

  @override
  void initState() {
    // Метод, вызываемый при инициализации состояния.
    super.initState(); // Вызываем метод родительского класса.
    _getBatteryInfo(); // Получаем информацию о батарее.
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      // Подписываемся на изменения состояния батареи.
      if (mounted) {
        // Проверяем, что виджет все еще существует.
        setState(() {
          _batteryState = state; // Обновляем состояние батареи.
        });
      }
    });
  }

  Future<void> _getBatteryInfo() async {
    // Асинхронный метод для получения информации о батарее.
    try {
      final batteryLevel =
          await _battery.batteryLevel; // Получаем уровень заряда батареи.
      final batteryState =
          await _battery.batteryState; // Получаем состояние батареи.
      final AndroidBatteryInfo? androidBatteryInfo = await BatteryInfoPlugin()
          .androidBatteryInfo; // Получаем информацию о батарее Android.

      if (mounted) {
        // Проверяем, что виджет все еще существует.
        setState(() {
          // Обновляем состояние.
          _batteryLevel = batteryLevel; // Устанавливаем уровень заряда батареи.
          _batteryState = batteryState; // Устанавливаем состояние батареи.
          _batteryTemperature = androidBatteryInfo?.temperature?.toDouble() ??
              0.0; // Устанавливаем температуру батареи.
          _batteryVoltage =
              (androidBatteryInfo?.voltage ?? 0) / 1000; // Преобразуем мВ в В.
        });
      }
    } catch (e) {
      print(
          'Ошибка получения информации об аккумуляторе: $e'); // Выводим ошибку в консоль.
    }
  }

  // Функция для запуска обновления на 10 секунд.
  void _startUpdatingBatteryInfo() {
    setState(() {
      _isLoading = true; // Показываем индикатор загрузки.
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      // Запускаем таймер, который срабатывает каждую секунду.
      await _getBatteryInfo(); // Обновляем информацию о батарее.

      if (timer.tick >= 10) {
        // После 10 секунд останавливаем таймер.
        timer.cancel();
        setState(() {
          _isLoading = false; // Скрываем индикатор загрузки.
        });
      }
    });
  }

  String _getBatteryStateDescription(BatteryState state) {
    // Метод для получения описания состояния батареи.
    switch (state) {
      case BatteryState.charging:
        return 'Заряжается'; // Описание для заряжающейся батареи.
      case BatteryState.discharging:
        return 'Разряжается'; // Описание для разряжающейся батареи.
      case BatteryState.full:
        return 'Полный заряд'; // Описание для полностью заряженной батареи.
      case BatteryState.unknown:
      default:
        return 'Неизвестно'; // Описание для неизвестного состояния.
    }
  }

  Color _getBatteryLevelColor(int level) {
    // Метод для получения цвета в зависимости от уровня заряда.
    if (level > 75) {
      return Colors.green; // Зеленый цвет для уровня выше 75%.
    } else if (level < 20) {
      return Colors.red; // Красный цвет для уровня ниже 20%.
    } else {
      return Colors.orange; // Оранжевый цвет для уровня от 20% до 75%.
    }
  }

  @override
  void dispose() {
    // Метод, вызываемый при уничтожении виджета.
    _timer?.cancel(); // Останавливаем таймер.
    super.dispose(); // Вызываем метод родительского класса.
  }

  @override
  Widget build(BuildContext context) {
    // Метод, который строит виджет.
    return Scaffold(
      // Создаем Scaffold для основной структуры страницы.
      appBar: AppBar(
        // Создаем верхнюю панель приложения.
        title: Text('Информация об аккумуляторе'), // Заголовок панели.
        backgroundColor: Colors.blueGrey[900], // Цвет фона панели.
        elevation: 0, // Убираем тень.
      ),
      body: SingleChildScrollView(
        // Позволяем прокручивать содержимое.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Столбец для размещения информации о батарее.
          crossAxisAlignment:
              CrossAxisAlignment.start, // Выравнивание по левому краю.
          children: [
            // Индикатор уровня заряда батареи с цветовой индикацией.
            Center(
              // Центрируем индикатор.
              child: Stack(
                // Стек для наложения индикатора и текста.
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 150, // Высота индикатора.
                    width: 150, // Ширина индикатора.
                    child: CircularProgressIndicator(
                      // Индикатор загрузки.
                      value: _batteryLevel / 100, // Уровень заряда.
                      strokeWidth: 12, // Ширина окружности.
                      valueColor: AlwaysStoppedAnimation<Color>(
                        // Цвет индикатора в зависимости от уровня.
                        _getBatteryLevelColor(_batteryLevel),
                      ),
                      backgroundColor:
                          Colors.grey[200], // Цвет фона индикатора.
                    ),
                  ),
                  Text(
                    // Отображаем уровень заряда в центре индикатора.
                    '$_batteryLevel%',
                    style: TextStyle(
                      fontSize: 24, // Размер шрифта.
                      fontWeight: FontWeight.bold, // Жирный шрифт.
                      color: _getBatteryLevelColor(
                          _batteryLevel), // Цвет текста в зависимости от уровня.
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30), // Отступ после индикатора.

            // Карточка с информацией о состоянии батареи.
            _buildInfoCard(
              // Создаем карточку с информацией о состоянии батареи.
              title: 'Состояние',
              value: _getBatteryStateDescription(
                  _batteryState), // Описание состояния батареи.
              icon: Icons.power, // Иконка для состояния.
              backgroundColor: Colors.orange[100], // Цвет фона карточки.
            ),
            SizedBox(height: 20), // Отступ после карточки.

            // Карточка с информацией о температуре.
            _buildInfoCard(
              // Создаем карточку с информацией о температуре.
              title: 'Температура',
              value: '$_batteryTemperature°C', // Температура батареи.
              icon: Icons.thermostat, // Иконка для температуры.
              backgroundColor: Colors.blue[100], // Цвет фона карточки.
            ),
            SizedBox(height: 20), // Отступ после карточки.

            // Карточка с информацией о напряжении.
            _buildInfoCard(
              // Создаем карточку с информацией о напряжении.
              title: 'Напряжение',
              value: '$_batteryVoltage V', // Напряжение батареи.
              icon: Icons.electrical_services, // Иконка для напряжения.
              backgroundColor: Colors.purple[100], // Цвет фона карточки.
            ),
            SizedBox(height: 30), // Отступ перед кнопкой обновления информации.

            // Центрируем кнопку обновления информации с индикатором загрузки.
            Align(
              alignment: Alignment.center,
              child: ElevatedButton.icon(
                // Кнопка с иконкой.
                onPressed: () {
                  _startUpdatingBatteryInfo(); // Запускаем обновление информации о батарее.
                },
                icon: _isLoading // Иконка обновления или индикатор загрузки.
                    ? CircularProgressIndicator(
                        color: Colors.white, // Цвет индикатора.
                        strokeWidth: 2.0, // Ширина индикатора.
                      )
                    : Icon(Icons.refresh), // Иконка обновления.
                label: Text(
                  // Текст на кнопке.
                  _isLoading ? 'Обновляется...' : 'Обновить информацию',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white), // Стиль текста на кнопке.
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[300], // Цвет фона кнопки.
                  padding: EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16), // Отступы внутри кнопки.
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Скругленные углы кнопки.
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Функция для создания карточек с информацией.
  Widget _buildInfoCard({
    // Метод для создания карточек с информацией.
    required String title, // Заголовок карточки.
    required String value, // Значение карточки.
    required IconData icon, // Иконка для карточки.
    required Color? backgroundColor, // Цвет фона карточки.
  }) {
    return Container(
      // Контейнер для карточки.
      padding: EdgeInsets.all(16), // Внутренние отступы карточки.
      decoration: BoxDecoration(
        // Оформление карточки.
        color: backgroundColor, // Цвет фона.
        borderRadius: BorderRadius.circular(12), // Скругленные углы.
        boxShadow: [
          // Тень для карточки.
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Цвет тени.
            spreadRadius: 2, // Радиус распространения тени.
            blurRadius: 10, // Размытие тени.
            offset: Offset(0, 3), // Смещение тени.
          ),
        ],
      ),
      child: Row(
        // Строка для размещения элементов в карточке.
        children: [
          Icon(icon, size: 40, color: Colors.blueGrey[800]), // Иконка.
          SizedBox(width: 20), // Отступ между иконкой и текстом.
          Column(
            // Столбец для текста.
            crossAxisAlignment:
                CrossAxisAlignment.start, // Выравнивание по левому краю.
            children: [
              Text(
                // Заголовок карточки.
                title,
                style: TextStyle(
                  fontSize: 18, // Размер шрифта.
                  fontWeight: FontWeight.w600, // Полужирный шрифт.
                  color: Colors.blueGrey[800], // Цвет заголовка.
                ),
              ),
              SizedBox(height: 5), // Отступ после заголовка.
              Text(
                // Значение карточки.
                value,
                style: TextStyle(
                  fontSize: 16, // Размер шрифта.
                  fontWeight: FontWeight.bold, // Жирный шрифт.
                  color: Colors.blueGrey[900], // Цвет текста значения.
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
