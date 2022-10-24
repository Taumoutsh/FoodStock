import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/article_data_fetcher.dart';
import 'package:inventaire_m_et_t/domain/type_article.dart';
import 'package:inventaire_m_et_t/domain/type_article_data_fetcher.dart';

import 'inventaire.dart';
import 'inventaire_data_fetcher.dart';

class DataProviderService {

  ArticleDataFetcher _articleDataFetcher = new ArticleDataFetcher();

  TypeArticleDataFetcher _typeArticleDataFetcher = new TypeArticleDataFetcher();

  InventaireDataFetcher _inventaireDataFetcher = new InventaireDataFetcher();

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

  Future<bool> refreshValuesFromDatabase() async {
    List<Article> articleList = await _articleDataFetcher.getDataFromTable();
      for (Article article in articleList) {
          articleMap[article.pkArticle] = article;
      }
    List<TypeArticle> articleTypeList = await _typeArticleDataFetcher.getDataFromTable();
    for (TypeArticle typeArticle in articleTypeList) {
      typeArticleMap[typeArticle.pkTypeArticle] = typeArticle;
    }
    List<Inventaire> inventaireList = await _inventaireDataFetcher.getDataFromTable();
    for (Inventaire inventaire in inventaireList) {
      // Assume that we always have the primary key when getting inventory object
      inventaireMap[inventaire.pkInventaire!] = inventaire;
    }
    return true;
  }

  Future<void> removeFromInventaire(int primaryKey) async {
    this.inventaireMap.remove(primaryKey);
    return await _inventaireDataFetcher.removeDataFromTable(primaryKey);
  }

  Future<void> addOrRemoveFromInventaire(Article article, int quantity) async {
    int sizeInventaireMapByArticle = getNumberOfAvailableArticleInInventory(article);
    if(quantity > sizeInventaireMapByArticle) {
      return await _inventaireDataFetcher.addToTable(
          article, quantity - sizeInventaireMapByArticle);
    } else {
      return await _inventaireDataFetcher.removeFromTable(
          article,  sizeInventaireMapByArticle - quantity);
    }
  }


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