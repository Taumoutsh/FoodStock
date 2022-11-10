import 'dart:async';
import 'package:foodstock/domain/model/article.dart';
import 'package:foodstock/domain/fetcher/sqlite/sqlite_data_fetcher.dart';
import 'package:logging/logging.dart';
import 'package:sqflite/sqflite.dart';
import '../../../database/database.dart';
import '../../../service/data_provider.dart';
import '../../model/type_article.dart';

class SqliteArticleDataFetcher extends SqliteDataFetcher<Article> {
  final log = Logger('InventaireDataFetcher');

  var dataProviderService = DataProviderService();

  @override
  Future<List<Article>> getDataFromTable() async {
    // Get a reference to the database.
    final Database db = await initDB();

    String estFavoris = Article.FAVORITE_NAME;

    final List<Map<String, dynamic>> map = await db.query(tableName(),
    orderBy: "$estFavoris DESC");

    return constructObjectFromDatabase(map);
  }

  Future<int> updateData(Article article) async {
    int articleNumberUpdated;
    int primaryKey = article.pkArticle!;
    article.toMap();
    final Database db = await initDB();

    var primaryKeyNameStr = primaryKeyName();
    articleNumberUpdated = await db.update(tableName(), article.toMap(),
        where: "$primaryKeyNameStr = $primaryKey");
    log.info("updateArticleFavoriteStatus() - Mise à jours de l'article"
        "  <$article> ayant pour clé primarire <$articleNumberUpdated>");
    return articleNumberUpdated;
  }

  Future<int> addArticleInDatabase(Article article) async {
    int articleNumberUpdated;
    article.toMap();
    final Database db = await initDB();

    articleNumberUpdated = await db.insert(tableName(), article.toMap());

    return articleNumberUpdated;
  }

  Future<int> removeArticleFromDatabase(int articlePrimaryKey) async {
    final Database db = await initDB();

    String primaryKeyString = primaryKeyName();
    String tableNameString = tableName();

    String str = "$primaryKeyString = $articlePrimaryKey";

    int count = await db.delete(tableNameString, where: str, whereArgs: []);

    return count;
  }

  @override
  Future<List<Article>> constructObjectFromDatabase(List<Map<String, dynamic>> map) async {
    List<Article> articleToReturn = [];
    for (Map<String, dynamic> mapEntry in map) {
        TypeArticle typeArticle = dataProviderService
            .typeArticleMap[mapEntry['fk_TypeArticle']]!;
        articleToReturn.add(Article(
            pkArticle: mapEntry['pk_Article'],
            labelArticle: mapEntry['labelArticle'],
            peremptionEnJours: mapEntry['peremptionEnJours'],
            quantiteAlerte: mapEntry['quantiteAlerte'],
            quantiteCritique: mapEntry['quantiteCritique'],
            estFavoris: mapEntry['estFavoris'] == 1 ? true : false,
            typeArticle: typeArticle));
      }
    return Future(() => articleToReturn);
  }

  @override
  String tableName() {
    return Article.TABLE_NAME;
  }

  @override
  String labelName() {
    return Article.LABEL_NAME;
  }

  @override
  String primaryKeyName() {
    return Article.PK_NAME;
  }
}