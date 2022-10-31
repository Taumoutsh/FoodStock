import 'package:flutter/material.dart';

import '../widgets/article_update_tile/article_favorite_button_widget.dart';
import '../widgets/article_update_tile/article_quantity_updater_widget.dart';
import '../widgets/article_update_tile/article_valid_button_widget.dart';
import 'article.dart';

class ArticleUpdateTile extends StatelessWidget {

  final Article currentArticle;

  const ArticleUpdateTile({
    super.key,
    required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
            child: Row(textDirection: TextDirection.ltr, children: [
              ArticleQuantityUpdaterWidget(currentArticle: currentArticle),
              ArticleFavoriteButtonWidget(currentArticle: currentArticle),
              ArticleValidButtonWidget(currentArticle: currentArticle)
            ])));
  }
}
