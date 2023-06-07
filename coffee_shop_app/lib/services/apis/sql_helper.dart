import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../models/cart_food.dart';

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE cartFood(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      userId TEXT NOT NULL,
      foodId TEXT NOT NULL,
      quantity INTEGER,
      size TEXT NOT NULL,
      topping TEXT, 
      note TEXT
    )
""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'localDB.db',
      version: 1,
      onCreate: (db, version) async {
        await createTable(db);
      },
    );
  }

  static Future<int> createCartFood(CartFood cartFood) async {
    final db = await SQLHelper.db();

    final data = cartFood.toMap();
    final id = await db.insert('cartFood', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getCartFood(String userId) async {
    final db = await SQLHelper.db();
    print('USER ID: $userId');
    return db.query('cartFood',
        where: "userId = ?", whereArgs: [userId], orderBy: "id");
  }

  static Future<int> updateCartFood(CartFood cartFood) async {
    final db = await SQLHelper.db();
    final data = cartFood.toMap();

    final result = await db
        .update('cartFood', data, where: "id = ?", whereArgs: [cartFood.id]);
    return result;
  }

  static Future<void> deleteCartFood(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("cartFood", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
