import 'package:foodstock/domain/model/datatypes/mapped_object.dart';

import 'enumerate/item_event_type.dart';

class ItemUpdateEvent<T> {

  List<T?> itemsToUpdate;

  ItemEventType? itemEventType;

  ItemUpdateEvent(this.itemsToUpdate, this.itemEventType);
}