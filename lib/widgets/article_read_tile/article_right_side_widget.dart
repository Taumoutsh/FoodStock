import 'package:flutter/material.dart';

import '../../domain/model/article.dart';
import 'article_count_container.dart';
import 'article_details_widget.dart';

class ArticleRightSideTile extends StatefulWidget {

  final Article currentArticle;

  const ArticleRightSideTile({super.key, required this.currentArticle});

  @override
  State<StatefulWidget> createState() => _ArticleRightSideTile();

}

class _ArticleRightSideTile extends State<ArticleRightSideTile> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: ValueListenableBuilder<bool>(
              valueListenable: widget.currentArticle.isInRemovingState,
              builder: (context, value, child) {
                return Container(
                    margin: const EdgeInsets.all(7),
                    child: Row(
                      children: _computeWidgetList(value)
                    ));
              }
            )
            ));
  }

  List<Widget> _computeWidgetList(bool isInRemovingState) {
    List<Widget> listWidget =
    [ArticleDetailsWidget(currentArticle: widget.currentArticle)];
    if(!isInRemovingState) {
      listWidget.add(ArticleCountContainer(currentArticle: widget.currentArticle));
    }
    return listWidget;
  }

}