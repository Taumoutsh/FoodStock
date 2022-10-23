import 'package:flutter/widgets.dart';

import '../domain/article.dart';
import 'article_left_side_widget.dart';
import 'article_right_side_widget.dart';
import 'article_tile_separator.dart';

class ArticleTile extends StatelessWidget {
  final Article currentArticle;

  const ArticleTile({super.key, required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: EdgeInsets.fromLTRB(10, 7, 10, 7),
      decoration: BoxDecoration(
          color: Color(0xFFE9E9E9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Color(0x33000000),
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 4))
          ]),
      child: Row(
        children: [
          ArticleLeftSideTile(),
          const ArticleTileSeparator(),
          ArticleRightSideTile(currentArticle: currentArticle)
        ],
      ),
    );
  }
}