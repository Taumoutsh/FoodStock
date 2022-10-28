
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/article_tile_state_enum.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';

import '../domain/article.dart';
import '../domain/type_article.dart';

class WidgetServiceState extends ChangeNotifier {

  static final DataProviderService dataProviderService = DataProviderService();

  static final WidgetServiceState _instance = WidgetServiceState._internal();

  Map<int, int> currentQuantityByArticle = new Map();

  Article? currentUpdatedArticle;

  ValueNotifier<TypeArticle?> currentSelectedTypeArticle = new ValueNotifier(null);

  ValueNotifier<bool> favoriteAddition = new ValueNotifier(false);

  factory WidgetServiceState() {
    return _instance;
  }



  WidgetServiceState._internal();



}