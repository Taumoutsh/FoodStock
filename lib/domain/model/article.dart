import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:foodstock/domain/model/datatypes/mapped_object.dart';
import 'package:foodstock/domain/model/type_article.dart';

import 'enumerate/article_tile_state_enum.dart';

class Article extends MappedObject implements Comparable<Article> {
  static const String TABLE_NAME = "Article";
  static const String PK_NAME = "pk_Article";
  static const String LABEL_NAME = "labelArticle";
  static const String FAVORITE_NAME = "estFavoris";
  static const String REFERENCE_LABEL = "articleReference";

  String? pkArticle;
  String labelArticle;
  int peremptionEnJours;
  int quantiteAlerte;
  int quantiteCritique;
  bool estFavoris;
  bool isInCart;
  TypeArticle typeArticle;
  DocumentReference? articleReference;

  ValueNotifier<ArticleTileState> articleTileState =
      ValueNotifier(ArticleTileState.READ_ARTICLE);
  ValueNotifier<bool> isInRemovingState = ValueNotifier(false);

  Article({this.pkArticle,
      required this.labelArticle,
      required this.peremptionEnJours,
      required this.quantiteAlerte,
      required this.quantiteCritique,
      required this.estFavoris,
      required this.typeArticle,
      required this.isInCart});

  void resetReadingTileState() {
    articleTileState.value = ArticleTileState.READ_ARTICLE;
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

  @override
  int compareTo(Article other) {
    if (estFavoris && !other.estFavoris) {
      return -1;
    } else if (!estFavoris && other.estFavoris) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Map<String, dynamic> toSqlite() {
    return {
      'pk_Article': pkArticle,
      'labelArticle': labelArticle,
      'peremptionEnJours': peremptionEnJours,
      'estFavoris': estFavoris ? 1 : 0,
      'quantiteAlerte': quantiteAlerte,
      'quantiteCritique': quantiteCritique,
      'fk_TypeArticle': typeArticle.pkTypeArticle,
      'isInCart' : isInCart
    };
  }

  @override
  Map<String, dynamic> toFirebase() {
    return {
      'labelArticle': labelArticle,
      'peremptionEnJours': peremptionEnJours,
      'estFavoris': estFavoris ? 1 : 0,
      'quantiteAlerte': quantiteAlerte,
      'quantiteCritique': quantiteCritique,
      'fk_TypeArticle': typeArticle.typeArticleReference,
      'isInCart' : isInCart ? 1 : 0
    };
  }

  @override
  String toString() {
    return labelArticle;
  }
}
