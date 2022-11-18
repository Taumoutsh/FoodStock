import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:foodstock/domain/model/datatypes/mapped_object.dart';
import 'package:foodstock/domain/model/enumerate/item_event_type.dart';
import 'package:foodstock/domain/model/item_update_event.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import '../../../database/firebase_provider.dart';
import '../data_fetcher.dart';

abstract class FirebaseDataFetcher<T extends MappedObject> extends DataFetcher<T> {
  FirebaseDataFetcher() {
    subscribeToUpdates();
  }

  FirebaseProvider firebaseProvider = FirebaseProvider();

  BehaviorSubject<ItemUpdateEvent> dataComingFromDatabaseProperty = BehaviorSubject();

  final log = Logger('FirebaseDataFetcher');

  Future<void> subscribeToUpdates() async {
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    if (firestoreDatabase != null) {
      firestoreDatabase.collection(tableName()).snapshots().listen((event) async {
        var docChangeIterator = event.docChanges.iterator;
        List<T> listOfMap = [];
        // !!! We ensure that the documentChangeType will be the same for the single data updates,
        // transactions and batch. If not, handle the type for each arrays. !!!
        DocumentChangeType? documentType;
        while (docChangeIterator.moveNext()) {
          var documentChange = docChangeIterator.current;
          DocumentSnapshot documentSnapshot = documentChange.doc;
          documentType = documentChange.type;
          Map<String, dynamic>? data =
          documentSnapshot.data() as Map<String, dynamic>?;
          Map<String, dynamic> mapInternal = {};
          if (data != null) {
            print(documentSnapshot.id);
            mapInternal[primaryKeyName()] = documentSnapshot.id;
            mapInternal[getReferenceLabel()] = documentSnapshot.reference;
            for (MapEntry internalData in data.entries) {
              if (internalData.value is DocumentReference) {
                String id = internalData.value.id;
                mapInternal[internalData.key] = id;
              } else {
                mapInternal[internalData.key] = internalData.value;
              }
            }
            T listOfChanges =
                await constructSingleObjectFromDatabase(mapInternal);
            listOfMap.add(listOfChanges);
          }
        }
        if(listOfMap.isNotEmpty && documentType != null) {
          dataComingFromDatabaseProperty.add(
              ItemUpdateEvent(listOfMap,
                  ItemEventType.getItemEventTypeFromDocumentChangeType
                    (documentType)));
        } else {
          log.severe("subscribeToUpdates() - Impossible to send ItemUpdateEvent"
              " because either listOfMap is empty or documentType is null");
        }
      });
    }
  }

  Future<List<T>> constructObjectsFromDatabase(List<Map<String, dynamic>> map);

  Future<T> constructSingleObjectFromDatabase(Map<String, dynamic> map);

  @override
  Future<List<T>> getData(int primaryKey) async {
    // Get a reference to the database.
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    List<Map<String, dynamic>> listOfMaps = [];
    if (firestoreDatabase != null) {
      final docRef = firestoreDatabase.collection(tableName()).get();
      QuerySnapshot queryResponse = await docRef;
      listOfMaps = _computeListOfMaps(queryResponse);
    }
    return constructObjectsFromDatabase(listOfMaps);
  }

  @override
  Future<List<T>> getAllData() async {
    // Get a reference to the database.
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    List<Map<String, dynamic>> listOfMaps = [];
    if (firestoreDatabase != null) {
      final docRef = firestoreDatabase.collection(tableName()).get();
      QuerySnapshot queryResponse = await docRef;
      listOfMaps = _computeListOfMaps(queryResponse);
    }
    return constructObjectsFromDatabase(listOfMaps);
  }

  @override
  Future<int> removeData(String primaryKey) async {
    int count = 0;
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    if (firestoreDatabase != null) {
      await firestoreDatabase.collection(tableName()).doc(primaryKey).delete();
      count++;
    }
    return count;
  }

  @override
  Future<List<T>> getDataFromTableOrderBy(String label, bool byAsc) async {
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    List<Map<String, dynamic>> listOfMaps = [];
    if (firestoreDatabase != null) {
      final docRef = firestoreDatabase
          .collection(tableName())
          .orderBy(label, descending: !byAsc)
          .get();
      QuerySnapshot queryResponse = await docRef;
      listOfMaps = _computeListOfMaps(queryResponse);
    }
    return constructObjectsFromDatabase(listOfMaps);
  }

  List<Map<String, dynamic>> _computeListOfMaps(
      QuerySnapshot<Object?> queryResponse) {
    final List<Map<String, dynamic>> listOfMaps = [];
    for (var rawDataMap in queryResponse.docs) {
      var data = rawDataMap.data();
      Map<String, dynamic> mapInternal = {};
      if (data is LinkedHashMap) {
        for (MapEntry internalData in data.entries) {
          if (internalData.value is DocumentReference) {
            String id = internalData.value.id;
            mapInternal[internalData.key] = id;
          } else {
            mapInternal[internalData.key] = internalData.value;
          }
        }
      }
      mapInternal[primaryKeyName()] = rawDataMap.id;
      mapInternal[getReferenceLabel()] = rawDataMap.reference;
      listOfMaps.add(mapInternal);
    }
    return listOfMaps;
  }

  String getReferenceLabel();
}
