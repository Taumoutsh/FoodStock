import 'package:foodstock/domain/mapped_object.dart';

class TypeArticle extends MappedObject{

  static const String TABLE_NAME = "TypeArticle";
  static const String PK_NAME = "pk_TypeArticle";
  static const String LABEL_NAME = "labelTypeArticle";

  int pkTypeArticle;

  String labelTypeArticle;

  String svgResource;

  bool isSelected = false;

  TypeArticle({
    required this.pkTypeArticle,
    required this.labelTypeArticle,
    required this.svgResource
  });

  @override
  Map<String, dynamic> toMap() {
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