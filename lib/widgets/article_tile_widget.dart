import 'package:flutter/material.dart';
import 'package:foodstock/domain/model/enumerate/article_tile_state_enum.dart';
import 'package:foodstock/widgets/article_creation/article_creation_dialog.dart';
import 'package:foodstock/widgets/article_update_tile/article_update_tile.dart';
import 'package:foodstock/service/data_provider.dart';
import 'package:foodstock/service/widget_service_state.dart';
import 'package:foodstock/widgets/article_remove/article_remove_dialog.dart';
import 'package:logging/logging.dart';

import '../domain/model/article.dart';
import '../service/data_manager.dart';
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
    FocusManager.instance.primaryFocus?.unfocus();
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
        log.info("_selectRightTile() - Selection de la tuile"
            " <$ArticleTileState.UPDATE_ARTICLE> pour"
            " l'article <$currentArticle>"
            " ainsi que la disponibilité des boutons de suppression/modification à False");
      }
    });
  }

  List<Color> _selectColorDependingOnState(ArticleTileState articleTileState) {
    if(widget.currentArticle.estFavoris &&
        articleTileState == ArticleTileState.READ_ARTICLE) {
      return const [Color(0xFFDBD262), Color(0xFFE0AA3E), Color(0xFFFFD66A), Color(0xFFB88A44)];
    } else {
      return const [Color(0xFFE9E9E9), Color(0xFFE9E9E9)];
    }
  }

  @override
  void initState() {
    super.initState();
    log.config("initState() - Initialisation de la tuile pour l'article : " +
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
                if (details.delta.dx > 3) {
                  currentArticle.isInRemovingState.value = false;
                }
                // Swiping in left direction.
                if (details.delta.dx < -3) {
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
                    log.config("build() - Affichage de la tuile dans l'état <$value>"
                        " pour l'article <$currentArticle>");
                    return AnimatedContainer(
                        curve: Curves.linear,
                        height: 90,
                        margin: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: _selectColorDependingOnState(value)
                            ),
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
          builder: (context, removingState, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    _modifyOrRemoveArticleWidget(
                        _updateArticle,
                        [const Color(0xFFF3CF88), const Color(0xFFFF844E)],
                        Icons.edit, 0),
                    _modifyOrRemoveArticleWidget(
                        _removeArticle,
                        [const Color(0xFFF38888), const Color(0xFFFF4E4E)],
                        Icons.delete, 5)
              ],
            );
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

  Future<void> _removeArticle() {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ArticleRemoveDialog(currentArticle: widget.currentArticle);
        });
  }

  Future<void> _updateArticle() {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return ArticleCreationDialog(widget.currentArticle);
        });
  }

  Widget _modifyOrRemoveArticleWidget(VoidCallback actionOnTap,
      List<Color> colorGradient, IconData iconToDisplay, double topMargin) {
    return GestureDetector(
        onTap: actionOnTap,
        child: AnimatedContainer(
          curve: Curves.ease,
          height: 40,
          width: computeRemovingState(widget.currentArticle.isInRemovingState.value),
          child: Icon(iconToDisplay, color: Colors.white),
          margin: EdgeInsets.fromLTRB(0, topMargin, 5, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
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
                colors: colorGradient),
          ),
          duration: const Duration(milliseconds: 300),
        ));
  }
}
