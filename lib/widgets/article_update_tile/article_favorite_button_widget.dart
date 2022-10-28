import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/data_manager.dart';
import 'package:inventaire_m_et_t/service/widget_service_state.dart';

import '../../domain/article.dart';

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
      widgetServiceState.favoriteAddition.value = true;
      _iconStyle = getIconStyle();
    });
  }

  @override
  Widget build(BuildContext context) {
    _iconStyle = getIconStyle();
    return GestureDetector(
        onTap: _updateFavoriteStatus,
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 7.5, 0),
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFA795), Color(0xFFFBC3B8)]),
              shape: BoxShape.circle),
          child: _iconStyle,
        ));
  }

  getIconStyle() {
    Icon iconToReturn;
    if(!widget.currentArticle.estFavoris) {
      iconToReturn = Icon(Icons.star_rounded, size: 50, color: Colors.white);
    } else {
      iconToReturn = Icon(Icons.star_border_rounded, size: 50, color: Colors.white);
    }
    return iconToReturn;
  }
}
