import 'package:flutter/material.dart';

import '../../domain/article.dart';

class ArticleFavoriteButtonWidget extends StatelessWidget {


  final Article currentArticle;

  const ArticleFavoriteButtonWidget({
    super.key,
    required this.currentArticle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 7.5, 0),
      height: 70,
      width: 70,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFA795), Color(0xFFFBC3B8)]),
          shape: BoxShape.circle),
      child: const Icon(Icons.star_rounded,
          size: 50, color: Colors.white),
    );
  }


}