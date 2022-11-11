import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstock/domain/model/datatypes/mapped_object.dart';

class TypeArticle extends MappedObject{

  static const String TABLE_NAME = "TypeArticle";
  static const String PK_NAME = "pk_TypeArticle";
  static const String LABEL_NAME = "labelTypeArticle";
  static const String REFERENCE_LABEL = "typeArticleReference";

  String pkTypeArticle;
  String labelTypeArticle;
  String svgResource;
  bool isSelected = false;
  DocumentReference? typeArticleReference;

  TypeArticle({
    required this.pkTypeArticle,
    required this.labelTypeArticle,
    required this.svgResource
  });

  @override
  Map<String, dynamic> toSqlite() {
    return {
      'pk_TypeArticle': pkTypeArticle,
      'labelTypeArticle': labelTypeArticle,
      'svgResource': svgResource,
    };
  }

  @override
  String toString() {
    return "TypeArticle -> primary key : $pkTypeArticle,"
        " label : $labelTypeArticle, isSelected: $isSelected";
  }

}