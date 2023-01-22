import 'package:flutter/material.dart';
import 'package:foodstock/widgets/article_update_tile/article_cart_button_widget.dart';

import 'article_favorite_button_widget.dart';
import 'article_quantity_updater_widget.dart';
import 'article_valid_button_widget.dart';
import '../../domain/model/article.dart';

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
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(textDirection: TextDirection.ltr, children: [
              ArticleQuantityUpdaterWidget(currentArticle: currentArticle),
              ArticleCartButtonWidget(currentArticle: currentArticle),
              ArticleFavoriteButtonWidget(currentArticle: currentArticle),
              ArticleValidButtonWidget(currentArticle: currentArticle)
            ])));
  }
}
