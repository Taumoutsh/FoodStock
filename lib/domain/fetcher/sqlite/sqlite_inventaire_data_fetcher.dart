import 'dart:async';
import 'package:foodstock/domain/model/article.dart';
import 'package:foodstock/domain/fetcher/sqlite/sqlite_data_fetcher.dart';
import 'package:foodstock/domain/model/inventaire.dart';
import 'package:sqflite/sqflite.dart';
import '../../../database/database.dart';
import 'package:logging/logging.dart';
import '../../../service/data_provider.dart';
import '../interfaces/inventaire_special_queries.dart';

class SqliteInventaireDataFetcher extends SqliteDataFetcher<Inventaire>
    implements InventaireSpecialQueries {
  final log = Logger('InventaireDataFetcher');

  var dataProviderService = DataProviderService();

  Future<List<Inventaire>> getFirstDataFromTableWhereArticle(
      String articleKey, bool byAsc) async {
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

  @override
  Future<String> addData(inventaire) async {
    final Database db = await initDB();
    var pkInventaire = await db.insert(tableName(), inventaire.toSqlite());
    return pkInventaire.toString();
  }

  @override
  Future<List<Inventaire>> addInventoryItems(article, quantity) async {
    List<Inventaire> inventaireListToAdd = [];
    for (int i = 0; i < quantity; i++) {
      Inventaire inventaire = Inventaire(
          dateAchatArticle: DateTime.now().toString(),
          dateAchatArticleDateTime: DateTime.now(),
          article: article);
      String inventaireKey = await addData(inventaire);
      log.info("addToTable() -"
          " Ajout de l'item d'inventaire avec l'identifiant $inventaireKey");
      inventaire.pkInventaire = inventaireKey;

      inventaireListToAdd.add(inventaire);
    }
    return inventaireListToAdd;
  }

  @override
  Future<Inventaire?> removeInventoryItemWhereArticle(Article article,
      int numberOfInventoryToRemove) async {

    final Database db = await initDB();
    Inventaire? inventaireToRemove;
    var primaryKeyNameStr = primaryKeyName();
    String pkArticle = article.pkArticle!;
    var tableNameStr = tableName();
    for (int i = 0; i < numberOfInventoryToRemove; i++) {
      List<Inventaire> listInventaire =
      await getFirstDataFromTableWhereArticle(pkArticle, true);

      inventaireToRemove = listInventaire[0];
      String inventaireToRemoveKey = inventaireToRemove.pkInventaire!;
      var str =
          'fk_Article = $pkArticle AND $primaryKeyNameStr = $inventaireToRemoveKey';
      int i = await db.delete(tableNameStr, where: str, whereArgs: []);
      log.info("removeFromTable() - Suppression de l'item d'inventaire"
          " avec l'identifiant $i");
    }
    return inventaireToRemove;
  }

  @override
  Future<int> removeInventoryItemFromTableWhereArticle(Article article) async {
    String pkArticle = article.pkArticle!;
    final Database db = await initDB();
    String tableNameStr = tableName();
    String str = 'fk_Article = $pkArticle';
    int count = await db.delete(tableNameStr, where: str, whereArgs: []);
    log.info("removeAllArticleFromTable() - Suppression de tous les items"
        " d'inventaire liés à l'article <$pkArticle>."
        " Nombre d'éléments supprimés : <$count>");
    return count;
  }

  @override
  Future<List<Inventaire>> constructObjectFromDatabase(map) async {
    List<Inventaire> articleToReturn = [];
    for (Map<String, dynamic> mapEntry in map) {
      Article article = dataProviderService.articleMap[mapEntry['fk_Article']
          .toString()]!;
      articleToReturn.add(Inventaire(
          pkInventaire: mapEntry['pk_Inventaire'].toString(),
          dateAchatArticle: mapEntry['dateAchatArticle'].toString(),
          dateAchatArticleDateTime:
              DateTime.parse(mapEntry['dateAchatArticle']),
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
