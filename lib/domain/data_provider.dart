import 'package:flutter/foundation.dart';
import 'package:inventaire_m_et_t/domain/conservation_data.dart';
import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/type_article.dart';

import 'inventaire.dart';

class DataProviderService {
  Map<int, Article> articleMap = new Map();
  Map<int, TypeArticle> typeArticleMap = new Map();
  Map<int, Inventaire> inventaireMap = new Map();
  Map<int, ValueNotifier<int>> availableArticlesCount = new Map();
  Map<int, ValueNotifier<ConservationData>> conservationDataByArticle =
      new Map();

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
    int articleCountToReturn = 0;
    int? actualCount = availableArticlesCount[article.pkArticle]!.value;
    if (actualCount != null) {
      articleCountToReturn = actualCount;
    }
    return articleCountToReturn;
  }

  void addConservationDataAllArticle() {
    conservationDataByArticle.clear();
    for (Inventaire inventaireItem in inventaireMap.values) {
      if (conservationDataByArticle[inventaireItem.article.pkArticle] == null) {
        _addConversationDataByInventaireItem(inventaireItem);
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

  void _addConversationDataByInventaireItem(Inventaire inventaireItem) {
    DateTime now = DateTime.now();
    DateTime purchaseDateTime = DateTime.parse(inventaireItem.dateAchatArticle);
    int dayDifferenceSincePurchase = now.difference(purchaseDateTime).inDays;
    ConservationData conservationData = ConservationData(
        olderArticleDateTime: DateTime.parse(inventaireItem.dateAchatArticle),
        nominalConservationDays: inventaireItem.article.peremptionEnJours,
        currentConservationDays: dayDifferenceSincePurchase);
    conservationDataByArticle[inventaireItem.article.pkArticle!] =
        new ValueNotifier(conservationData);
  }

  void updateConservationDataByArticle(Article article, bool isAdded) {
    bool isInInventory = false;
    for (Inventaire inventaireItem in inventaireMap.values) {
      if (inventaireItem.article.pkArticle == article.pkArticle) {
        isInInventory = true;
        _updateConversationDataByInventaireItemIfOlder(inventaireItem, isAdded);
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


  void _updateConversationDataByInventaireItemIfOlder(
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
            new ValueNotifier<int>(nbOfAvailableArticle);
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

  get firstTypeArticleValueInMap {
    return typeArticleMap.values.first;
  }
}
