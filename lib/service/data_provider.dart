import 'package:flutter/foundation.dart';
import 'package:foodstock/domain/model/conservation_data.dart';
import 'package:foodstock/domain/model/article.dart';
import 'package:foodstock/domain/model/type_article.dart';

import '../domain/model/inventaire.dart';
import 'application_start_service.dart';

class DataProviderService {

  ApplicationStartMonitor applicationStartService = ApplicationStartMonitor();

  Map<String, Article> articleMap = {};
  Map<String, TypeArticle> typeArticleMap = {};
  Map<String, Inventaire> inventaireMap = {};
  Map<String, ValueNotifier<int>> availableArticlesCount = {};
  Map<String, ValueNotifier<ConservationData>> conservationDataByArticle = {};

  static final DataProviderService _instance = DataProviderService._internal();

  factory DataProviderService() {
    return _instance;
  }

  DataProviderService._internal();

  int getNumberOfAvailableArticleInInventory(Article article) {
    int articleCountToReturn = 0;
    int? actualCount = availableArticlesCount[article.pkArticle]!.value;
    if (actualCount != null) {
      articleCountToReturn = actualCount;
    }
    return articleCountToReturn;
  }

  Future<Inventaire> getOlderInventoryItemByArticle(Article article) async {
    Inventaire inventoryItem = inventaireMap.values.last;
    for (Inventaire inventory in inventaireMap.values) {
      if(inventory.article == article) {
        if(inventory.dateAchatArticleDateTime
            .isBefore(inventoryItem.dateAchatArticleDateTime)) {
          inventoryItem = inventory;
        }
      }
    }
    return inventoryItem;
  }

  void addConservationDataAllArticle() {
    conservationDataByArticle.clear();
    for (Inventaire inventaireItem in inventaireMap.values) {
      if (conservationDataByArticle[inventaireItem.article.pkArticle] == null) {
        _addConservationDataByInventaireItem(inventaireItem);
      }
    }
    for (Article article in articleMap.values) {
      if (conservationDataByArticle[article.pkArticle] == null) {
        conservationDataByArticle[article.pkArticle!] = ValueNotifier(
            ConservationData(olderArticleDateTime: DateTime.now(),
                nominalConservationDays: 0, currentConservationDays: 0));
      }
    }
  }

  void addDefaultArticleCountByArticle(Article article) {
    availableArticlesCount[article.pkArticle!] = ValueNotifier(0);
  }

  void addDefaultConservationDataByArticle(Article article) {
    conservationDataByArticle[article.pkArticle!] = ValueNotifier(
        ConservationData(
            olderArticleDateTime: DateTime.now(),
            nominalConservationDays: 0,
            currentConservationDays: 0));
  }

  void _addConservationDataByInventaireItem(Inventaire inventaireItem) {
    DateTime now = DateTime.now();
    DateTime purchaseDateTime = DateTime.parse(inventaireItem.dateAchatArticle);
    int dayDifferenceSincePurchase = now.difference(purchaseDateTime).inDays;
    ConservationData conservationData = ConservationData(
        olderArticleDateTime: DateTime.parse(inventaireItem.dateAchatArticle),
        nominalConservationDays: inventaireItem.article.peremptionEnJours,
        currentConservationDays: dayDifferenceSincePurchase);
    conservationDataByArticle[inventaireItem.article.pkArticle!] =
        ValueNotifier(conservationData);
  }

  void updateConservationDataByArticle(Article article, bool isAdded) {
    bool isInInventory = false;
    for (Inventaire inventaireItem in inventaireMap.values) {
      if (inventaireItem.article.pkArticle == article.pkArticle) {
        isInInventory = true;
        _updateConservationDataByInventaireItemIfOlder(inventaireItem, isAdded);
        break;
      }
    }
    if (!isInInventory) {
      conservationDataByArticle[article.pkArticle]!.value = ConservationData(
          olderArticleDateTime: DateTime.now(),
          nominalConservationDays: 0,
          currentConservationDays: 0);
    }
  }

  void updateAvailableAllArticlesCount() {
    for (Article article in articleMap.values) {
      int nbOfAvailableArticle = 0;
      for (Inventaire inventaireItem in inventaireMap.values) {
        if (inventaireItem.article.pkArticle == article.pkArticle) {
          nbOfAvailableArticle++;
        }
      }
      ValueNotifier<int>? countListenable =
          availableArticlesCount[article.pkArticle];
      if (countListenable != null) {
        countListenable.value = nbOfAvailableArticle;
      } else {
        availableArticlesCount[article.pkArticle!] =
            ValueNotifier<int>(nbOfAvailableArticle);
      }
    }
  }

  void updateAvailableArticlesCountByArticle(Article article) {
    int nbOfAvailableArticle = 0;
    for (Inventaire inventaireItem in inventaireMap.values) {
      if (inventaireItem.article.pkArticle == article.pkArticle) {
        nbOfAvailableArticle++;
      }
    }
    availableArticlesCount[article.pkArticle]!.value = nbOfAvailableArticle;
  }

  void _updateConservationDataByInventaireItemIfOlder(
      Inventaire inventaireItem, bool isAdded) {
    ConservationData conservationData =
        conservationDataByArticle[inventaireItem.article.pkArticle]!.value;
    DateTime now = DateTime.now();
    DateTime newPurchasedDateTime = DateTime.parse(inventaireItem.dateAchatArticle);
    int dayDifferenceSincePurchase = now.difference(newPurchasedDateTime).inDays;
    int nominalConservationDays = inventaireItem.article.peremptionEnJours;
    int currentConservationDays = dayDifferenceSincePurchase;
    bool dateConstraint;
    if(isAdded) {
      dateConstraint = conservationData.isReallyNotInInventory() ||
          conservationData.olderArticleDateTime.isAfter(newPurchasedDateTime);
    } else {
      dateConstraint =
          conservationData.olderArticleDateTime.isBefore(newPurchasedDateTime);
    }

    if(dateConstraint) {
      conservationDataByArticle[inventaireItem.article.pkArticle]!.value =
          ConservationData(
              olderArticleDateTime:
              DateTime.parse(inventaireItem.dateAchatArticle),
              nominalConservationDays: nominalConservationDays,
              currentConservationDays: currentConservationDays);
    }
  }
}
