import 'package:flutter/material.dart';
import 'package:foodstock/service/data_manager.dart';
import 'package:foodstock/service/data_provider.dart';
import 'package:foodstock/widgets/generic_items/generic_button_widget.dart';

import '../../domain/model/article.dart';
import '../../service/widget_service_state.dart';

class ArticleValidButtonWidget extends StatelessWidget {
  final Article currentArticle;

  final dataProviderService = DataProviderService();
  final dataManagerService = DataManagerService();
  final widgetServiceState = WidgetServiceState();

  ArticleValidButtonWidget({super.key, required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GenericButtonWidget(
            colorsToApply: const [Color(0xFF70AC62), Color(0xFF377F29)],
            onTapFunction: _updateArticleQuantity,
            iconData: Icons.check_rounded,
            iconSize: 40));
  }

  _updateArticleQuantity() {
      Future<bool> futureInventoryHasChanged = dataManagerService.addOrRemoveFromInventaire(
          currentArticle,
          widgetServiceState
              .currentQuantityByArticle[currentArticle.pkArticle]!);
      currentArticle.resetReadingTileState();
  }
}
