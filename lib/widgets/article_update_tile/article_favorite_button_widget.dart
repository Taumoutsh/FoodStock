import 'package:flutter/material.dart';
import 'package:foodstock/service/data_manager.dart';
import 'package:foodstock/service/widget_service_state.dart';
import 'package:foodstock/widgets/generic_items/generic_button_widget.dart';

import '../../domain/model/article.dart';
import '../../domain/model/enumerate/article_tile_state_enum.dart';

class ArticleFavoriteButtonWidget extends StatelessWidget {
  final Article currentArticle;
  final DataManagerService dataManagerService = DataManagerService();
  final WidgetServiceState widgetServiceState = WidgetServiceState();

  ArticleFavoriteButtonWidget({super.key, required this.currentArticle});

  _updateFavoriteStatus() {
    dataManagerService.updateArticleFavorite(currentArticle);
    widgetServiceState.incrementFavoriteTriggeredCount();
    currentArticle.resetReadingTileState();
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
}
