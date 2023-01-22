import 'package:flutter/material.dart';
import 'package:foodstock/domain/model/article.dart';

import '../../domain/model/enumerate/inventory_mode.dart';
import '../../service/widget_service_state.dart';


class ArticleDetailsWidget extends StatelessWidget {
  final Article currentArticle;

  final WidgetServiceState widgetServiceState = WidgetServiceState();

  ArticleDetailsWidget({super.key, required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    return Expanded(child:
        Container(
            constraints: const BoxConstraints(minWidth: 200),
            child:
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          // Colonne du nom de l'article et de la quantité
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(currentArticle.labelArticle,
              style: const TextStyle(
                  fontSize: 16,
                  letterSpacing: 0)),
              Container(margin: EdgeInsets.all(2)),
              getWidgetInCart()
            ],
          )// DLUO
        ]))
    );
  }

  Widget getWidgetInCart() {
    Widget widgetToReturn;
    if (currentArticle.isInCart &&
        InventoryMode.STOCK_MODE == widgetServiceState.currentInventoryMode.value) {
      widgetToReturn = const Icon(
        Icons.shopping_cart,
        color: Color(0xFF8B8787),
        size: 18,
      );
    } else {
      widgetToReturn = Container();
    }
    return widgetToReturn;
  }
}
