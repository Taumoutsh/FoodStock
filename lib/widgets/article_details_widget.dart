import 'package:flutter/material.dart';

import '../domain/article.dart';

class ArticleDetailsWidget extends StatelessWidget {
  final Article currentArticle;

  const ArticleDetailsWidget({super.key, required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    DateTime date =
        DateTime.now().add(Duration(days: currentArticle.peremptionEnJours));
    String dateToPrint = date.day.toString().padLeft(2, '0') +
        "-" +
        date.month.toString().padLeft(2, '0') +
        "-" +
        date.year.toString();

    return Expanded(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          // Colonne du nom de l'article et de la quantité
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(currentArticle.labelArticle,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: "Segue UI")),
              getFavoriteWidget()
            ],
          ),
          // Nom de l'article
          Text("DLUO min : " + dateToPrint,
              style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  fontFamily: "Segue UI")) // DLUO
        ]));
  }

  Widget getFavoriteWidget() {
    Widget widgetToReturn;
    if (currentArticle.estFavoris) {
      widgetToReturn = const Icon(
        Icons.star,
        color: Color(0xFFFFA795),
        size: 18,
      );
    } else {
      widgetToReturn = Container();
    }
    return widgetToReturn;
  }
}
