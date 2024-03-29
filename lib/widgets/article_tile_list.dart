import 'package:flutter/cupertino.dart';
import 'package:foodstock/domain/model/comparator/article_comparator.dart';
import 'package:foodstock/domain/model/enumerate/inventory_mode.dart';
import 'package:foodstock/widgets/article_creation/article_creation_widget.dart';
import 'package:logging/logging.dart';

import '../domain/model/article.dart';
import '../domain/model/constants/ui_constants.dart' as UiConstants;
import '../service/data_manager.dart';
import '../service/data_provider.dart';
import '../domain/model/type_article.dart';
import '../service/widget_service_state.dart';
import 'article_tile_widget.dart';

class ArticleTileListWidget extends StatefulWidget {
  final DataProviderService dataProviderService = DataProviderService();
  final DataManagerService dataManagerService = DataManagerService();
  final WidgetServiceState widgetServiceState = WidgetServiceState();
  final ArticleComparator articleComparator = ArticleComparator();

  ArticleTileListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ArticleTileList();
}

class _ArticleTileList extends State<ArticleTileListWidget> {
  final log = Logger('ArticleTileListWidget');

  ScrollController _scrollController = ScrollController();

  List<ArticleTileWidget> articleTileList = [];

  List<ArticleTileWidget> _redrawList(TypeArticle? typeArticle) {
    articleTileList.clear();
    List<ArticleTileWidget> newUnorderedArticleTileList = [];
    if (widget.widgetServiceState.isSearchModeActivated.value) {
      if (widget.widgetServiceState.currentResearchContent.value != "") {
        var currentResearchContent =
            widget.widgetServiceState.currentResearchContent.value;
        for (Article article in widget.dataProviderService.articleMap.values) {
          if (article.labelArticle.contains(currentResearchContent)) {
            _addArticleDependingOnInventoryMode(
                article, newUnorderedArticleTileList);
          }
        }
      } else {
        log.config("_redrawList() - Affichage de toutes les tuiles du panier"
            " en mode recherche lorsqu'aucune saisie n'est entrée");
        if (widget.widgetServiceState.currentInventoryMode.value ==
            InventoryMode.CART_MODE) {
          for (Article article
              in widget.dataProviderService.articleMap.values) {
            if (article.isInCart) {
              newUnorderedArticleTileList
                  .add(ArticleTileWidget(currentArticle: article));
            }
          }
        }
      }
    } else {
      if (typeArticle != null) {
        for (Article article in widget.dataProviderService.articleMap.values) {
          if (article.typeArticle.pkTypeArticle == typeArticle.pkTypeArticle) {
            _addArticleDependingOnInventoryMode(
                article, newUnorderedArticleTileList);
          }
        }
      }
    }
    List<ArticleTileWidget> newList = newUnorderedArticleTileList
      ..sort((e1, e2) => widget.articleComparator
          .compareTwoArticle(e1.currentArticle, e2.currentArticle));
    return newList;
  }

  _addArticleDependingOnInventoryMode(
      Article article, List<ArticleTileWidget> newUnorderedArticleTileList) {
    if (widget.widgetServiceState.currentInventoryMode.value ==
        InventoryMode.CART_MODE) {
      if (article.isInCart) {
        newUnorderedArticleTileList
            .add(ArticleTileWidget(currentArticle: article));
      }
    } else {
      newUnorderedArticleTileList
          .add(ArticleTileWidget(currentArticle: article));
    }
  }

  @override
  void initState() {
    super.initState();
    articleTileList =
        _redrawList(widget.widgetServiceState.currentSelectedTypeArticle.value);

    // Ce listener permet de remettre les tuiles dans leur état initiale
    // dans le cas où certaines étaient en état de modification.
    widget.widgetServiceState.currentSelectedTypeArticle.addListener(() {
      log.config("currentSelectedTypeArticle.listener() -"
          " Regénération des tuiles puisque le "
          " type d'article courant a changé");
      setState(() {
        articleTileList = _redrawList(
            widget.widgetServiceState.currentSelectedTypeArticle.value);
        _scrollArticleTileListUp();
      });
    });

    // Ce listener écoute le bouton de favoris. Il permet de
    widget.widgetServiceState.favoriteAddition.addListener(() {
      log.config("favoriteAddition.listener() -"
          " Regénération des tuiles puisque le bouton favoris a été pressé");
      setState(() {
        List<ArticleTileWidget> newList = articleTileList
          ..sort((e1, e2) => widget.articleComparator
              .compareTwoArticle(e1.currentArticle, e2.currentArticle));
        articleTileList = newList;
      });
    });

    // Ce listener écoute le bouton de favoris. Il permet de
    widget.widgetServiceState.currentInventoryMode.addListener(() {
      InventoryMode inventoryMode =
          widget.widgetServiceState.currentInventoryMode.value;
      log.config("currentInventoryMode.listener() -"
          " Changement de type d'inventaire, regénération des tuiles."
          " L'inventaire maintenant affiché est du type "
          "<$inventoryMode>");
      setState(() {
        articleTileList = _redrawList(
            widget.widgetServiceState.currentSelectedTypeArticle.value);
        _scrollArticleTileListUp();
      });
    });

    // Ce listener écoute le bouton de favoris. Il permet de
    widget.widgetServiceState.cartAddition.addListener(() {
      InventoryMode inventoryMode =
          widget.widgetServiceState.currentInventoryMode.value;
      if (InventoryMode.CART_MODE == inventoryMode) {
        log.config("cartAddition.listener() -"
            " Suppresion d'un article du panier en mode d'inventaire $inventoryMode"
            ", regénération de la liste.");
        setState(() {
          articleTileList = _redrawList(
              widget.widgetServiceState.currentSelectedTypeArticle.value);
        });
      }
    });

    // Ce listener écoute le bouton de favoris.
    widget.widgetServiceState.triggerListUpdate.addListener(() {
      log.config("triggerListUpdate.listener() -"
          " Regénération des tuiles puisqu'un article a été supprimé ou ajouté");
      setState(() {
        articleTileList = _redrawList(
            widget.widgetServiceState.currentSelectedTypeArticle.value);
      });
    });

    // Ce listener écoute l'état d'activation du mode de recherche.
    widget.widgetServiceState.isSearchModeActivated.addListener(() {
      log.config("isSearchModeActivated.listener() -"
          " Regénération des tuiles puisque le mode de recherche a été modifié");
      setState(() {
        articleTileList = _redrawList(
            widget.widgetServiceState.currentSelectedTypeArticle.value);
        _scrollArticleTileListUp();
      });
    });
  }

  _scrollArticleTileListUp() {
    log.config("_scrollArticleTileListUp -"
        " La liste d'article est automatiquement scrollée vers le haut");
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> completeArticleTileList = [];
    completeArticleTileList.addAll(articleTileList);
    if (widget.widgetServiceState.currentInventoryMode.value ==
        InventoryMode.STOCK_MODE) {
      completeArticleTileList.add(ArticleCreationWidget());
    }
    completeArticleTileList
        .add(Container(height: UiConstants.INVENTORY_MENU_HEIGHT));

    return Expanded(
        child: Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: SingleChildScrollView(
              controller: _scrollController,
                child: Column(
              children: completeArticleTileList,
            ))));
  }
}
