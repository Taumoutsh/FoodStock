import 'package:flutter/cupertino.dart';

import '../../domain/model/enumerate/inventory_mode.dart';
import '../../service/widget_service_state.dart';

class InventoryModeItem extends StatefulWidget {
  final WidgetServiceState widgetServiceState = WidgetServiceState();

  final IconData iconData;

  final InventoryMode inventoryMode;

  InventoryModeItem(
      {super.key, required this.iconData, required this.inventoryMode});

  @override
  State<StatefulWidget> createState() => _InventoryModeItem();
}

class _InventoryModeItem extends State<InventoryModeItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder<InventoryMode>(
          valueListenable: widget.widgetServiceState.currentInventoryMode,
          builder: (context, value, child) {
            return GestureDetector(
                onTap: () => widget.widgetServiceState.currentInventoryMode
                    .value = widget.inventoryMode,
                child: Container(
                  height: double.infinity,
                  margin: const EdgeInsets.fromLTRB(11, 6, 11, 6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: computeBackgroundColor(value)),
                  child: Icon(widget.iconData,
                      size: 30, color: computeIconColor(value)),
                ));
          }),
    );
  }

  Color computeBackgroundColor(InventoryMode currentInventoryMode) {
    if (widget.inventoryMode == currentInventoryMode) {
      return const Color(0xFF8B8787);
    } else {
      return const Color(0x00000000);
    }
  }

  Color computeIconColor(InventoryMode currentInventoryMode) {
    if (widget.inventoryMode == currentInventoryMode) {
      return const Color(0xFFFFFFFF);
    } else {
      return const Color(0xFF8B8787);
    }
  }
}
