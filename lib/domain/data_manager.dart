import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/article_data_fetcher.dart';
import 'package:inventaire_m_et_t/domain/type_article.dart';
import 'package:inventaire_m_et_t/domain/type_article_data_fetcher.dart';

import 'data_provider.dart';
import 'inventaire.dart';
import 'inventaire_data_fetcher.dart';
import 'package:logging/logging.dart';

class DataManagerService extends ChangeNotifier {

  final log = Logger('DataManagerService');

  ArticleDataFetcher _articleDataFetcher = new ArticleDataFetcher();
  TypeArticleDataFetcher _typeArticleDataFetcher = new TypeArticleDataFetcher();
  InventaireDataFetcher _inventaireDataFetcher = new InventaireDataFetcher();

  var dataProviderService = DataProviderService();

  static final DataManagerService _instance = DataManagerService._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory DataManagerService() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  DataManagerService._internal();

  Future<bool> refreshValuesFromDatabase() async {
    refreshArticleMapFromDatabase();
    List<TypeArticle> articleTypeList = await _typeArticleDataFetcher.getDataFromTable();
    for (TypeArticle typeArticle in articleTypeList) {
      dataProviderService.typeArticleMap[typeArticle.pkTypeArticle] = typeArticle;
    }
    List<Inventaire> inventaireList = await _inventaireDataFetcher.getDataFromTable();
    for (Inventaire inventaire in inventaireList) {
      // Assume that we always have the primary key when getting inventory object
      dataProviderService.inventaireMap[inventaire.pkInventaire!] = inventaire;
    }
    return true;
  }

  Future<void> refreshArticleMapFromDatabase() async {
    dataProviderService.articleMap.clear();
    List<Article> articleList = await _articleDataFetcher.getDataFromTable();
    for (Article article in articleList) {
      dataProviderService.articleMap[article.pkArticle] = article;
    }
  }

  Future<void> removeFromInventaire(int primaryKey) async {
    dataProviderService.inventaireMap.remove(primaryKey);
    return await _inventaireDataFetcher.removeDataFromTable(primaryKey);
  }

  Future<int> updateArticleFavorite(Article article) async {
    String articleName = article.labelArticle;
    if(article.estFavoris) {
      article.estFavoris = false;
    } else {
      article.estFavoris = true;
    }
    bool estFavoris = article.estFavoris;
    estFavoris = !estFavoris;
    int articleHasBeenUpdated =
      await _articleDataFetcher.updateArticleFavoriteStatus(article);
    if (articleHasBeenUpdated == 1) {
      dataProviderService.articleMap[article.pkArticle] = article;
      log.info("DataManagerService() - The favorite has been updated on the article : "
          "$articleName, set article favorite : $estFavoris");
      notifyListeners();
    } else {
      log.severe("DataManagerService() - The favorite has not been updated on the article : "
          "$articleName. Current SQL return is : $articleHasBeenUpdated");
    }
    return articleHasBeenUpdated;
  }

  Future<int> addOrRemoveFromInventaire(Article article, int quantity) async {
    int sizeInventaireMapByArticle =
    dataProviderService.getNumberOfAvailableArticleInInventory(article);
    List<Inventaire> futureResult;
    if(quantity > sizeInventaireMapByArticle) {
      futureResult = await _inventaireDataFetcher.addToTable(
          article, quantity - sizeInventaireMapByArticle);
      for(Inventaire inventaire in futureResult) {
        dataProviderService.inventaireMap[inventaire.pkInventaire!] = inventaire;
      }
    } else {
      futureResult = await _inventaireDataFetcher.removeFromTable(
          article,  sizeInventaireMapByArticle - quantity);
      for(Inventaire inventaire in futureResult) {
        dataProviderService.inventaireMap.remove(inventaire.pkInventaire);
      }
    }
    article.notifyListeners();
    return 0;
  }
}