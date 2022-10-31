import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/data_manager.dart';
import 'package:inventaire_m_et_t/service/widget_service_state.dart';
import 'package:inventaire_m_et_t/widgets/generic_items/generic_button_widget.dart';

import '../../domain/article.dart';
import '../../domain/article_tile_state_enum.dart';

class ArticleFavoriteButtonWidget extends StatefulWidget {

  final Article currentArticle;

  ArticleFavoriteButtonWidget({super.key, required this.currentArticle});

  @override
  State<StatefulWidget> createState() => _ArticleFavoriteButtonWidget();
}

class _ArticleFavoriteButtonWidget extends State<ArticleFavoriteButtonWidget> {

  final DataManagerService dataManagerService = DataManagerService();
  final WidgetServiceState widgetServiceState = WidgetServiceState();

  late Icon _iconStyle;

  _updateFavoriteStatus() {
    setState(() {
      dataManagerService.updateArticleFavorite(widget.currentArticle);
      widgetServiceState.incrementFavoriteTriggeredCount();
      _iconStyle = getIconStyle();
      widget.currentArticle.resetReadingTileState();
    });
  }

  @override
  Widget build(BuildContext context) {
    _iconStyle = getIconStyle();
    return Expanded(child:
        GenericButtonWidget(
            colorsToApply: [Color(0xFFFF1048), Color(0xFFFF147A)],
            onTapFunction: _updateFavoriteStatus,
            iconData: Icons.favorite_rounded,
            iconSize: 30));
  }

  getIconStyle() {
    Icon iconToReturn;
    if(!widget.currentArticle.estFavoris) {
      iconToReturn = Icon(Icons.favorite_rounded, size: 50, color: Colors.white);
    } else {
      iconToReturn = Icon(Icons.favorite_border_rounded, size: 50, color: Colors.white);
    }
    return iconToReturn;
  }
}
