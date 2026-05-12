import 'package:app_final/core/database/me_app_database.dart';
import '../models/currency_transaction.dart';

class CurrencyTransactionDAO {
  static const String table = 'currency_transactions';

  Future<int> insertTransaction(CurrencyTransaction transaction) async {
    final db = await AppDatabase().database;
    return await db.insert(table, transaction.toMap());
  }

  Future<List<CurrencyTransaction>> getTransactionsByUser(int userId) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'substr(date, 7, 4) DESC, substr(date, 4, 2) DESC, substr(date, 1, 2) DESC, id DESC',
    );
    return result.map((e) => CurrencyTransaction.fromMap(e)).toList();
  }

  Future<int> updateTransaction(CurrencyTransaction transaction) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
