import 'package:flutter/widgets.dart';

import '../../domain/article.dart';
import '../../domain/data_provider.dart';

class ArticleCountContainer extends StatelessWidget {
  final DataProviderService dataProviderService = DataProviderService();

  final Article currentArticle;

  ArticleCountContainer({super.key, required this.currentArticle});

  @override
  Widget build(BuildContext context) {

    int currentArticleNumber = dataProviderService
        .getNumberOfAvailableArticleInInventory(currentArticle);

    return Container(
      alignment: Alignment.center,
      width: 60.0,
      constraints: const BoxConstraints(
          maxHeight: double.infinity),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: getCountBackgroundColor(currentArticleNumber),
          boxShadow: const [
            BoxShadow(
                color: Color(0x336B6B6B),
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(0, 2))
          ]),
      child: Text(
        currentArticleNumber.toString(),
        style: const TextStyle(
            color: Color(0xFF303030),
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontFamily: "Segue UI"),
        textAlign: TextAlign.center,
      ), //Quantité
    );
  }

  Color getCountBackgroundColor(int currentArticleNumber) {
    Color colorToReturn;
    if(currentArticleNumber > 2) {
      colorToReturn = const Color(0x7049AC57);
    } else if(currentArticleNumber > 1) {
      colorToReturn = Color(0x70EBA131);
    } else if(currentArticleNumber > 0) {
      colorToReturn = Color(0x70F16060);
    } else {
      colorToReturn = Color(0x70958E8E);
    }
    return colorToReturn;
  }
}