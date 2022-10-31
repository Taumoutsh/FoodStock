import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventaire_m_et_t/domain/article_tile_state_enum.dart';
import 'package:inventaire_m_et_t/domain/article_update_tile.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';
import 'package:inventaire_m_et_t/service/widget_service_state.dart';
import 'package:inventaire_m_et_t/widgets/article_remove/article_remove_dialog.dart';
import 'package:logging/logging.dart';

import '../domain/article.dart';
import '../domain/data_manager.dart';
import 'article_read_tile/article_left_side_widget.dart';
import 'article_read_tile/article_right_side_widget.dart';
import 'article_read_tile/article_tile_separator.dart';

class ArticleTile extends StatefulWidget {
  final Article currentArticle;

  const ArticleTile({super.key, required this.currentArticle});

  @override
  State<ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
  final log = Logger('_ArticleTileState');

  double currentWidth = double.infinity;

  WidgetServiceState widgetServiceState = WidgetServiceState();

  DataProviderService dataProviderService = DataProviderService();

  DataManagerService dataManagerService = DataManagerService();

  @override
  void dispose() {
    log.info("dispose() - Dispose of : " +
        widget.currentArticle.labelArticle +
        " tile");
    super.dispose();
  }

  _selectRightTile() {
    setState(() {
      if (widget.currentArticle.articleTileState.value ==
          ArticleTileState.UPDATE_ARTICLE) {
        if (widgetServiceState.currentUpdatedArticle != null &&
            widgetServiceState.currentUpdatedArticle!.pkArticle ==
                widget.currentArticle.pkArticle) {
          widgetServiceState.currentUpdatedArticle = null;
        }
        widget.currentArticle.articleTileState.value =
            ArticleTileState.READ_ARTICLE;
      } else {
        final previousUpdatedArticle = widgetServiceState.currentUpdatedArticle;
        if (previousUpdatedArticle != null) {
          previousUpdatedArticle.articleTileState.value =
              ArticleTileState.READ_ARTICLE;
        }
        widgetServiceState.currentUpdatedArticle = widget.currentArticle;
        widget.currentArticle.articleTileState.value =
            ArticleTileState.UPDATE_ARTICLE;
        widget.currentArticle.isInRemovingState.value = false;
      }
    });
  }

  @override
  void initState() {
    log.info("initState() - Initialisation of the widget tile of Article : " +
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
                if (details.delta.dx > 0) {
                  widget.currentArticle.isInRemovingState.value = false;
                }
                // Swiping in left direction.
                if (details.delta.dx < 0) {
                  if (ArticleTileState.READ_ARTICLE ==
                      widget.currentArticle.articleTileState.value) {
                    widget.currentArticle.isInRemovingState.value = true;
                  }
                }
              },
              child: ValueListenableBuilder<ArticleTileState>(
                  valueListenable: widget.currentArticle.articleTileState,
                  builder: (context, value, child) {
                    return AnimatedContainer(
                        curve: Curves.linear,
                        height: returnDynamicTileHeight(value),
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
                        duration: Duration(milliseconds: 100),
                        child: Row(
                          children: getArticleTileContentByState(value),
                        ));
                  }))),
      ValueListenableBuilder<bool>(
          valueListenable: widget.currentArticle.isInRemovingState,
          builder: (context, value, child) {
            return GestureDetector(
                onTap: _removeArticle,
                child: AnimatedContainer(
                  clipBehavior: Clip.hardEdge,
                  alignment: Alignment.center,
                  curve: Curves.ease,
                  height: 90,
                  width: computeRemovingState(value),
                  child: Icon(Icons.delete, color: Colors.white),
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0, 4))
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFF38888), Color(0xFFFF4E4E)]),
                  ),
                  duration: Duration(milliseconds: 300),
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
