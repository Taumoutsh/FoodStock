import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataManagerService extends ChangeNotifier {

  FirebaseApp? firebaseApp;

  FirebaseDatabase? firebaseDatabase;

  FirebaseFirestore? db;

  static final FirebaseDataManagerService _instance = FirebaseDataManagerService
      ._internal();

  factory FirebaseDataManagerService() {
    return _instance;
  }

  FirebaseDataManagerService._internal();

  Future<bool> initialiseFirebaseDatabase() async {
    FirebaseApp queriedFirebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if(queriedFirebaseApp != null) {
      db = FirebaseFirestore.instance;
      final docRef = db!.collection('Inventaire').doc("1");
      DocumentSnapshot res = await docRef.get();
      if (res != null) {
        print(res.data());
      } else {
        print('No data available.');
      }
      return true;
    } else {
      return false;
    }
  }
}