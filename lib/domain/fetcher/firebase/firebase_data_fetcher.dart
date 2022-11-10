import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../database/firebase_provider.dart';
import '../data_fetcher.dart';

abstract class FirebaseDataFetcher<T> extends DataFetcher<T> {

  FirebaseProvider firebaseProvider =
  FirebaseProvider();

  Future<List<T>> constructObjectFromDatabase(List<Map<String, dynamic>> map);

  @override
  Future<List<T>> getData(int primaryKey) async {
    // Get a reference to the database.
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    List<Map<String, dynamic>> listOfMaps = [];
    if(firestoreDatabase!= null) {
      final docRef = firestoreDatabase.collection(tableName()).get();
      QuerySnapshot queryResponse = await docRef;
      listOfMaps = _computeListOfMaps(queryResponse);
    }
    return constructObjectFromDatabase(listOfMaps);
  }

  @override
  Future<List<T>> getDataOrderBy(int primaryKey, String orderByColumn) async {
    final List<Map<String, dynamic>> map = [];
    return constructObjectFromDatabase(map);
  }

  @override
  Future<List<T>> getDataFromTable() async {
    // Get a reference to the database.
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    List<Map<String, dynamic>> listOfMaps = [];
    if(firestoreDatabase!= null) {
      final docRef = firestoreDatabase.collection(tableName()).get();
      QuerySnapshot queryResponse = await docRef;
      listOfMaps = _computeListOfMaps(queryResponse);
    }
    return constructObjectFromDatabase(listOfMaps);
  }

  @override
  Future<List<T>> getDataFromTableOrderBy(String label, bool byAsc) async {
    FirebaseFirestore? firestoreDatabase = firebaseProvider.db;
    List<Map<String, dynamic>> listOfMaps = [];
    if(firestoreDatabase!= null) {
      final docRef = firestoreDatabase.collection(tableName())
          .orderBy(label, descending: !byAsc).get();
      QuerySnapshot queryResponse = await docRef;
      listOfMaps = _computeListOfMaps(queryResponse);
    }
    return constructObjectFromDatabase(listOfMaps);
  }

  List<Map<String, dynamic>> _computeListOfMaps(QuerySnapshot<Object?> queryResponse) {
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
      mapInternal[primaryKeyName()] = int.parse(rawDataMap.id);
      listOfMaps.add(mapInternal);
    }
    return listOfMaps;
  }

  Future<void> removeDataFromTable(int primaryKey) async {
  }
}