import 'package:flutter/material.dart';
import 'package:foodstock/service/data_manager.dart';
import 'package:foodstock/service/widget_service_state.dart';
import 'package:foodstock/widgets/generic_items/generic_button_widget.dart';

import '../../domain/model/article.dart';
import '../../domain/model/enumerate/article_tile_state_enum.dart';

class ArticleCartButtonWidget extends StatefulWidget {
  final Article currentArticle;

  const ArticleCartButtonWidget({super.key, required this.currentArticle});

  @override
  State<StatefulWidget> createState() => _ArticleCartButtonWidget();
}

class _ArticleCartButtonWidget extends State<ArticleCartButtonWidget> {
  final DataManagerService dataManagerService = DataManagerService();
  final WidgetServiceState widgetServiceState = WidgetServiceState();

  _updateCartStatus() {
    setState(() {
      dataManagerService.updateArticleCart(widget.currentArticle);
      widgetServiceState.incrementCartTriggeredCount();
      widget.currentArticle.resetReadingTileState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GenericButtonWidget(
            colorsToApply: const [Color(0xFFF3EA6A), Color(0xFFF8B020)],
            onTapFunction: _updateCartStatus,
            iconData: getIconStyle(),
            iconSize: 25));
  }

  IconData getIconStyle() {
    IconData iconToReturn;
    if (!widget.currentArticle.isInCart) {
      iconToReturn = Icons.add_shopping_cart;
    } else {
      iconToReturn = Icons.remove_shopping_cart;
    }
    return iconToReturn;
  }
}
