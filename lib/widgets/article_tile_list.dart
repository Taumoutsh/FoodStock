import 'package:flutter/cupertino.dart';
import 'package:foodstock/domain/model/comparator/article_comparator.dart';
import 'package:foodstock/domain/model/enumerate/article_tile_state_enum.dart';
import 'package:foodstock/widgets/article_creation/article_creation_widget.dart';
import 'package:logging/logging.dart';

import '../domain/model/article.dart';
import '../service/data_manager.dart';
import '../service/data_provider.dart';
import '../domain/model/type_article.dart';
import '../service/widget_service_state.dart';
import 'article_tile_widget.dart';


class ArticleTileListWidget extends StatefulWidget {
  DataProviderService dataProviderService = DataProviderService();
  DataManagerService dataManagerService = DataManagerService();
  WidgetServiceState widgetServiceState = WidgetServiceState();
  ArticleComparator articleComparator = ArticleComparator();

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
    if(widget.widgetServiceState.isSearchModeActivated.value) {
      if(widget.widgetServiceState.currentResearchContent.value != "") {
        var currentResearchContent =
            widget.widgetServiceState.currentResearchContent.value;
        for (Article article in widget.dataProviderService.articleMap.values) {
          if (article.labelArticle.contains(currentResearchContent)) {
            newUnorderedArticleTileList
                .add(ArticleTileWidget(currentArticle: article));
          }
        }
      }
    } else {
      if (typeArticle != null) {
        for (Article article in widget.dataProviderService.articleMap.values) {
          if (article.typeArticle.pkTypeArticle == typeArticle.pkTypeArticle) {
            newUnorderedArticleTileList
                .add(ArticleTileWidget(currentArticle: article));
          }
        }
      }
    }
    List<ArticleTileWidget> newList = newUnorderedArticleTileList
      ..sort((e1, e2) => widget.articleComparator
          .compareTwoArticle(e1.currentArticle, e2.currentArticle));
    return newList;
  }

  @override
  void initState() {
    super.initState();
    articleTileList =
        _redrawList(widget.widgetServiceState.currentSelectedTypeArticle.value);

    // Ce listener permet de remettre les tuiles dans leur ??tat initiale
    // dans le cas o?? certaines ??taient en ??tat de modification.
    widget.widgetServiceState.currentSelectedTypeArticle.addListener(() {
      log.config("currentSelectedTypeArticle.listener() -"
          " Reg??n??ration des tuiles puisque le "
          " type d'article courant a chang??");
      setState(() {
        articleTileList = _redrawList(
            widget.widgetServiceState.currentSelectedTypeArticle.value);
      });
    });

    // Ce listener ??coute le bouton de favoris. Il permet de
    widget.widgetServiceState.favoriteAddition.addListener(() {
      log.config("favoriteAddition.listener() -"
          " Reg??n??ration des tuiles puisque le bouton favoris a ??t?? press??");
      setState(() {
        List<ArticleTileWidget> newList = articleTileList
          ..sort((e1, e2) => widget.articleComparator
              .compareTwoArticle(e1.currentArticle, e2.currentArticle));
        articleTileList = newList;
      });
    });

    // Ce listener ??coute le bouton de favoris. Il permet de
    widget.widgetServiceState.triggerListUpdate.addListener(() {
      log.config("triggerListUpdate.listener() -"
          " Reg??n??ration des tuiles puisqu'un article a ??t?? supprim?? ou ajout??");
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
        child: Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: completeArticleTileList,
                ))));
  }
}
