import 'package:flutter/cupertino.dart';
import 'package:inventaire_m_et_t/domain/article_tile_state_enum.dart';
import 'package:logging/logging.dart';

import '../domain/article.dart';
import '../domain/data_manager.dart';
import '../domain/data_provider.dart';
import '../domain/type_article.dart';
import '../service/widget_service_state.dart';
import 'article_tile_widget.dart';

class ArticleTileListWidget extends StatefulWidget {
  DataProviderService dataProviderService = DataProviderService();
  DataManagerService dataManagerService = DataManagerService();
  WidgetServiceState widgetServiceState = WidgetServiceState();

  ArticleTileListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ArticleTileList();
}

class _ArticleTileList extends State<ArticleTileListWidget> {

  final log = Logger('DataManagerService');

  List<ArticleTile> articleTileList = [];

  List<ArticleTile> _redrawList(TypeArticle? typeArticle) {
    articleTileList.clear();
    List<ArticleTile> newUnorderedArticleTileList = [];
    if (typeArticle != null) {
      for (Article article in widget.dataProviderService.articleMap.values) {
        if (article.typeArticle.pkTypeArticle == typeArticle.pkTypeArticle) {
          newUnorderedArticleTileList.add(ArticleTile(currentArticle: article));
        }
      }
    }
    List<ArticleTile> newList = newUnorderedArticleTileList..sort((e1, e2) =>
        e1.currentArticle.compareTo(e2.currentArticle));
    return newList;
  }

  @override
  void initState() {
    articleTileList =
        _redrawList(widget.widgetServiceState.currentSelectedTypeArticle.value);

    // Ce listener permet de remettre les tuiles dans leur état initiale
    // dans le cas où certaines étaient en état de modification.
    widget.widgetServiceState.currentSelectedTypeArticle.addListener(() {
      setState(() {
        articleTileList = _redrawList(
            widget.widgetServiceState.currentSelectedTypeArticle.value);
      });
    });

    // Ce listener écoute le bouton de favoris. Il permet de
    widget.widgetServiceState.favoriteAddition.addListener(() {
      setState(() {
        List<ArticleTile> newList = articleTileList..sort((e1, e2) =>
            e1.currentArticle.compareTo(e2.currentArticle));
        articleTileList = newList;
      });
    });

    // Ce listener écoute le bouton de favoris. Il permet de
    widget.widgetServiceState.triggerListUpdate.addListener(() {
      setState(() {
        articleTileList = _redrawList(
            widget.widgetServiceState.currentSelectedTypeArticle.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Column(
      children: articleTileList,
    )));
  }
}
