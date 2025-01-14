// Импортирование библиотек
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Интерфейс для работы с БД
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Ссылка на экземпляр
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  // Получение экземпляра БД
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Инициализация БД
  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'users.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT UNIQUE, password TEXT)");
      },
      version: 1,
    );
  }

  // Создать админ-пользователя
  Future<void> insertAdminUser() async {
    final db = await database;

    await db.insert("users", {"username": "admin", "password": "admin"},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Аутентификация пользователя
  Future<bool> authUser(String username, password) async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query('users',
        where: "username = ? AND password = ?",
        whereArgs: [username, password]);

    return users.isNotEmpty;
  }

  // Регистрация пользователя
  Future<bool> registerUser(String username, password) async {
    final db = await database;
    try {
      await db.insert("user", {"username": username, "password": password},
          conflictAlgorithm: ConflictAlgorithm.ignore);
    } catch (e) {
      print("error registering user");
      throw Exception("Register failed");
    }
    final List<Map<String, dynamic>> users = await db.query('users',
        where: "username = ? AND password = ?",
        whereArgs: [username, password]);

    return users.isNotEmpty;
  }
}
