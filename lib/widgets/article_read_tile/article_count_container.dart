import 'package:flutter/widgets.dart';

import '../../domain/model/article.dart';
import '../../service/data_provider.dart';

class ArticleCountContainer extends StatelessWidget {
  final DataProviderService dataProviderService = DataProviderService();

  final Article currentArticle;

  ArticleCountContainer({super.key, required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: dataProviderService
            .availableArticlesCount[currentArticle.pkArticle]!,
        builder: (context, value, child) {
          return Container(
              alignment: Alignment.center,
              width: 60.0,
              constraints: const BoxConstraints(maxHeight: double.infinity),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: getCountBackgroundColor(value),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x336B6B6B),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 2))
                  ]),
              child: Text(
                value.toString(),
                style: const TextStyle(
                    color: Color(0xFF303030),
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    fontFamily: ".AppleSystemUIFont",
                    letterSpacing: 0),
                textAlign: TextAlign.center,
              ));
        }); //Quantité
  }

  Color getCountBackgroundColor(int currentArticleNumber) {
    Color colorToReturn;
    if (currentArticleNumber > currentArticle.quantiteAlerte) {
      colorToReturn = const Color(0x7049AC57);
    } else if (currentArticleNumber >  currentArticle.quantiteCritique) {
      colorToReturn = Color(0x70EBA131);
    } else if (currentArticleNumber > 0) {
      colorToReturn = Color(0x70F16060);
    } else {
      colorToReturn = Color(0x70958E8E);
    }
    return colorToReturn;
  }
}
