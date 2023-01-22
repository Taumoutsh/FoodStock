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
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: Material(
            elevation: 20,
            child: Container(
              height: UiConstants.INVENTORY_MENU_HEIGHT,
              decoration:
                  const BoxDecoration(color: Color(0xFFCFCDCD), boxShadow: [
                BoxShadow(
                    color: Color(0x66000000),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 4))
              ]),
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
