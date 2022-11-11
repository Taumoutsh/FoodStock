import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:foodstock/domain/model/datatypes/mapped_object.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'article.dart';

class Inventaire extends MappedObject {

  static const String TABLE_NAME = "Inventaire";
  static const String PK_NAME = "pk_Inventaire";
  static const String LABEL_NAME = "dateAchatArticle";
  static const String FK_ARTICLE = "fk_Article";
  static const String REFERENCE_LABEL = "inventaireReference";

  String? pkInventaire;
  String dateAchatArticle;
  DateTime dateAchatArticleDateTime;
  Article article;
  DocumentReference? inventaireReference;

  Inventaire({
    this.pkInventaire,
    required this.dateAchatArticle,
    required this.dateAchatArticleDateTime,
    required this.article
  });

  @override
  Map<String, dynamic> toSqlite() {
    return {
      'dateAchatArticle': dateAchatArticle,
      'fk_Article': article.pkArticle,
    };
  }

  @override
  Map<String, dynamic> toFirebase() {
    return {
      'dateAchatArticle': dateAchatArticle,
      'fk_Article': article.articleReference,
    };
  }
}