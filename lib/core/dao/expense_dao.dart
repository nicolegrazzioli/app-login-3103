import 'package:app_final/core/database/me_app_database.dart';
import '../models/expense.dart';

class ExpenseDAO {
  static const String table = 'expenses';

  Future<int> insertExpense(Expense expense) async {
    final db = await AppDatabase().database;
    return await db.insert(table, expense.toMap());
  }

  Future<List<Expense>> getExpensesByTrip(int tripId) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'trip_id = ?',
      whereArgs: [tripId],
      orderBy: 'substr(date, 7, 4) DESC, substr(date, 4, 2) DESC, substr(date, 1, 2) DESC, id DESC',
    );
    return result.map((e) => Expense.fromMap(e)).toList();
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
