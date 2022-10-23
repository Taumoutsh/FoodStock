import 'dart:collection';

import 'package:inventaire_m_et_t/domain/mapped_object.dart';

class TypeArticle extends MappedObject{

  static const String TABLE_NAME = "TypeArticle";
  static const String PK_NAME = "pk_TypeArticle";
  static const String LABEL_NAME = "labelTypeArticle";

  int pkTypeArticle;

  String labelTypeArticle;

  TypeArticle({
    required this.pkTypeArticle,
    required this.labelTypeArticle,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'pk_TypeArticle': pkTypeArticle,
      'labelTypeArticle': labelTypeArticle
    };
  }

}