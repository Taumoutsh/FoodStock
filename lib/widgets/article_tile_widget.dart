import 'package:flutter/material.dart';
import 'package:foodstock/domain/article_tile_state_enum.dart';
import 'package:foodstock/domain/article_update_tile.dart';
import 'package:foodstock/domain/data_provider.dart';
import 'package:foodstock/service/widget_service_state.dart';
import 'package:foodstock/widgets/article_remove/article_remove_dialog.dart';
import 'package:logging/logging.dart';

import '../domain/article.dart';
import '../domain/data_manager.dart';
import 'article_read_tile/article_left_side_widget.dart';
import 'article_read_tile/article_right_side_widget.dart';
import 'article_read_tile/article_tile_separator.dart';

class ArticleTileWidget extends StatefulWidget {
  final Article currentArticle;

  const ArticleTileWidget({super.key, required this.currentArticle});

  @override
  State<ArticleTileWidget> createState() => _ArticleTileWidgetState();
}

class _ArticleTileWidgetState extends State<ArticleTileWidget> {
  final log = Logger('ArticleTileWidget');

  double currentWidth = double.infinity;

  WidgetServiceState widgetServiceState = WidgetServiceState();

  DataProviderService dataProviderService = DataProviderService();

  DataManagerService dataManagerService = DataManagerService();

  @override
  void dispose() {
    log.config("dispose() - Dispose of : " +
        widget.currentArticle.labelArticle +
        " tile");
    super.dispose();
  }

  _selectRightTile() {
    setState(() {
      var currentArticle = widget.currentArticle;
      if (currentArticle.articleTileState.value ==
          ArticleTileState.UPDATE_ARTICLE) {
        if (widgetServiceState.currentUpdatedArticle != null &&
            widgetServiceState.currentUpdatedArticle!.pkArticle ==
                currentArticle.pkArticle) {
          widgetServiceState.currentUpdatedArticle = null;
        }
        currentArticle.articleTileState.value = ArticleTileState.READ_ARTICLE;
        log.config(
            "_selectRightTile() - Select <$ArticleTileState.READ_ARTICLE>"
            " tile for article <$currentArticle>");
      } else {
        final previousUpdatedArticle = widgetServiceState.currentUpdatedArticle;
        if (previousUpdatedArticle != null) {
          previousUpdatedArticle.articleTileState.value =
              ArticleTileState.READ_ARTICLE;
          log.config("_selectRightTile() -"
              " Tile reset to <$ArticleTileState.READ_ARTICLE>"
              " for previous article <$previousUpdatedArticle>");
        }
        widgetServiceState.currentUpdatedArticle = currentArticle;
        currentArticle.articleTileState.value = ArticleTileState.UPDATE_ARTICLE;
        currentArticle.isInRemovingState.value = false;
        log.info("_selectRightTile() - Select"
            " <$ArticleTileState.UPDATE_ARTICLE> tile for"
            " article <$currentArticle>"
            " and reset removing state to false");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    log.config("initState() - Initialisation of the widget tile of Article : " +
        widget.currentArticle.labelArticle);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: GestureDetector(
              onTap: _selectRightTile,
              onPanUpdate: (details) {
                // Swiping in right direction.
                var currentArticle = widget.currentArticle;
                if (details.delta.dx > 0) {
                  currentArticle.isInRemovingState.value = false;
                }
                // Swiping in left direction.
                if (details.delta.dx < 0) {
                  if (ArticleTileState.READ_ARTICLE ==
                      currentArticle.articleTileState.value) {
                    currentArticle.isInRemovingState.value = true;
                  }
                }
              },
              child: ValueListenableBuilder<ArticleTileState>(
                  valueListenable: widget.currentArticle.articleTileState,
                  builder: (context, value, child) {
                    Article currentArticle = widget.currentArticle;
                    log.config("build() - Display tile state <$value>"
                        " for article <$currentArticle>");
                    return AnimatedContainer(
                        curve: Curves.linear,
                        height: returnDynamicTileHeight(value),
                        margin: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE9E9E9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: Offset(0, 4))
                            ]),
                        duration: const Duration(milliseconds: 100),
                        child: Row(
                          children: getArticleTileContentByState(value),
                        ));
                  }))),
      ValueListenableBuilder<bool>(
          valueListenable: widget.currentArticle.isInRemovingState,
          builder: (context, value, child) {
            Article currentArticle = widget.currentArticle;
            log.config("build() - Display removal button <$value> for"
                " article <$currentArticle>");
            return GestureDetector(
                onTap: _removeArticle,
                child: AnimatedContainer(
                  clipBehavior: Clip.hardEdge,
                  alignment: Alignment.center,
                  curve: Curves.ease,
                  height: 90,
                  width: computeRemovingState(value),
                  child: const Icon(Icons.delete, color: Colors.white),
                  margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0, 4))
                    ],
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFF38888), Color(0xFFFF4E4E)]),
                  ),
                  duration: const Duration(milliseconds: 300),
                ));
          })
    ]);
  }

  double computeRemovingState(bool isInRemovingState) {
    double computedSize = 0;
    if (isInRemovingState) {
      computedSize = 50;
    }
    return computedSize;
  }

  double returnDynamicTileHeight(ArticleTileState state) {
    double dynamicHeight;
    if (state == ArticleTileState.UPDATE_ARTICLE) {
      dynamicHeight = 110;
    } else {
      dynamicHeight = 90;
    }
    return dynamicHeight;
  }

  List<Widget> getArticleTileContentByState(ArticleTileState state) {
    switch (state) {
      case ArticleTileState.READ_ARTICLE:
        {
          return [
            ArticleLeftSideTile(currentArticle: widget.currentArticle),
            const ArticleTileSeparator(),
            ArticleRightSideTile(currentArticle: widget.currentArticle)
          ];
        }
      case ArticleTileState.UPDATE_ARTICLE:
        {
          return [ArticleUpdateTile(currentArticle: widget.currentArticle)];
        }
      default:
        {
          return [];
        }
    }
  }

  _removeArticle() {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ArticleRemoveDialog(currentArticle: widget.currentArticle);
        });
  }
}
