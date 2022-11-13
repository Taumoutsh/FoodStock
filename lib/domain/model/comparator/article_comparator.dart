import 'dart:core';

import '../../../service/data_provider.dart';
import '../article.dart';

class ArticleComparator {
  DataProviderService dataProviderService = DataProviderService();

  int compareTwoArticle(Article a, Article b) {
    if (a.estFavoris && !b.estFavoris) {
      return -1;
    } else if (!a.estFavoris && b.estFavoris) {
      return 1;
    } else {
      var countArticleA =
          dataProviderService.availableArticlesCount[a.pkArticle!];
      var countArticleB =
          dataProviderService.availableArticlesCount[b.pkArticle!];
      if (countArticleA != null && countArticleB != null) {
        if(countArticleA.value == 0) {
          return 1;
        } else if (countArticleB.value == 0) {
          return -1;
        } else if (countArticleA.value < countArticleB.value) {
          return -1;
        } else if (countArticleA.value > countArticleB.value) {
          return 1;
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    }
  }
}
