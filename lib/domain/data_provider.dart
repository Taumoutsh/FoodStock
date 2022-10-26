import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/type_article.dart';

import 'inventaire.dart';

class DataProviderService {

  Map<int, Article> articleMap = new Map();
  Map<int, TypeArticle> typeArticleMap = new Map();
  Map<int, Inventaire> inventaireMap= new Map();

  static final DataProviderService _instance = DataProviderService._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory DataProviderService() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  DataProviderService._internal();

  int getNumberOfAvailableArticleInInventory(Article article) {
    int nbOfAvailableArticle = 0;
    for (Inventaire inventaire in inventaireMap.values) {
      if (inventaire.article.pkArticle == article.pkArticle) {
        nbOfAvailableArticle++;
      }
    }
    return nbOfAvailableArticle;
  }


}