import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';
import 'package:inventaire_m_et_t/domain/inventaire_data_fetcher.dart';

import '../domain/type_article.dart';

class InventaireService {

  static final InventaireService _instance = InventaireService._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory InventaireService() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  InventaireService._internal() {
  }

  getNumberOrArticleByArticle(Article article) {
    return inventaireDataFetcher.
  }



}