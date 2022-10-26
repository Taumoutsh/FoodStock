import 'dart:async';
import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/data_fetcher.dart';
import 'package:inventaire_m_et_t/domain/type_article_data_fetcher.dart';
import 'package:sqflite/sqflite.dart';
import 'type_article.dart';
import '../database/database.dart';
import 'mapped_object.dart';

class ArticleDataFetcher extends DataFetcher<Article> {

  TypeArticleDataFetcher typeArticleDataFetcher = new TypeArticleDataFetcher();

  @override
  Future<List<Article>> getDataFromTable() async {
    // Get a reference to the database.
    final Database db = await initDB();

    String estFavoris = Article.FAVORITE_NAME;

    final List<Map<String, dynamic>> map = await db.query(tableName(),
    orderBy: "$estFavoris DESC");

    return constructObjectFromDatabase(map);
  }

  Future<int> updateArticleFavoriteStatus(Article article) async {
    int articleNumberUpdated;
    int primaryKey = article.pkArticle;
    article.toMap();
    final Database db = await initDB();

    var primaryKeyNameStr = primaryKeyName();
    articleNumberUpdated = await db.update(tableName(), article.toMap(),
        where: "$primaryKeyNameStr = $primaryKey");

    return articleNumberUpdated;
  }

  @override
  Future<List<Article>> constructObjectFromDatabase(List<Map<String, dynamic>> map) async {
    List<Article> articleToReturn = [];
    for (Map<String, dynamic> mapEntry in map) {
        List<TypeArticle> listTypeArticle = await typeArticleDataFetcher.getData(mapEntry['fk_TypeArticle']);
        articleToReturn.add(Article(
            pkArticle: mapEntry['pk_Article'],
            labelArticle: mapEntry['labelArticle'],
            peremptionEnJours: mapEntry['peremptionEnJours'],
            estFavoris: mapEntry['estFavoris'] == 1 ? true : false,
            typeArticle: listTypeArticle[0]));
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