import 'package:flutter/material.dart';
import 'package:foodstock/domain/model/article.dart';
import 'package:foodstock/service/data_provider.dart';
import 'package:foodstock/domain/model/type_article.dart';

class WidgetServiceState extends ChangeNotifier {
  static final WidgetServiceState _instance = WidgetServiceState._internal();

  Map<String, int> currentQuantityByArticle = {};

  Article? currentUpdatedArticle;

  ValueNotifier<TypeArticle?> currentSelectedTypeArticle = ValueNotifier(null);

  ValueNotifier<int> favoriteAddition = ValueNotifier(0);

  ValueNotifier<int> triggerListUpdate = ValueNotifier(0);

  ValueNotifier<bool> isSearchModeActivated = ValueNotifier(false);

  ValueNotifier<String> currentResearchContent = ValueNotifier("");

  factory WidgetServiceState() {
    return _instance;
  }

  incrementFavoriteTriggeredCount() {
    favoriteAddition.value++;
  }

  WidgetServiceState._internal();
}
