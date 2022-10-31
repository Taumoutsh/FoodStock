import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../database/database.dart';
import 'mapped_object.dart';

abstract class DataFetcher<T> {

  Future<List<T>> constructObjectFromDatabase(List<Map<String, dynamic>> map);

  String tableName();

  String primaryKeyName();

  String labelName();


  Future<List<T>> getData(int primaryKey) async {
    // Get a reference to the database.
    final Database db = await initDB();

    var primaryKeyNameStr = primaryKeyName();
    final List<Map<String, dynamic>> map = await db.query(tableName(),
                where: "$primaryKeyNameStr = $primaryKey");

    return constructObjectFromDatabase(map);
  }

  Future<List<T>> getDataOrderBy(int primaryKey, String orderByColumn) async {
    // Get a reference to the database.
    final Database db = await initDB();

    var primaryKeyNameStr = primaryKeyName();
    final List<Map<String, dynamic>> map = await db.query(tableName(),
        where: "$primaryKeyNameStr = $primaryKey",
        orderBy: orderByColumn + " DESC");

    return constructObjectFromDatabase(map);
  }

  Future<List<T>> getDataFromTable() async {
    // Get a reference to the database.
    final Database db = await initDB();

    final List<Map<String, dynamic>> map = await db.query(tableName());

    return constructObjectFromDatabase(map);
  }

  Future<List<T>> getDataFromTableOrderBy(String label, bool byAsc) async {
    // Get a reference to the database.
    final Database db = await initDB();

    String orderByDirection = "";
    if (byAsc) {
      orderByDirection = "ASC";
    } else {
      orderByDirection = "DESC";
    }

    final List<Map<String, dynamic>> map = await db.query(tableName(),
    orderBy: label + " " + orderByDirection);

    return constructObjectFromDatabase(map);
  }

  Future<void> removeDataFromTable(int primaryKey) async {
    final Database db = await initDB();

    var primaryKeyNameStr = primaryKeyName();

    db.delete(tableName(),
        where: "$primaryKeyNameStr = $primaryKey");
  }
}