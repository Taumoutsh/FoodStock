import 'dart:async';
import 'package:foodstock/domain/model/article.dart';
import 'package:logging/logging.dart';
import '../../../service/data_provider.dart';
import '../../model/inventaire.dart';
import 'firebase_data_fetcher.dart';

class FirebaseInventaireDataFetcher extends FirebaseDataFetcher<Inventaire> {
  final log = Logger('FirebaseArticleDataFetcher');

  var dataProviderService = DataProviderService();

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
  Future<List<Inventaire>> constructObjectFromDatabase(map) async {
    List<Inventaire> articleToReturn = [];
    for (Map<String, dynamic> mapEntry in map) {
      Article article = dataProviderService
          .articleMap[int.parse(mapEntry['fk_Article'])]!;
      articleToReturn.add(Inventaire(
          pkInventaire: mapEntry['pk_Inventaire'],
          dateAchatArticle: mapEntry['dateAchatArticle'],
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

  @override
  Future<int> updateData(Inventaire t) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}