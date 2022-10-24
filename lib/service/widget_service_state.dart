import 'dart:collection';

import '../domain/article.dart';

class WidgetServiceState {

  static final WidgetServiceState _instance = WidgetServiceState._internal();

  Map<int, int> currentQuantityByArticle = new Map();

  factory WidgetServiceState() {
    return _instance;
  }

  WidgetServiceState._internal();

}