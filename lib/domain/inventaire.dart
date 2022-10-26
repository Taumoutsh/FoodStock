import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:inventaire_m_et_t/domain/mapped_object.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'article.dart';

class Inventaire extends MappedObject {

  static const String TABLE_NAME = "Inventaire";
  static const String PK_NAME = "pk_Inventaire";
  static const String LABEL_NAME = "dateAchatArticle";
  static const String FK_ARTICLE = "fk_Article";

  int ?pkInventaire;
  String dateAchatArticle;
  Article article;

  Inventaire({
    this.pkInventaire,
    required this.dateAchatArticle,
    required this.article
  });

  Map<String, dynamic> toMap() {
    return {
      'dateAchatArticle': dateAchatArticle,
      'fk_Article': article.pkArticle,
    };
  }

}