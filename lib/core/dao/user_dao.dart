import 'package:app_final/core/app_database.dart';
import '../models/user.dart';

class UserDao {
  static const String table = 'users';

  Future<int> insertUser(User user) async {
    final db = await AppDatabase().database; //cria ou acessa i banco
    return db.insert(table, user.toMap());
  }

  Future<User?> getUser(String email, String password) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? User.fromMap(result.first) : /*false*/ null;
  }
}