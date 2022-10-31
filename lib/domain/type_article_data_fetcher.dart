import 'dart:async';
import 'package:foodstock/domain/data_fetcher.dart';
import 'type_article.dart';

class TypeArticleDataFetcher extends DataFetcher<TypeArticle> {

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
}