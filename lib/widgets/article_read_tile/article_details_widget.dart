import 'package:flutter/material.dart';
import 'package:foodstock/domain/model/article.dart';


class ArticleDetailsWidget extends StatelessWidget {
  final Article currentArticle;

  const ArticleDetailsWidget({super.key, required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    return Expanded(child:
        Container(
            constraints: const BoxConstraints(minWidth: 200),
            child:
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          // Colonne du nom de l'article et de la quantité
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(currentArticle.labelArticle,
              style: const TextStyle(
                  fontSize: 16,
                  letterSpacing: 0)),
              Container(margin: EdgeInsets.all(2)),
              getFavoriteWidget()
            ],
          )// DLUO
        ]))
    );
  }

  Widget getFavoriteWidget() {
    Widget widgetToReturn;
    if (currentArticle.estFavoris) {
      widgetToReturn = const Icon(
        Icons.favorite_rounded,
        color: Color(0xFFFF147A),
        size: 18,
      );
    } else {
      widgetToReturn = Container();
    }
    return widgetToReturn;
  }
}
