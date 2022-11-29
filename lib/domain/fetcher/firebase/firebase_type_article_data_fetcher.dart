import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import '../../model/type_article.dart';
import 'firebase_data_fetcher.dart';

class FirebaseTypeArticleDataFetcher extends FirebaseDataFetcher<TypeArticle> {
  final log = Logger('FirebaseTypeArticleDataFetcher');

  Future<TypeArticle> constructSingleObjectFromDatabase(map) async {
    var typeArticleToAdd = TypeArticle(
        pkTypeArticle: map['pk_TypeArticle'],
        labelTypeArticle: map['labelTypeArticle'],
        svgResource: map['svgResource']);
    typeArticleToAdd.typeArticleReference =
        map[TypeArticle.REFERENCE_LABEL];
    return typeArticleToAdd;
  }

  @override
  Future<List<TypeArticle>> constructObjectsFromDatabase(listOfMaps) async {
    List<TypeArticle> typeArticleToReturn = [];
    for (Map<String, dynamic> mapEntry in listOfMaps) {
      TypeArticle typeArticleToAdd =
          await constructSingleObjectFromDatabase(mapEntry);
      typeArticleToReturn.add(typeArticleToAdd);
    }
    return Future(() => typeArticleToReturn);
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
