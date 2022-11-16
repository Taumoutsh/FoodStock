import 'package:cloud_firestore/cloud_firestore.dart';

enum ItemEventType {
  REMOVED,

  UPDATED,

  ADDED;

  static ItemEventType? getItemEventTypeFromDocumentChangeType(
      DocumentChangeType documentChangeType) {
    switch (documentChangeType) {
      case DocumentChangeType.added:
        return ItemEventType.ADDED;
      case DocumentChangeType.removed:
        return ItemEventType.REMOVED;
      case DocumentChangeType.modified:
        return ItemEventType.UPDATED;
    }
  }
}
