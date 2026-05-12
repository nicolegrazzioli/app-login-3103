import 'package:app_final/core/database/me_app_database.dart';
import '../models/wallet.dart';

class WalletDAO {
  static const String table = 'wallets';

  Future<int> insertWallet(Wallet wallet) async {
    final db = await AppDatabase().database;
    return await db.insert(table, wallet.toMap());
  }

  Future<List<Wallet>> getWalletsByUser(int userId) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return result.map((e) => Wallet.fromMap(e)).toList();
  }

  Future<Wallet?> getWallet(int userId, String currency) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'user_id = ? AND currency = ?',
      whereArgs: [userId, currency],
    );
    return result.isNotEmpty ? Wallet.fromMap(result.first) : null;
  }

  Future<int> updateWallet(Wallet wallet) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      wallet.toMap(),
      where: 'user_id = ? AND currency = ?',
      whereArgs: [wallet.userId, wallet.currency],
    );
  }

  Future<int> deleteWallet(int userId, String currency) async {
    final db = await AppDatabase().database;
    return await db.delete(
      table,
      where: 'user_id = ? AND currency = ?',
      whereArgs: [userId, currency],
    );
  }
}
