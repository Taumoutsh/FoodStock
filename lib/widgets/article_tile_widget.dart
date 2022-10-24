import 'package:flutter/widgets.dart';
import 'package:inventaire_m_et_t/domain/article_tile_state_enum.dart';
import 'package:inventaire_m_et_t/domain/article_update_tile.dart';

import '../domain/article.dart';
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

  ArticleTileState articleTileState = ArticleTileState.READ_ARTICLE;

  _selectRightTile() {
    setState(() {
      if(articleTileState == ArticleTileState.UPDATE_ARTICLE) {
        articleTileState = ArticleTileState.READ_ARTICLE;
      } else {
        articleTileState = ArticleTileState.UPDATE_ARTICLE;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectRightTile,
      child: Container(
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
          child: Row(
            children: getArticleTileContentByState(articleTileState),
          )
      ),
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
