import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database; //? = pode ser nulo

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!; //! = nao nulo
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(
        await getDatabasesPath(), 'database.db'); //onde tem que abrir/criar
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE users(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              email TEXT,
              password TEXT
            )
            ''');
        await db.execute('''
            CREATE TABLE students(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
            )
            ''');
      },
    );
  }
}
