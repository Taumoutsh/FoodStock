import 'package:flutter/cupertino.dart';
import 'package:foodstock/domain/article_tile_state_enum.dart';
import 'package:foodstock/widgets/article_creation/article_creation_widget.dart';
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

  final log = Logger('ArticleTileListWidget');

  List<ArticleTileWidget> articleTileList = [];

  List<ArticleTileWidget> _redrawList(TypeArticle? typeArticle) {
    articleTileList.clear();
    List<ArticleTileWidget> newUnorderedArticleTileList = [];
    if (typeArticle != null) {
      for (Article article in widget.dataProviderService.articleMap.values) {
        if (article.typeArticle.pkTypeArticle == typeArticle.pkTypeArticle) {
          newUnorderedArticleTileList.add(ArticleTileWidget(currentArticle: article));
        }
      }
    }
    List<ArticleTileWidget> newList = newUnorderedArticleTileList..sort((e1, e2) =>
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
      log.config("currentSelectedTypeArticle.listener() -"
          " Redraw tiles list because the"
          " current selected TypeArticle has changed");
      setState(() {
        articleTileList = _redrawList(
            widget.widgetServiceState.currentSelectedTypeArticle.value);
      });
    });

    // Ce listener écoute le bouton de favoris. Il permet de
    widget.widgetServiceState.favoriteAddition.addListener(() {
      log.config("favoriteAddition.listener() -"
          " Redraw tiles list because the"
          " favorite button has been triggered");
      setState(() {
        List<ArticleTileWidget> newList = articleTileList..sort((e1, e2) =>
            e1.currentArticle.compareTo(e2.currentArticle));
        articleTileList = newList;
      });
    });

    // Ce listener écoute le bouton de favoris. Il permet de
    widget.widgetServiceState.triggerListUpdate.addListener(() {
      log.config("triggerListUpdate.listener() -"
          " Redraw tiles list because an Article has been added or remove");
      setState(() {
        articleTileList = _redrawList(
            widget.widgetServiceState.currentSelectedTypeArticle.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> completeArticleTileList = [];
    completeArticleTileList.addAll(articleTileList);
    completeArticleTileList.add(ArticleCreationWidget());
    return Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
      children: completeArticleTileList,
    )));
  }
}
