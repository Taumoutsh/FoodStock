import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/article_tile_state_enum.dart';
import 'package:inventaire_m_et_t/domain/data_manager.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';
import 'package:inventaire_m_et_t/widgets/generic_items/generic_button_widget.dart';

import '../../domain/article.dart';
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
      dataManagerService.addOrRemoveFromInventaire(
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
          colorsToApply: [Color(0xFF70AC62), Color(0xFF377F29)],
          onTapFunction: _updateArticleQuantity,
          iconData: Icons.check_rounded,
          iconSize: 50));
  }
}
