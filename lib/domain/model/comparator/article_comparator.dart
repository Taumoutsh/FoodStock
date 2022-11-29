import 'dart:core';

import '../../../service/data_provider.dart';
import '../article.dart';

///
/// Le comparateur compare les articles en fonction de leur :
///
/// - L'aspect de favoris (article favoris en premier puis les autres ensuite)
/// - Le nombre d'article (du plus petit au plus grand)
/// - La quantité critique de chaque article :
///      > plus un article possède une quantité critique élevée,
///        plus il sera classé haut dans la liste
/// - La quantité d'alerte de chaque article :
///      > plus un article possède une quantité critique élevée,
///        plus il sera classé haut dans la liste
///
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
          if(a.quantiteCritique > b.quantiteCritique) {
            return -1;
          } else if (a.quantiteCritique < b.quantiteCritique) {
            return 1;
          } else {
            if(a.quantiteAlerte > b.quantiteAlerte) {
              return -1;
            } else if (a.quantiteAlerte < b.quantiteAlerte) {
              return 1;
            } else {
              return 0;
            }
          }
        }
      } else {
        return 0;
      }
    }
  }
}
