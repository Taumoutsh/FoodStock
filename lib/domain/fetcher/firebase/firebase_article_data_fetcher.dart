import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstock/domain/model/article.dart';
import '../../../service/data_provider.dart';
import '../../model/type_article.dart';
import 'firebase_data_fetcher.dart';

class FirebaseArticleDataFetcher extends FirebaseDataFetcher<Article> {
  var dataProviderService = DataProviderService();



  @override
  Future<String> addData(Article article) async {
    String articleIdToReturn = "0";
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    if (firestoreDatabase != null) {
      DocumentReference<dynamic> documentReference = await firestoreDatabase
          .collection(tableName())
          .add(article.toFirebase());
      article.articleReference = documentReference;
      articleIdToReturn = documentReference.id;
      log.info("addToTable() -"
              " Ajout de l'item d'inventaire avec l'identifiant " +
          articleIdToReturn);
    }
    return articleIdToReturn;
  }

  @override
  Future<int> updateData(Article article) async {
    int count = 0;
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    if (firestoreDatabase != null) {
      await firestoreDatabase
          .collection(tableName())
          .doc(article.pkArticle)
          .update(article.toFirebase());
      count++;
    }
    return count;
  }

  Future<Article> constructSingleObjectFromDatabase(mapEntry) async {
    TypeArticle typeArticle = dataProviderService
        .typeArticleMap[mapEntry['fk_TypeArticle'].toString()]!;
    var articleToAdd = Article(
        pkArticle: mapEntry['pk_Article'],
        labelArticle: mapEntry['labelArticle'],
        peremptionEnJours: mapEntry['peremptionEnJours'],
        quantiteAlerte: mapEntry['quantiteAlerte'],
        quantiteCritique: mapEntry['quantiteCritique'],
        estFavoris: mapEntry['estFavoris'] == 1 ? true : false,
        isInCart: mapEntry['isInCart'] == 1 ? true : false,
        typeArticle: typeArticle);
    articleToAdd.articleReference = mapEntry['articleReference'];
    return articleToAdd;
  }

  @override
  Future<List<Article>> constructObjectsFromDatabase(
      List<Map<String, dynamic>> map) async {
    List<Article> articleToReturn = [];
    for (Map<String, dynamic> mapEntry in map) {
      Article articleToAdd = await constructSingleObjectFromDatabase(mapEntry);
      articleToReturn.add(articleToAdd);
    }
    return Future(() => articleToReturn);
  }

  @override
  String tableName() {
    return Article.TABLE_NAME;
  }

  @override
  String labelName() {
    return Article.LABEL_NAME;
  }

  @override
  String primaryKeyName() {
    return Article.PK_NAME;
  }

  @override
  String getReferenceLabel() {
    return Article.REFERENCE_LABEL;
  }
}
