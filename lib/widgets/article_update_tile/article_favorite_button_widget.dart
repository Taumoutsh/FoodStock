import 'package:flutter/material.dart';
import 'package:foodstock/service/data_manager.dart';
import 'package:foodstock/service/widget_service_state.dart';
import 'package:foodstock/widgets/generic_items/generic_button_widget.dart';

import '../../domain/model/article.dart';
import '../../domain/model/enumerate/article_tile_state_enum.dart';

class ArticleFavoriteButtonWidget extends StatefulWidget {
  final Article currentArticle;

  const ArticleFavoriteButtonWidget({super.key, required this.currentArticle});

  @override
  State<StatefulWidget> createState() => _ArticleFavoriteButtonWidget();
}

class _ArticleFavoriteButtonWidget extends State<ArticleFavoriteButtonWidget> {
  final DataManagerService dataManagerService = DataManagerService();
  final WidgetServiceState widgetServiceState = WidgetServiceState();

  _updateFavoriteStatus() {
    setState(() {
      dataManagerService.updateArticleFavorite(widget.currentArticle);
      widgetServiceState.incrementFavoriteTriggeredCount();
      widget.currentArticle.resetReadingTileState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GenericButtonWidget(
            colorsToApply: const [Color(0xFFFF1048), Color(0xFFFF147A)],
            onTapFunction: _updateFavoriteStatus,
            iconData: Icons.favorite_rounded,
            iconSize: 25));
  }

  getIconStyle() {
    Icon iconToReturn;
    if (!widget.currentArticle.estFavoris) {
      iconToReturn =
          const Icon(Icons.favorite_rounded, size: 50, color: Colors.white);
    } else {
      iconToReturn = const Icon(Icons.favorite_border_rounded,
          size: 50, color: Colors.white);
    }
    return iconToReturn;
  }
}
