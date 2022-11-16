import 'package:foodstock/domain/model/datatypes/mapped_object.dart';

import 'enumerate/item_event_type.dart';

class ItemUpdateEvent<T> {

  T? itemToUpdate;

  ItemEventType? itemEventType;

  ItemUpdateEvent(this.itemToUpdate, this.itemEventType);
}