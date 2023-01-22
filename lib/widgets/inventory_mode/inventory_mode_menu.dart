import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstock/domain/model/enumerate/inventory_mode.dart';
import 'package:foodstock/widgets/inventory_mode/inventory_mode_item.dart';
import '../../domain/model/constants/ui_constants.dart' as UiConstants;

class InventoryModeMenuWidget extends StatelessWidget {
  const InventoryModeMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Material(
            elevation: 20,
            child: Container(
              height: UiConstants.INVENTORY_MENU_HEIGHT,
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              decoration:
                  const BoxDecoration(color: Color(0xFFCFCDCD)),
              child: Row(
                children: [
                  InventoryModeItem(
                      iconData: Icons.food_bank,
                      inventoryMode: InventoryMode.STOCK_MODE),
                  InventoryModeItem(
                      iconData: Icons.shopping_cart,
                      inventoryMode: InventoryMode.CART_MODE),
                ],
              ),
            )));
  }
}
