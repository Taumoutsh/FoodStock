import 'dart:async';
import 'package:inventaire_m_et_t/domain/inventaire.dart';
import 'package:sqflite/sqflite.dart';
import 'article.dart';
import 'type_article.dart';
import '../database/database.dart';
import 'mapped_object.dart';

abstract class DataFetcher<T extends MappedObject> {

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

  Future<List<T>> getDataFromTable() async {
    // Get a reference to the database.
    final Database db = await initDB();

    final List<Map<String, dynamic>> map = await db.query(tableName());

    return constructObjectFromDatabase(map);
  }

  Future<void> removeDataFromTable(int primaryKey) async {
    final Database db = await initDB();

    var primaryKeyNameStr = primaryKeyName();

    db.delete(tableName(),
        where: "$primaryKeyNameStr = $primaryKey");
  }

  Future<void> addToTable(article, quantity) async {
    final Database db = await initDB();

    for(int i = 0; i < quantity; i++) {
      Inventaire inventaire = new Inventaire(
            dateAchatArticle: DateTime.now().toString(), article: article);

      db.insert(tableName(), inventaire.toMap());
    }
  }

  Future<void> removeFromTable(Article article, quantity) async {
    final Database db = await initDB();

    var primaryKeyNameStr = primaryKeyName();
    int pkArticle = article.pkArticle;
    var tableNameStr = tableName();

    for(int i = 0; i < quantity; i++) {
      var str = 'fk_Article = $pkArticle AND $primaryKeyNameStr = '
          '(SELECT $primaryKeyNameStr FROM $tableNameStr'
          ' WHERE fk_Article = $pkArticle'
          ' ORDER BY $primaryKeyNameStr LIMIT 2)';
      var int = await db.delete(tableNameStr,
          where: str,
      whereArgs: []);
      print(int);
    }
  }
}