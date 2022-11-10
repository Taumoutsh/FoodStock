import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodstock/domain/model/type_article.dart';
import '../firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider extends ChangeNotifier {

  bool isFirebaseInitialized = false;

  FirebaseApp? firebaseApp;

  FirebaseDatabase? firebaseDatabase;

  FirebaseFirestore? db;

  static final FirebaseProvider _instance =
  FirebaseProvider._internal();

  factory FirebaseProvider() {
    return _instance;
  }

  FirebaseProvider._internal();

  Future<bool> initialiseFirebaseDatabase() async {
    if (!isFirebaseInitialized) {
      FirebaseApp queriedFirebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (queriedFirebaseApp != null) {
        db = FirebaseFirestore.instance;
        isFirebaseInitialized = true;
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}