import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:foodstock/domain/article.dart';
import 'package:foodstock/domain/article_data_fetcher.dart';
import 'package:foodstock/domain/type_article.dart';
import 'package:foodstock/domain/type_article_data_fetcher.dart';

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

  factory DataManagerService() {
    return _instance;
  }

  DataManagerService._internal();

  Future<bool> refreshValuesFromDatabase() async {
    refreshArticleMapFromDatabase();
    List<TypeArticle> articleTypeList =
        await _typeArticleDataFetcher.getDataFromTable();
    for (TypeArticle typeArticle in articleTypeList) {
      dataProviderService.typeArticleMap[typeArticle.pkTypeArticle] =
          typeArticle;
    }
    List<Inventaire> inventaireList = await _inventaireDataFetcher
        .getDataFromTableOrderBy(_inventaireDataFetcher.labelName(), true);
    for (Inventaire inventaire in inventaireList) {
      // Assume that we always have the primary key when getting inventory object
      dataProviderService.inventaireMap[inventaire.pkInventaire!] = inventaire;
    }
    dataProviderService.updateAvailableAllArticlesCount();
    dataProviderService.addConservationDataAllArticle();
    return true;
  }

  Future<void> refreshArticleMapFromDatabase() async {
    List<Article> articleList = await _articleDataFetcher.getDataFromTable();
    for (Article article in articleList) {
      dataProviderService.articleMap[article.pkArticle!] = article;
    }
  }

  Future<void> removeFromInventaire(int primaryKey) async {
    dataProviderService.inventaireMap.remove(primaryKey);
    return await _inventaireDataFetcher.removeDataFromTable(primaryKey);
  }

  Future<int> updateArticleFavorite(Article article) async {
    String articleName = article.labelArticle;
    if (article.estFavoris) {
      article.estFavoris = false;
    } else {
      article.estFavoris = true;
    }
    bool estFavoris = article.estFavoris;
    estFavoris = !estFavoris;
    int articleHasBeenUpdated =
        await _articleDataFetcher.updateArticleFavoriteStatus(article);
    if (articleHasBeenUpdated == 1) {
      dataProviderService.articleMap[article.pkArticle!] = article;
      log.info(
          "DataManagerService() - The favorite has been updated on the article : "
          "$articleName, set article favorite : $estFavoris");
      notifyListeners();
    } else {
      log.severe(
          "DataManagerService() - The favorite has not been updated on the article : "
          "$articleName. Current SQL return is : $articleHasBeenUpdated");
    }
    return articleHasBeenUpdated;
  }

  Future<int> addOrRemoveFromInventaire(Article article, int quantity) async {
    // Récupération du nombre d'article dans l'inventaire
    int sizeInventaireMapByArticle =
        dataProviderService.getNumberOfAvailableArticleInInventory(article);
    List<Inventaire> futureResult;
    // Si la quantité saisie dans le widget est supérieure à celle du modèle,
    // ajouter des produits dans la base de données
    // Sinon, en supprimer
    if (quantity > sizeInventaireMapByArticle) {
      futureResult = await _inventaireDataFetcher.addToTable(
          article, quantity - sizeInventaireMapByArticle);
      for (Inventaire inventaire in futureResult) {
        dataProviderService.inventaireMap[inventaire.pkInventaire!] =
            inventaire;
      }
      dataProviderService.updateConservationDataByArticle(article, true);
    } else {
      futureResult = await _inventaireDataFetcher.removeFromTable(
          article, sizeInventaireMapByArticle - quantity);
      for (Inventaire inventaire in futureResult) {
        dataProviderService.inventaireMap.remove(inventaire.pkInventaire);
      }
      dataProviderService.updateConservationDataByArticle(article, false);
    }
    dataProviderService.updateAvailableArticlesCountByArticle(article);
    return 0;
  }

  Future<bool> addNewArticle(String articleName, int articlePeremption, int alerteLevel,
      int criticalLevel, TypeArticle articleType) async {
    bool isArticleAddedToDatabase;
    log.info("addNewArticle() - Processus d'ajout de l'article $articleName, "
        "peremption : $articlePeremption de type $articleType, "
        "level d'alerte : $alerteLevel, level critique : $criticalLevel");
    Article article = Article(
        labelArticle: articleName,
        peremptionEnJours: articlePeremption,
        quantiteAlerte: alerteLevel,
        quantiteCritique: criticalLevel,
        estFavoris: false,
        typeArticle: articleType);
    int articleCreationState =
        await _articleDataFetcher.addArticleInDatabase(article);
    if (articleCreationState != 0) {
      log.info("addNewArticle() - L'article avec la clé primaire "
          "$articleCreationState a été ajouté avec succès"
          " à la base de données");
      article.pkArticle = articleCreationState;
      dataProviderService.articleMap[article.pkArticle!] = article;
      dataProviderService.addDefaultConservationDataByArticle(article);
      dataProviderService.addDefaultArticleCountByArticle(article);
      isArticleAddedToDatabase = true;
    } else {
      isArticleAddedToDatabase = false;
      log.severe("addNewArticle() - L'article avec le label "
          "$articleName n'a pas pu être ajouté dans la base de "
          "données et dans le modèle");
    }
    return isArticleAddedToDatabase;
  }

  Future<bool> removeArticle(Article article) async {
    log.info("removeArticle() - Suppression de l'article <$article>");
    int articleKey = article.pkArticle!;
    bool articleRemovalSucceeded = false;
    int inventoryResponse = await _inventaireDataFetcher.removeAllArticleFromTable(articleKey);
    log.info("removeArticle() - Nombre d'items inventaire supprimés en base de données associés"
        " à l'article <$article> : $inventoryResponse");
    if(inventoryResponse > 0) {
      List<int> inventoryKeyToRemove = [];
      for(Inventaire inventaire in dataProviderService.inventaireMap.values) {
        if(inventaire.article.pkArticle == articleKey) {
          inventoryKeyToRemove.add(inventaire.pkInventaire!);
        }
      }
      for(int inventoryPrimaryKey in inventoryKeyToRemove) {
        log.info("removeArticle() - Suppression dans le modèle de l'item inventaire"
            " <$inventoryPrimaryKey>");
        dataProviderService.inventaireMap.remove(inventoryPrimaryKey);
      }
    }
    int articleResponse =
    await _articleDataFetcher.removeArticleFromDatabase(articleKey);
    if(articleResponse > 0) {
      log.info("removeArticle() - Suppression de l'article <$article> réussie"
          " à l'article <$article> : $inventoryResponse");
      dataProviderService.articleMap.remove(articleKey);
      articleRemovalSucceeded = true;
    } else {
      log.severe("removeArticle() - Echec lors de la suppression de l'article <$article>");
    }
    return articleRemovalSucceeded;
  }
}
