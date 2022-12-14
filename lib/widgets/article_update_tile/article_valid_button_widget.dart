import 'package:flutter/material.dart';
import 'package:foodstock/service/data_manager.dart';
import 'package:foodstock/service/data_provider.dart';
import 'package:foodstock/widgets/generic_items/generic_button_widget.dart';

import '../../domain/model/article.dart';
import '../../service/widget_service_state.dart';

class ArticleValidButtonWidget extends StatefulWidget {
  final Article currentArticle;

  const ArticleValidButtonWidget({super.key, required this.currentArticle});

  @override
  State<StatefulWidget> createState() => _ArticleValidButtonWidget();
}

class _ArticleValidButtonWidget extends State<ArticleValidButtonWidget> {
  var dataProviderService = DataProviderService();

  var dataManagerService = DataManagerService();

  var widgetServiceState = WidgetServiceState();

  _updateArticleQuantity() {
    setState(() {
      Future<bool> futureInventoryHasChanged = dataManagerService.addOrRemoveFromInventaire(
          widget.currentArticle,
          widgetServiceState
              .currentQuantityByArticle[widget.currentArticle.pkArticle]!);
      widget.currentArticle.resetReadingTileState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GenericButtonWidget(
          colorsToApply: const [Color(0xFF70AC62), Color(0xFF377F29)],
          onTapFunction: _updateArticleQuantity,
          iconData: Icons.check_rounded,
          iconSize: 50));
  }
}
