import 'package:flutter/material.dart';
import 'package:foodstock/domain/article.dart';
import 'package:foodstock/domain/data_provider.dart';
import 'package:foodstock/domain/type_article.dart';


class WidgetServiceState extends ChangeNotifier {

  static final DataProviderService dataProviderService = DataProviderService();

  static final WidgetServiceState _instance = WidgetServiceState._internal();

  Map<int, int> currentQuantityByArticle = {};

  Article? currentUpdatedArticle;

  ValueNotifier<TypeArticle?> currentSelectedTypeArticle = ValueNotifier(null);

  ValueNotifier<int> favoriteAddition = ValueNotifier(0);

  ValueNotifier<int> triggerListUpdate = ValueNotifier(0);

  factory WidgetServiceState() {
    return _instance;
  }

  incrementFavoriteTriggeredCount() {
    favoriteAddition.value++;
  }


  WidgetServiceState._internal();



}