import 'dart:async';
import 'package:foodstock/domain/model/article.dart';
import 'package:foodstock/domain/fetcher/sqlite/sqlite_data_fetcher.dart';
import 'package:foodstock/domain/model/inventaire.dart';
import 'package:sqflite/sqflite.dart';
import '../../../database/database.dart';
import 'package:logging/logging.dart';
import '../../../service/data_provider.dart';

class SqliteInventaireDataFetcher extends SqliteDataFetcher<Inventaire> {
  final log = Logger('InventaireDataFetcher');

  var dataProviderService = DataProviderService();

  Future<List<Inventaire>> getFirstDataFromTableWhereArticle(
      int articleKey, bool byAsc) async {
    // Get a reference to the database.
    final Database db = await initDB();

    String foreignKeyNameString = foreignKeyName();
    String dateAchatArticleString = labelName();

    String orderByDirection = "";
    if (byAsc) {
      orderByDirection = "ASC";
    } else {
      orderByDirection = "DESC";
    }

    final List<Map<String, dynamic>> map = await db.query(tableName(),
        where: "$foreignKeyNameString = $articleKey",
        orderBy: dateAchatArticleString + " " + orderByDirection,
        limit: 1);

    return constructObjectFromDatabase(map);
  }

  Future<List<Inventaire>> addToTable(article, quantity) async {
    final Database db = await initDB();

    List<Inventaire> inventaireListToAdd = [];

    for (int i = 0; i < quantity; i++) {
      Inventaire inventaire = Inventaire(
          dateAchatArticle: DateTime.now().toString(), article: article);
      int i = await db.insert(tableName(), inventaire.toMap());
      log.info("addToTable() -"
              " Ajout de l'item d'inventaire avec l'identifiant $i");
      inventaire.pkInventaire = i;

      inventaireListToAdd.add(inventaire);
    }
    return inventaireListToAdd;
  }

  Future<List<Inventaire>> removeFromTable(Article article, quantity) async {
    final Database db = await initDB();

    List<Inventaire> inventaireListToRemove = [];

    var primaryKeyNameStr = primaryKeyName();
    int pkArticle = article.pkArticle!;
    var tableNameStr = tableName();

    for (int i = 0; i < quantity; i++) {
      List<Inventaire> listInventaire =
          await getFirstDataFromTableWhereArticle(pkArticle, true);

      Inventaire inventaireToRemove = listInventaire[0];
      int inventaireToRemoveKey = inventaireToRemove.pkInventaire!;

      var str =
          'fk_Article = $pkArticle AND $primaryKeyNameStr = $inventaireToRemoveKey';
      int i = await db.delete(tableNameStr, where: str, whereArgs: []);
      log.info("removeFromTable() - Suppression de l'item d'inventaire"
              " avec l'identifiant $i");
      inventaireListToRemove.add(inventaireToRemove);
    }
    return inventaireListToRemove;
  }

  Future<int> removeAllArticleFromTable(int articleKey) async {
    final Database db = await initDB();

    String tableNameStr = tableName();
    String str = 'fk_Article = $articleKey';
    int count = await db.delete(tableNameStr, where: str, whereArgs: []);
    log.info("removeAllArticleFromTable() - Suppression de tous les items"
        " d'inventaire liés à l'article <$articleKey>."
        " Nombre d'éléments supprimés : <$count>");
    return count;
  }

  @override
  Future<List<Inventaire>> constructObjectFromDatabase(map) async {
    List<Inventaire> articleToReturn = [];
    for (Map<String, dynamic> mapEntry in map) {
      Article article =
      dataProviderService.articleMap[mapEntry['fk_Article']]!;
      articleToReturn.add(Inventaire(
          pkInventaire: mapEntry['pk_Inventaire'],
          dateAchatArticle: mapEntry['dateAchatArticle'].toString(),
          article: article));
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

  @override
  Future<int> updateData(Inventaire t) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}
