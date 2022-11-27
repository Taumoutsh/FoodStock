import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodstock/domain/fetcher/interfaces/inventaire_special_queries.dart';
import 'package:foodstock/domain/model/article.dart';
import 'package:logging/logging.dart';
import '../../../service/data_provider.dart';
import '../../model/inventaire.dart';
import 'firebase_data_fetcher.dart';

class FirebaseInventaireDataFetcher extends FirebaseDataFetcher<Inventaire>
    implements InventaireSpecialQueries {
  final log = Logger('FirebaseInventaireDataFetcher');

  var dataProviderService = DataProviderService();

  Future<bool> addDataByBatch(List<Inventaire> listInventaire) async {
    bool dataAdditionSuccessful = false;
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    if (firestoreDatabase != null) {
      final batch = firestoreDatabase.batch();
      for(Inventaire inventaire in listInventaire) {
        var inventaireInDatabase = firestoreDatabase.collection(tableName())
            .doc();
        batch.set(inventaireInDatabase, inventaire.toFirebase());
      }
      await batch.commit();
      dataAdditionSuccessful = true;
    }
    return dataAdditionSuccessful;
  }

  @override
  Future<String> addData(Inventaire inventaire) async {
    String pkInventaire = "ERROR";
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    if (firestoreDatabase != null) {
      DocumentReference<dynamic> documentReference = await firestoreDatabase
          .collection(tableName())
          .add(inventaire.toFirebase());
      inventaire.pkInventaire = documentReference.id;
      inventaire.inventaireReference = documentReference;
      pkInventaire = documentReference.id;
    }
    return pkInventaire;
  }

  @override
  Future<List<Inventaire>> addInventoryItems(article, quantity) async {
    List<Inventaire> inventaireListToAdd = [];
      for (int i = 0; i < quantity; i++) {
        Inventaire inventaire = Inventaire(
            dateAchatArticle: DateTime.now().toString(),
            dateAchatArticleDateTime: DateTime.now(),
            article: article);
        inventaireListToAdd.add(inventaire);
    }
    bool dataAdditionSuccessful = await addDataByBatch(inventaireListToAdd);
      log.info("addInventoryItems() - L'ajout de données est en succès"
          " <$dataAdditionSuccessful>");
    return inventaireListToAdd;
  }

  @override
  Future<Inventaire?> removeInventoryItemWhereArticle(Article article,
      int numberOfInventoryToRemove) async {
    Inventaire? futureInventaire;
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    if (firestoreDatabase != null) {
      await firestoreDatabase.runTransaction((transaction) async {
          final snapshot = await firestoreDatabase
              .collection(tableName())
              .where(foreignKeyName(), isEqualTo: article.articleReference)
              .orderBy(labelName(), descending: false)
              .limit(numberOfInventoryToRemove)
              .get();
          for (int i = 0; i < numberOfInventoryToRemove; i++) {
            transaction.delete(snapshot.docs[i].reference);
          }
      });
    } else {
      log.severe("removeFromTable() - L'instance FiresotreDatabase est null");
    }
    return futureInventaire;
  }

  @override
  Future<int> removeInventoryItemFromTableWhereArticle(Article article) async {
    int count = 0;
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    if (firestoreDatabase != null) {
      for (Inventaire inventaire in dataProviderService.inventaireMap.values) {
        if (inventaire.article == article) {
          firestoreDatabase
              .collection(tableName())
              .doc(inventaire.pkInventaire)
              .delete();
          count++;
        }
      }
      log.info("removeAllArticleFromTable() - Suppression de tous les items"
          " d'inventaire liés à l'article <$article.articleKey>."
          " Nombre d'éléments supprimés : <$count>");
    }
    return count;
  }

  @override
  Future<Inventaire> constructSingleObjectFromDatabase(map) async {
    Article article =
        dataProviderService.articleMap[map['fk_Article'].toString()]!;
    var inventaireToAdd = Inventaire(
        pkInventaire: map['pk_Inventaire'],
        dateAchatArticle: map['dateAchatArticle'],
        dateAchatArticleDateTime: DateTime.parse(map['dateAchatArticle']),
        article: article);
    inventaireToAdd.inventaireReference = map[Inventaire.REFERENCE_LABEL];
    return inventaireToAdd;
  }

  @override
  Future<List<Inventaire>> constructObjectsFromDatabase(map) async {
    List<Inventaire> inventaireToReturn = [];
    for (Map<String, dynamic> mapEntry in map) {
      Inventaire inventaireToAdd =
          await constructSingleObjectFromDatabase(mapEntry);
      inventaireToReturn.add(inventaireToAdd);
    }
    return Future(() => inventaireToReturn);
  }

  @override
  String tableName() {
    return Inventaire.TABLE_NAME;
  }

  @override
  String labelName() {
    return Inventaire.LABEL_NAME;
  }

  @override
  String primaryKeyName() {
    return Inventaire.PK_NAME;
  }

  String foreignKeyName() {
    return Inventaire.FK_ARTICLE;
  }

  @override
  String getReferenceLabel() {
    return Inventaire.REFERENCE_LABEL;
  }

  @override
  Future<int> updateData(Inventaire t) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}
