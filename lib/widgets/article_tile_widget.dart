import 'package:flutter/widgets.dart';
import 'package:inventaire_m_et_t/domain/article_tile_state_enum.dart';
import 'package:inventaire_m_et_t/domain/article_update_tile.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';
import 'package:inventaire_m_et_t/service/widget_service_state.dart';
import 'package:path/path.dart';

import '../domain/article.dart';
import '../domain/data_manager.dart';
import 'article_left_side_widget.dart';
import 'article_right_side_widget.dart';
import 'article_tile_separator.dart';

class ArticleTile extends StatefulWidget {

  final Article currentArticle;

  const ArticleTile({super.key, required this.currentArticle});

  @override
  State<ArticleTile> createState() =>
      _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {

  WidgetServiceState widgetServiceState = WidgetServiceState();

  ArticleTileState articleTileState = ArticleTileState.READ_ARTICLE;

  DataProviderService dataProviderService = DataProviderService();

  DataManagerService dataManagerService = DataManagerService();

  _selectRightTile() {
    setState(() {
      if(articleTileState == ArticleTileState.UPDATE_ARTICLE) {
        articleTileState = ArticleTileState.READ_ARTICLE;
      } else {
        final currentUpdatedArticle = widgetServiceState.currentUpdatedArticle;
        if (currentUpdatedArticle != null) {
          currentUpdatedArticle.triggerListeners();
        }
        widgetServiceState.currentUpdatedArticle = widget.currentArticle;
        articleTileState = ArticleTileState.UPDATE_ARTICLE;
      }
    });
  }

  _resetTile() {
    setState(() {
        articleTileState = ArticleTileState.READ_ARTICLE;
    });
  }

  @override
  Widget build(BuildContext context) {

    widget.currentArticle.addListener(() {
      _resetTile();
    });

    return GestureDetector(
      onTap: _selectRightTile,
      child: AnimatedContainer(
        curve: Curves.elasticOut,
          height: 90,
          margin: EdgeInsets.fromLTRB(10, 7, 10, 7),
          decoration: BoxDecoration(
              color: Color(0xFFE9E9E9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 4))
              ]),
          duration: Duration(seconds: 10),
          child: Row(
            children: getArticleTileContentByState(articleTileState),
          )
      )
    );
  }

  List<Widget> getArticleTileContentByState(ArticleTileState state) {
    switch (state) {
      case ArticleTileState.READ_ARTICLE:
        {
          return [
            ArticleLeftSideTile(),
            const ArticleTileSeparator(),
            ArticleRightSideTile(currentArticle: widget.currentArticle)
          ];
        }
      case ArticleTileState.UPDATE_ARTICLE:
        {
          return [
            ArticleUpdateTile(currentArticle: widget.currentArticle)
          ];
        }
      default:
        {
          return [];
        }
    }
  }
}
