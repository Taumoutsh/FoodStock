import 'dart:async';
import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/data_fetcher.dart';
import 'package:inventaire_m_et_t/domain/inventaire.dart';
import 'package:sqflite/sqflite.dart';
import 'article_data_fetcher.dart';
import 'type_article.dart';
import '../database/database.dart';
import 'mapped_object.dart';

class InventaireDataFetcher extends DataFetcher<Inventaire> {

  ArticleDataFetcher articleDataFetcher = new ArticleDataFetcher();

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
}
