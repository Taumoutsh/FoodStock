import 'package:flutter/widgets.dart';
import 'package:inventaire_m_et_t/domain/mapped_object.dart';
import 'package:inventaire_m_et_t/domain/type_article.dart';

import 'article_tile_state_enum.dart';

class Article extends ChangeNotifier {

  static const String TABLE_NAME = "Article";
  static const String PK_NAME = "pk_Article";
  static const String LABEL_NAME = "labelArticle";
  static const String FAVORITE_NAME = "estFavoris";

  int pkArticle;
  String labelArticle;
  int peremptionEnJours;
  bool estFavoris;
  TypeArticle typeArticle;
  ArticleTileState articleTileState = ArticleTileState.READ_ARTICLE;

  Article({
    required this.pkArticle,
    required this.labelArticle,
    required this.peremptionEnJours,
    required this.estFavoris,
    required this.typeArticle
  });

  void triggerListeners() {
    this.notifyListeners();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          pkArticle == other.pkArticle &&
          labelArticle == other.labelArticle &&
          peremptionEnJours == other.peremptionEnJours &&
          estFavoris == other.estFavoris &&
          typeArticle == other.typeArticle;

  @override
  int get hashCode =>
      pkArticle.hashCode ^
      labelArticle.hashCode ^
      peremptionEnJours.hashCode ^
      estFavoris.hashCode ^
      typeArticle.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'pk_Article': pkArticle,
      'labelArticle' : labelArticle,
      'peremptionEnJours' : peremptionEnJours,
      'estFavoris' : estFavoris ? 1 : 0,
      'fk_TypeArticle' : typeArticle.pkTypeArticle
    };
  }
}