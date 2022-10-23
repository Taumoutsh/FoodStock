import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';
import 'package:inventaire_m_et_t/widgets/article_left_side_widget.dart';
import 'package:inventaire_m_et_t/widgets/article_right_side_widget.dart';
import 'package:inventaire_m_et_t/widgets/article_tile_separator.dart';
import 'package:inventaire_m_et_t/widgets/article_tile_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  DataProviderService dataProviderService = DataProviderService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: dataProviderService.refreshValuesFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> articleTileArray = [];
            for (Article article in dataProviderService.articleMap.values) {
              articleTileArray.add(ArticleTile(currentArticle: article));
            }
            return MaterialApp(
                title: 'Welcome to Flutter',
                home: Scaffold(
                  persistentFooterButtons: [],
                  appBar: AppBar(
                    title: const Text('Welcome to Flutter'),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: articleTileArray,
                    ),
                  ),
                  extendBody: true,
                  //bottomNavigationBar: TypeArticleListViewWidget(),
                ));
          } else {
            return Container(
              color: Colors.white,
              child:
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Database loading in progress...",
                        style: TextStyle(color: Colors.black),
                        textDirection: TextDirection.ltr),
                      Container(
                         height: 20,
                      ),
                      const CircularProgressIndicator(),
                    ]
                )
              ),
            );
          }
        });
  }
}











