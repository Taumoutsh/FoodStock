import 'dart:async';
import 'package:foodstock/domain/model/article.dart';
import 'package:logging/logging.dart';
import '../../model/type_article.dart';
import 'firebase_data_fetcher.dart';

class FirebaseTypeArticleDataFetcher extends FirebaseDataFetcher<TypeArticle> {
  final log = Logger('FirebaseArticleDataFetcher');

  Future<int> updateTypeArticleFavoriteStatus(Article article) async {
    return 1;
  }

  Future<int> addTypeArticleInDatabase(Article article) async {
    return 1;
  }

  Future<int> removeTypeArticleFromDatabase(int articlePrimaryKey) async {
    return 1;
  }

  @override
  Future<List<TypeArticle>> constructObjectFromDatabase(listOfMaps) {
    return Future(() {
      List<TypeArticle> list = [];
      for (Map map in listOfMaps) {
        TypeArticle typeArticle = TypeArticle(
          pkTypeArticle: map['pk_TypeArticle'],
          labelTypeArticle: map['labelTypeArticle'],
          svgResource: map['svgResource'],
        );
        list.add(typeArticle);
      }
      return list;
    });
  }

  @override
  String tableName() {
    return TypeArticle.TABLE_NAME;
  }

  @override
  String labelName() {
    return TypeArticle.LABEL_NAME;
  }

  @override
  String primaryKeyName() {
    return TypeArticle.PK_NAME;
  }

  @override
  Future<int> updateData(TypeArticle t) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}
