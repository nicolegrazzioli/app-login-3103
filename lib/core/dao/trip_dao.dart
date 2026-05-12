import 'package:app_final/core/database/me_app_database.dart';
import '../models/trip.dart';

class TripDAO {
  static const String table = 'trips';

  Future<int> insertTrip(Trip trip) async {
    final db = await AppDatabase().database;
    return await db.insert(table, trip.toMap());
  }

  Future<List<Trip>> getTripsByUser(int userId) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'substr(start_date, 7, 4) DESC, substr(start_date, 4, 2) DESC, substr(start_date, 1, 2) DESC, id DESC',
    );
    return result.map((e) => Trip.fromMap(e)).toList();
  }

  Future<int> updateTrip(Trip trip) async {
    final db = await AppDatabase().database;
    return await db.update(
      table,
      trip.toMap(),
      where: 'id = ?',
      whereArgs: [trip.id],
    );
  }

  Future<int> deleteTrip(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
