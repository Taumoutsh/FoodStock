import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/data_manager.dart';

import '../../domain/article.dart';

class ArticleFavoriteButtonWidget extends StatelessWidget {
  final DataManagerService dataManagerService = DataManagerService();

  final Article currentArticle;

  ArticleFavoriteButtonWidget({super.key, required this.currentArticle});

  _updateFavoriteStatus() {
    dataManagerService.updateArticleFavorite(currentArticle);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _updateFavoriteStatus,
        child: Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 7.5, 0),
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFA795), Color(0xFFFBC3B8)]),
              shape: BoxShape.circle),
          child: getIconStyle(),
        ));
  }

  getIconStyle() {
    Icon iconToReturn;
    if(!currentArticle.estFavoris) {
      iconToReturn = Icon(Icons.star_rounded, size: 50, color: Colors.white);
    } else {
      iconToReturn = Icon(Icons.star_border_rounded, size: 50, color: Colors.white);
    }
    return iconToReturn;
  }
}
