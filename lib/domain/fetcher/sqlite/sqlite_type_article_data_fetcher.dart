import 'dart:async';
import 'package:foodstock/domain/fetcher/sqlite/sqlite_data_fetcher.dart';
import '../../model/type_article.dart';

class SqliteTypeArticleDataFetcher extends SqliteDataFetcher<TypeArticle> {

  @override
  Future<List<TypeArticle>> constructObjectFromDatabase(map) {
    return Future(() => List.generate(map.length, (i) {
      return TypeArticle(
          pkTypeArticle: map[i]['pk_TypeArticle'],
          labelTypeArticle: map[i]['labelTypeArticle'],
          svgResource: map[i]['svgResource'],
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

  @override
  Future<int> updateData(TypeArticle t) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}