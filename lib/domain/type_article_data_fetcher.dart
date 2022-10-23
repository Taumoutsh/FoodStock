import 'dart:async';
import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/data_fetcher.dart';
import 'package:sqflite/sqflite.dart';
import 'type_article.dart';
import '../database/database.dart';
import 'mapped_object.dart';

class TypeArticleDataFetcher extends DataFetcher<TypeArticle> {

  @override
  Future<List<TypeArticle>> constructObjectFromDatabase(map) {
    return Future(() => List.generate(map.length, (i) {
      return TypeArticle(
          pkTypeArticle: map[i]['pk_TypeArticle'],
          labelTypeArticle: map[i]['labelTypeArticle']
      );
    }));
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
}