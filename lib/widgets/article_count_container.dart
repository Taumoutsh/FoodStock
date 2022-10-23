import 'package:flutter/widgets.dart';

import '../domain/article.dart';
import '../domain/data_provider.dart';

class ArticleCountContainer extends StatelessWidget {
  final DataProviderService dataProviderService = DataProviderService();

  final Article currentArticle;

  ArticleCountContainer({super.key, required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 90.0,
      constraints: const BoxConstraints(
          maxHeight: double.infinity),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0x7049AC57)),
      child: Text(
        dataProviderService
            .getNumberOfAvailableArticleInInventory(currentArticle)
            .toString(),
        style: const TextStyle(
            color: Color(0xFF303030),
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontFamily: "Segue UI"),
        textAlign: TextAlign.center,
      ), //Quantité
    );
  }
}