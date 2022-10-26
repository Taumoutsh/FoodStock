import 'dart:async';
import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/data_fetcher.dart';
import 'package:inventaire_m_et_t/domain/inventaire.dart';
import 'package:sqflite/sqflite.dart';
import 'article_data_fetcher.dart';
import '../database/database.dart';
import 'package:logging/logging.dart';

class InventaireDataFetcher extends DataFetcher<Inventaire> {

  final log = Logger('InventaireDataFetcher');

  ArticleDataFetcher articleDataFetcher = new ArticleDataFetcher();

  Future<List<Inventaire>> getFirstDataFromTableWhereArticle(int articleKey) async {
    // Get a reference to the database.
    final Database db = await initDB();

    String foreignKeyNameString = foreignKeyName();

    final List<Map<String, dynamic>> map = await db.query(tableName(),
        where: "$foreignKeyNameString = $articleKey LIMIT 1");

    return constructObjectFromDatabase(map);
  }

  Future<List<Inventaire>> addToTable(article, quantity) async {
    final Database db = await initDB();

    List<Inventaire> inventaireListToAdd = [];

    for(int i = 0; i < quantity; i++) {
      Inventaire inventaire = new Inventaire(
          dateAchatArticle: DateTime.now().toString(), article: article);

      int i = await db.insert(tableName(), inventaire.toMap());
      print(i);

      inventaire.pkInventaire = i;

      inventaireListToAdd.add(inventaire);
    }
    return inventaireListToAdd;
  }

  Future<List<Inventaire>> removeFromTable(Article article, quantity) async {
    final Database db = await initDB();

    List<Inventaire> inventaireListToRemove = [];

    var primaryKeyNameStr = primaryKeyName();
    int pkArticle = article.pkArticle;
    var tableNameStr = tableName();

    for(int i = 0; i < quantity; i++) {

      List<Inventaire> listInventaire =
      await getFirstDataFromTableWhereArticle(pkArticle);

      Inventaire inventaireToRemove = listInventaire[0];
      int inventaireToRemoveKey = inventaireToRemove.pkInventaire!;

      var str = 'fk_Article = $pkArticle AND $primaryKeyNameStr = $inventaireToRemoveKey';
      int i = await db.delete(tableNameStr,
          where: str,
          whereArgs: []);
      log.info("InventaireDataFetcher() - Suppression de l'inventaire avec l'identifiant $i");
      print(i);
      inventaireListToRemove.add(inventaireToRemove);
    }
    return inventaireListToRemove;
  }

  @override
  Future<List<Inventaire>> constructObjectFromDatabase(map) async {
    List<Inventaire> articleToReturn = [];
    for (Map<String, dynamic> mapEntry in map) {
      List<Article> listArticle = await articleDataFetcher.getData(
          mapEntry['fk_Article']);
      articleToReturn.add(Inventaire(
          pkInventaire: mapEntry['pk_Inventaire'],
          dateAchatArticle: mapEntry['dateAchatArticle'].toString(),
          article: listArticle[0]
      ));
    }
    return Future(() => articleToReturn);
  }

  @override
  String tableName() {
    return Inventaire.TABLE_NAME;
  }

  @override
  String labelName() {
    return Inventaire.LABEL_NAME;
  }

  @override
  String primaryKeyName() {
    return Inventaire.PK_NAME;
  }

  String foreignKeyName() {
    return Inventaire.FK_ARTICLE;
  }
}
