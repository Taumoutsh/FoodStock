import 'package:inventaire_m_et_t/domain/mapped_object.dart';
import 'package:inventaire_m_et_t/domain/type_article.dart';

class Article extends MappedObject {

  static const String TABLE_NAME = "Article";
  static const String PK_NAME = "pk_Article";
  static const String LABEL_NAME = "labelArticle";

  int pkArticle;
  String labelArticle;
  int peremptionEnJours;
  TypeArticle typeArticle;

  Article({
    required this.pkArticle,
    required this.labelArticle,
    required this.peremptionEnJours,
    required this.typeArticle
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          pkArticle == other.pkArticle &&
          labelArticle == other.labelArticle &&
          peremptionEnJours == other.peremptionEnJours &&
          typeArticle == other.typeArticle;

  @override
  int get hashCode =>
      pkArticle.hashCode ^
      labelArticle.hashCode ^
      peremptionEnJours.hashCode ^
      typeArticle.hashCode;

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  } // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
}