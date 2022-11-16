import 'dart:async';
import 'dart:collection';
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
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    List<Inventaire> inventaireListToAdd = [];
    if (firestoreDatabase != null) {
      for (int i = 0; i < quantity; i++) {
        Inventaire inventaire = Inventaire(
            dateAchatArticle: DateTime.now().toString(),
            dateAchatArticleDateTime: DateTime.now(),
            article: article);
        String pkInventaire = await addData(inventaire);
        log.info("addToTable() -"
                " Ajout de l'item d'inventaire avec l'identifiant " +
            pkInventaire);

        inventaireListToAdd.add(inventaire);
      }
    }
    return inventaireListToAdd;
  }

  @override
  Future<Inventaire?> removeInventoryItemWhereArticle(Article article) async {
    Inventaire? futureInventaire;
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    if (firestoreDatabase != null) {
      Inventaire inventaireToRemove =
          await dataProviderService.getOlderInventoryItemByArticle(article);
      String inventaireToRemoveKey = inventaireToRemove.pkInventaire!;
      firestoreDatabase
          .collection(tableName())
          .doc(inventaireToRemoveKey)
          .delete();
      log.info("removeFromTable() - Suppression de l'item d'inventaire"
              " avec l'identifiant " +
          inventaireToRemoveKey);
      futureInventaire = inventaireToRemove;
    } else {
      log.severe("removeFromTable() - FirestoreDatabase instance is null");
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

  Future<Inventaire> constructSingleObjectFromDatabase(mapEntry) async {
    Article article =
        dataProviderService.articleMap[mapEntry['fk_Article'].toString()]!;
    var inventaireToAdd = Inventaire(
        pkInventaire: mapEntry['pk_Inventaire'],
        dateAchatArticle: mapEntry['dateAchatArticle'],
        dateAchatArticleDateTime: DateTime.parse(mapEntry['dateAchatArticle']),
        article: article);
    inventaireToAdd.inventaireReference = mapEntry[Inventaire.REFERENCE_LABEL];
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
