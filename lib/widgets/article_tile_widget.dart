import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inventaire_m_et_t/domain/article_tile_state_enum.dart';
import 'package:inventaire_m_et_t/domain/article_update_tile.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';
import 'package:inventaire_m_et_t/service/widget_service_state.dart';
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

  double currentHeight = 90;

  double removeButtonWidth = 0;

  double currentWidth = double.infinity;

  WidgetServiceState widgetServiceState = WidgetServiceState();

  DataProviderService dataProviderService = DataProviderService();

  DataManagerService dataManagerService = DataManagerService();


  @override
  void dispose() {
  log.info("dispose() - Dispose of : " + widget.currentArticle.labelArticle + " tile");
  widget.currentArticle.articleTileState.removeListener(() { });
  super.dispose();
  }


  _selectRightTile() {
    setState(() {
      if (widget.currentArticle.articleTileState.value == ArticleTileState.UPDATE_ARTICLE) {
        if(widgetServiceState.currentUpdatedArticle != null &&
            widgetServiceState.currentUpdatedArticle!.pkArticle ==
            widget.currentArticle.pkArticle) {
          widgetServiceState.currentUpdatedArticle = null;
        }
        widget.currentArticle.articleTileState.value = ArticleTileState.READ_ARTICLE;
      } else {
        final previousUpdatedArticle = widgetServiceState.currentUpdatedArticle;
        if (previousUpdatedArticle != null) {
          previousUpdatedArticle.articleTileState.value =
              ArticleTileState.READ_ARTICLE;
        }
        widgetServiceState.currentUpdatedArticle = widget.currentArticle;
        widget.currentArticle.articleTileState.value =
            ArticleTileState.UPDATE_ARTICLE;
      }
    });
  }

  _setTileStyle() {
    log.warning("Article : " + widget.currentArticle.labelArticle
        + ", état de tuile : " + widget.currentArticle.articleTileState.value.name);
    setState(() {
    if (widget.currentArticle.articleTileState.value ==
        ArticleTileState.UPDATE_ARTICLE) {
      currentHeight = 110;
    } else {
      removeButtonWidth = 0;
      currentHeight = 90;
    }
  });
  }

  _shrinkTile(double expectedSize) {
    setState(() {
      removeButtonWidth = expectedSize;
    });
  }

  @override
  void initState() {
    log.info("initState() - Initialisation of the widget tile of Article : " +
        widget.currentArticle.labelArticle);
    widget.currentArticle.articleTileState.addListener(() {
      _setTileStyle();
    });
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
                  _shrinkTile(0);
                }
                // Swiping in left direction.
                if (details.delta.dx < 0) {
                  if (ArticleTileState.READ_ARTICLE ==
                        widget.currentArticle.articleTileState.value) {
                    _shrinkTile(50);
                  }
                }
              },
              child: AnimatedContainer(
                  curve: Curves.linear,
                  height: currentHeight,
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
                    children: getArticleTileContentByState(
                        widget.currentArticle.articleTileState.value),
                  )))),
      AnimatedContainer(
        alignment: Alignment.center,
        curve: Curves.ease,
        height: currentHeight,
        width: removeButtonWidth,
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
      )
    ]);
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
          return [ArticleUpdateTile(currentArticle: widget.currentArticle)];
        }
      default:
        {
          return [];
        }
    }
  }
}
