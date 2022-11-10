import 'dart:async';
import 'package:foodstock/domain/model/article.dart';
import 'package:logging/logging.dart';
import '../../../service/data_provider.dart';
import '../../model/type_article.dart';
import 'firebase_data_fetcher.dart';

class FirebaseArticleDataFetcher extends FirebaseDataFetcher<Article> {
  var dataProviderService = DataProviderService();

  final log = Logger('FirebaseArticleDataFetcher');

  Future<int> updateArticleFavoriteStatus(Article article) async {
    return 1;
  }

  Future<int> addArticleInDatabase(Article article) async {
    return 1;
  }

  Future<int> removeArticleFromDatabase(int articlePrimaryKey) async {
    return 1;
  }

  @override
  Future<List<Article>> constructObjectFromDatabase(
      List<Map<String, dynamic>> map) async {
    List<Article> articleToReturn = [];
    for (Map<String, dynamic> mapEntry in map) {
      TypeArticle typeArticle = dataProviderService
          .typeArticleMap[int.parse(mapEntry['fk_TypeArticle'])]!;
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

  @override
  Future<int> updateData(Article t) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}
