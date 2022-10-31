
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/article_tile_state_enum.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';
import 'package:inventaire_m_et_t/widgets/article_tile_widget.dart';

import '../domain/article.dart';
import '../domain/type_article.dart';

class WidgetServiceState extends ChangeNotifier {

  static final DataProviderService dataProviderService = DataProviderService();

  static final WidgetServiceState _instance = WidgetServiceState._internal();

  Map<int, int> currentQuantityByArticle = new Map();

  Article? currentUpdatedArticle;

  ValueNotifier<TypeArticle?> currentSelectedTypeArticle = new ValueNotifier(null);

  ValueNotifier<int> favoriteAddition = new ValueNotifier(0);

  ValueNotifier<int> triggerListUpdate = new ValueNotifier(0);

  factory WidgetServiceState() {
    return _instance;
  }

  incrementFavoriteTriggeredCount() {
    favoriteAddition.value++;
  }


  WidgetServiceState._internal();



}