import 'package:flutter/cupertino.dart';
import 'package:inventaire_m_et_t/domain/article_tile_state_enum.dart';
import 'package:logging/logging.dart';

import '../domain/article.dart';
import '../domain/data_manager.dart';
import '../domain/data_provider.dart';
import '../domain/type_article.dart';
import '../service/widget_service_state.dart';
import 'article_tile_widget.dart';

class ArticleTileList extends StatefulWidget {
  DataProviderService dataProviderService = DataProviderService();
  DataManagerService dataManagerService = DataManagerService();
  WidgetServiceState widgetServiceState = WidgetServiceState();

  @override
  State<StatefulWidget> createState() => _ArticleTileList();
}

class _ArticleTileList extends State<ArticleTileList> {

  final log = Logger('DataManagerService');

  List<StatefulWidget> articleTileList = [];

  List<StatefulWidget> _redrawList(TypeArticle? typeArticle) {
    articleTileList.clear();
    List<StatefulWidget> newArticleTileList = [];
    if (typeArticle != null) {
      for (Article article in widget.dataProviderService.articleMap.values) {
        if (article.typeArticle.pkTypeArticle == typeArticle.pkTypeArticle) {
          newArticleTileList.add(ArticleTile(currentArticle: article));
        }
      }
    }
    return newArticleTileList;
  }

  @override
  void initState() {
    log.info("INIT OF THE LIST");
    // Ce listener permet de remettre les tuiles dans leur état initiale
    // dans le cas où certaines étaient en état de modification.
    widget.widgetServiceState.currentSelectedTypeArticle.addListener(() {
      setState(() {
        if (widget.widgetServiceState.currentUpdatedArticle != null) {
          widget.widgetServiceState.currentUpdatedArticle!.articleTileState
              .value = ArticleTileState.READ_ARTICLE;
        }
        articleTileList = _redrawList(
            widget.widgetServiceState.currentSelectedTypeArticle.value);
      });
    });

    // Ce listener écoute le bouton de favoris. Il permet de
    widget.widgetServiceState.favoriteAddition.addListener(() {
      setState(() {
        articleTileList = _redrawList(
            widget.widgetServiceState.currentSelectedTypeArticle.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    articleTileList =
        _redrawList(widget.widgetServiceState.currentSelectedTypeArticle.value);
    return Expanded(
        child: SingleChildScrollView(
            child: Column(
      children: articleTileList,
    )));
  }
}
