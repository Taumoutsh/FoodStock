import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:foodstock/domain/fetcher/interfaces/inventaire_special_queries.dart';
import 'package:foodstock/domain/model/article.dart';
import 'package:foodstock/domain/model/enumerate/item_event_type.dart';
import 'package:foodstock/domain/model/type_article.dart';
import 'package:foodstock/service/widget_service_state.dart';

import '../database/firebase_provider.dart';
import '../domain/fetcher/data_fetcher.dart';
import '../domain/model/enumerate/database_source.dart';
import 'application_start_service.dart';
import 'data_provider.dart';
import '../domain/fetcher/firebase/firebase_article_data_fetcher.dart';
import '../domain/fetcher/firebase/firebase_inventaire_data_fetcher.dart';
import '../domain/fetcher/firebase/firebase_type_article_data_fetcher.dart';
import '../domain/fetcher/sqlite/sqlite_article_data_fetcher.dart';
import '../domain/fetcher/sqlite/sqlite_type_article_data_fetcher.dart';
import '../domain/model/inventaire.dart';
import '../domain/fetcher/sqlite/sqlite_inventaire_data_fetcher.dart';
import 'package:logging/logging.dart';

class DataManagerService extends ChangeNotifier {
  final log = Logger('DataManagerService');

  late DataFetcher<Article> _articleDataFetcher;
  late DataFetcher<TypeArticle> _typeArticleDataFetcher;
  late DataFetcher<Inventaire> _inventaireDataFetcher;
  late DatabaseSource databaseSource;
  ValueNotifier<int> loadingPercent = ValueNotifier(0);

  var dataProviderService = DataProviderService();

  var firebaseProvider = FirebaseProvider();

  var widgetServiceState = WidgetServiceState();

  ApplicationStartMonitor applicationStartService = ApplicationStartMonitor();

  static final DataManagerService _instance = DataManagerService._internal();

  factory DataManagerService() {
    return _instance;
  }

  DataManagerService._internal();

  Future<void> _initializeDataFetchersSource(
      DatabaseSource databaseSource) async {
    this.databaseSource = databaseSource;
    if (databaseSource == DatabaseSource.FIREBASE_DATABASE) {
      await firebaseProvider.initialiseFirebaseDatabase();
      _articleDataFetcher = FirebaseArticleDataFetcher();
      _typeArticleDataFetcher = FirebaseTypeArticleDataFetcher();
      _inventaireDataFetcher = FirebaseInventaireDataFetcher();
      _subscribeToDataUpdates();
    } else if (databaseSource == DatabaseSource.SQLITE_DATABASE) {
      _articleDataFetcher = SqliteArticleDataFetcher();
      _typeArticleDataFetcher = SqliteTypeArticleDataFetcher();
      _inventaireDataFetcher = SqliteInventaireDataFetcher();
    }
  }

  _subscribeToDataUpdates() {
    (_articleDataFetcher as FirebaseArticleDataFetcher)
        .dataComingFromDatabaseProperty
        .listen((value) {
      if (applicationStartService.isInitialRefreshComplete) {
        if (ItemEventType.UPDATED == value.itemEventType) {
          for (var itemToUpdate in value.itemsToUpdate) {
            Article updatedArticle = itemToUpdate;
            dataProviderService.articleMap[updatedArticle.pkArticle!] =
                updatedArticle;
          }
        } else if (ItemEventType.ADDED == value.itemEventType) {
          for (var itemToUpdate in value.itemsToUpdate) {
            Article newArticle = itemToUpdate;
            dataProviderService.articleMap[newArticle.pkArticle!] = newArticle;
            dataProviderService.addDefaultConservationDataByArticle(newArticle);
            dataProviderService.addDefaultArticleCountByArticle(newArticle);
          }
        } else if (ItemEventType.REMOVED == value.itemEventType) {
          for (var itemToUpdate in value.itemsToUpdate) {
            Article removedArticle = itemToUpdate;
            dataProviderService.articleMap.remove(removedArticle.pkArticle);
          }
        }
        widgetServiceState.triggerListUpdate.value++;
      } else {
        log.info("_subscribeToDataUpdates() - L'initialisation "
            "n'est pas complète, les écoutes sont ignorées");
      }
    });

    (_inventaireDataFetcher as FirebaseInventaireDataFetcher)
        .dataComingFromDatabaseProperty
        .listen((value) {
      if (applicationStartService.isInitialRefreshComplete) {
        var inventorsArticle = value.itemsToUpdate.first.article;
        if (ItemEventType.REMOVED == value.itemEventType) {
          for (var itemToUpdate in value.itemsToUpdate) {
            dataProviderService.inventaireMap.remove(itemToUpdate.pkInventaire);
            dataProviderService.updateConservationDataByArticle(
                inventorsArticle, false);
          }
        } else if (ItemEventType.ADDED == value.itemEventType) {
          for (var itemToUpdate in value.itemsToUpdate) {
            dataProviderService.inventaireMap[itemToUpdate.pkInventaire!] =
                itemToUpdate;
            dataProviderService.updateConservationDataByArticle(
                inventorsArticle, true);
          }
        }
        dataProviderService
            .updateAvailableArticlesCountByArticle(inventorsArticle);
        widgetServiceState
                .currentQuantityByArticle[inventorsArticle.pkArticle!] =
            dataProviderService
                .availableArticlesCount[inventorsArticle.pkArticle]!.value;
        widgetServiceState.triggerListUpdate.value++;
      } else {
        log.info(
            "_subscribeToDataUpdates() - L'initialisation n'est pas complète,"
            " les écoutes sont ignorées");
      }
    });
  }

  Future<bool> refreshValuesFromDatabase(DatabaseSource databaseSource) async {
    loadingPercent.value = 5;
    await _initializeDataFetchersSource(databaseSource);
    List articleTypeList = await _typeArticleDataFetcher.getAllData();
    for (TypeArticle typeArticle in articleTypeList) {
      dataProviderService.typeArticleMap[typeArticle.pkTypeArticle] =
          typeArticle;
    }
    loadingPercent.value = 20;
    await refreshArticleMapFromDatabase();
    loadingPercent.value = 60;
    List inventaireList = await _inventaireDataFetcher.getDataFromTableOrderBy(
        _inventaireDataFetcher.labelName(), true);
    loadingPercent.value = 100;
    for (Inventaire inventaire in inventaireList) {
      // Assume that we always have the primary key when getting inventory object
      dataProviderService.inventaireMap[inventaire.pkInventaire!] = inventaire;
    }
    dataProviderService.updateAvailableAllArticlesCount();
    dataProviderService.addConservationDataAllArticle();
    applicationStartService.isInitialRefreshComplete = true;
    return applicationStartService.isInitialRefreshComplete;
  }

  Future<void> refreshArticleMapFromDatabase() async {
    List articleList = await _articleDataFetcher.getAllData();
    for (Article article in articleList) {
      dataProviderService.articleMap[article.pkArticle!] = article;
    }
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
    int articleHasBeenUpdated = await _articleDataFetcher.updateData(article);
    if (articleHasBeenUpdated == 1) {
      dataProviderService.articleMap[article.pkArticle!] = article;
      log.info(
          "DataManagerService() - La variable de favoris a été mise à jour pour l'article : "
          "$articleName, est favoris : $estFavoris");
      notifyListeners();
    } else {
      log.severe(
          "DataManagerService() - La variable de favoris n'a pas été mise à jour pour l'article : "
          "$articleName. Retour SQL : $articleHasBeenUpdated");
    }
    return articleHasBeenUpdated;
  }

  Future<bool> addOrRemoveFromInventaire(Article article, int quantity) async {
    // Récupération du nombre d'article dans l'inventaire
    bool inventoryHasChanged =
        false; // Boolean utilisé pour recharger la liste en cas d'ajout d'article dans l'inventaire
    int sizeInventaireMapByArticle =
        dataProviderService.getNumberOfAvailableArticleInInventory(article);
    List<Inventaire> futureResult;
    Inventaire? singleInventaire;
    // Si la quantité saisie dans le widget est supérieure à celle du modèle,
    // ajouter des produits dans la base de données
    // Sinon, en supprimer
    if (quantity > sizeInventaireMapByArticle) {
      futureResult = await (_inventaireDataFetcher as InventaireSpecialQueries)
          .addInventoryItems(article, quantity - sizeInventaireMapByArticle);
      if (futureResult != null && futureResult.isNotEmpty) {
        inventoryHasChanged = true;
      }
      if (DatabaseSource.SQLITE_DATABASE == databaseSource) {
        for (Inventaire inventaire in futureResult) {
          dataProviderService.inventaireMap[inventaire.pkInventaire!] =
              inventaire;
        }
        dataProviderService.updateConservationDataByArticle(article, true);
      }
    } else {
      var numberToRemove = sizeInventaireMapByArticle - quantity;
      singleInventaire =
          await (_inventaireDataFetcher as InventaireSpecialQueries)
              .removeInventoryItemWhereArticle(article, numberToRemove);
      if (singleInventaire != null) {
        if (!inventoryHasChanged) {
          inventoryHasChanged = true;
        }
        if (DatabaseSource.SQLITE_DATABASE == databaseSource) {
          dataProviderService.inventaireMap
              .remove(singleInventaire.pkInventaire);
        }
      }
      if (DatabaseSource.SQLITE_DATABASE == databaseSource) {
        dataProviderService.updateConservationDataByArticle(article, false);
      }
    }
    if (DatabaseSource.SQLITE_DATABASE == databaseSource) {
      dataProviderService.updateAvailableArticlesCountByArticle(article);
    }
    return inventoryHasChanged;
  }

  Future<bool> addNewArticle(String articleName, int articlePeremption,
      int alerteLevel, int criticalLevel, TypeArticle articleType) async {
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
    String articleCreationState = await _articleDataFetcher.addData(article);
    if (articleCreationState.toString() != "0") {
      log.info("addNewArticle() - L'article avec la clé primaire "
          "$articleCreationState a été ajouté avec succès"
          " à la base de données");
      if (DatabaseSource.SQLITE_DATABASE == databaseSource) {
        article.pkArticle = articleCreationState.toString();
        dataProviderService.articleMap[article.pkArticle!] = article;
        dataProviderService.addDefaultConservationDataByArticle(article);
        dataProviderService.addDefaultArticleCountByArticle(article);
      }
      isArticleAddedToDatabase = true;
    } else {
      isArticleAddedToDatabase = false;
      log.severe("addNewArticle() - L'article avec le label "
          "$articleName n'a pas pu être ajouté dans la base de "
          "données et dans le modèle");
    }
    return isArticleAddedToDatabase;
  }

  Future<bool> updateArticle(
      Article oldArticle,
      String articleName,
      int articlePeremption,
      int alerteLevel,
      int criticalLevel,
      TypeArticle articleType) async {
    bool articleHasBeenUpdated = false;
    Article updatedArticle = Article(
        labelArticle: articleName,
        peremptionEnJours: articlePeremption,
        quantiteAlerte: alerteLevel,
        quantiteCritique: criticalLevel,
        estFavoris: oldArticle.estFavoris,
        typeArticle: articleType);
    updatedArticle.pkArticle = oldArticle.pkArticle;
    updatedArticle.articleReference = oldArticle.articleReference;
    int articleUpdatedCount =
        await _articleDataFetcher.updateData(updatedArticle);
    if (DatabaseSource.SQLITE_DATABASE == databaseSource) {
      if (articleUpdatedCount > 0) {
        articleHasBeenUpdated = true;
        dataProviderService.articleMap[updatedArticle.pkArticle!] =
            updatedArticle;
        log.info("updateArticle() - L'article avec la clé primaire "
            "$updatedArticle a été modifié avec succès"
            " à la base de données");
      } else {
        log.severe("updateArticle() - L'article avec le label "
            "$updatedArticle n'a pas pu être modifié dans la base de "
            "données et dans le modèle");
      }
    }
    return articleHasBeenUpdated;
  }

  Future<bool> removeArticle(Article article) async {
    log.info("removeArticle() - Suppression de l'article <$article>");
    String articleKey = article.pkArticle!;
    bool articleRemovalSucceeded = false;
    int inventoryResponse =
        await (_inventaireDataFetcher as InventaireSpecialQueries)
            .removeInventoryItemFromTableWhereArticle(article);
    log.info(
        "removeArticle() - Nombre d'items inventaire supprimés en base de données associés"
        " à l'article <$article> : $inventoryResponse");
    if (DatabaseSource.SQLITE_DATABASE == databaseSource) {
      if (inventoryResponse > 0) {
        List<String> inventoryKeyToRemove = [];
        for (Inventaire inventaire
            in dataProviderService.inventaireMap.values) {
          if (inventaire.article.pkArticle == articleKey) {
            inventoryKeyToRemove.add(inventaire.pkInventaire!);
          }
        }
        for (String inventoryPrimaryKey in inventoryKeyToRemove) {
          log.info(
              "removeArticle() - Suppression dans le modèle de l'item inventaire"
              " <$inventoryPrimaryKey>");
          dataProviderService.inventaireMap.remove(inventoryPrimaryKey);
        }
      }
    }
    int articleResponse = await _articleDataFetcher.removeData(articleKey);
    if (articleResponse > 0) {
      log.info("removeArticle() - Suppression de l'article <$article> réussie"
          " nombre d'item d'inventaire supprimés : $inventoryResponse");
      if (DatabaseSource.SQLITE_DATABASE == databaseSource) {
        dataProviderService.articleMap.remove(articleKey);
      }
      articleRemovalSucceeded = true;
    } else {
      log.severe(
          "removeArticle() - échec lors de la suppression de l'article <$article>");
    }
    return articleRemovalSucceeded;
  }
}
