import 'dart:async';
import 'package:logging/logging.dart';
import '../../model/type_article.dart';
import 'firebase_data_fetcher.dart';

class FirebaseTypeArticleDataFetcher extends FirebaseDataFetcher<TypeArticle> {
  final log = Logger('FirebaseTypeArticleDataFetcher');

  @override
  Future<List<TypeArticle>> constructObjectFromDatabase(listOfMaps) {
    return Future(() {
      List<TypeArticle> list = [];
      for (Map mapEntry in listOfMaps) {
        var typeArticleToAdd = TypeArticle(
          pkTypeArticle: mapEntry['pk_TypeArticle'],
          labelTypeArticle: mapEntry['labelTypeArticle'],
          svgResource: mapEntry['svgResource'],
        );
        typeArticleToAdd.typeArticleReference =
            mapEntry[TypeArticle.REFERENCE_LABEL];

        list.add(typeArticleToAdd);
      }
      return list;
    });
  }

  @override
  Future<int> updateData(TypeArticle t) {
    // TODO: implement updateData
    throw UnimplementedError();
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
  String getReferenceLabel() {
    return TypeArticle.REFERENCE_LABEL;
  }

  @override
  Future<String> addData(TypeArticle t) {
    // TODO: implement addData
    throw UnimplementedError();
  }
}
