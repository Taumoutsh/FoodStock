import 'package:flutter/material.dart';

import '../domain/article.dart';
import 'article_count_container.dart';
import 'article_details_widget.dart';

class ArticleRightSideTile extends StatelessWidget {
  final Article currentArticle;

  const ArticleRightSideTile({super.key, required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Container(
                margin: EdgeInsets.all(7),
                child: Row(
                  children: [
                    ArticleDetailsWidget(currentArticle: currentArticle),
                    ArticleCountContainer(currentArticle: currentArticle),
                  ],
                ))));
  }
}