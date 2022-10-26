
import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/article_tile_state_enum.dart';

import '../domain/article.dart';

class WidgetServiceState {

  static final WidgetServiceState _instance = WidgetServiceState._internal();

  Map<int, int> currentQuantityByArticle = new Map();

  Article? currentUpdatedArticle;

  factory WidgetServiceState() {
    return _instance;
  }

  WidgetServiceState._internal();



}