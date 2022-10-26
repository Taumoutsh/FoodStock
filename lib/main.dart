import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/data_manager.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';
import 'package:inventaire_m_et_t/service/widget_service_state.dart';
import 'package:inventaire_m_et_t/widgets/article_tile_widget.dart';
import 'package:logging/logging.dart';



void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {

  List<Widget> articleTileList = [];

  DataProviderService dataProviderService = DataProviderService();
  DataManagerService dataManagerService = DataManagerService();
  WidgetServiceState widgetServiceState = WidgetServiceState();

   List<Widget> _redrawList() {
    List<Widget> newArticleTileList = [];
    for (Article article in dataProviderService.articleMap.values) {
      newArticleTileList.add(ArticleTile(currentArticle: article));
    }
    return newArticleTileList;
  }

  @override
  Widget build(BuildContext context) {
    dataManagerService.addListener(() {
      setState(() {
        dataManagerService.refreshArticleMapFromDatabase();
        widgetServiceState.currentUpdatedArticle = null;
        articleTileList = _redrawList();
      });
    });

    return FutureBuilder<bool>(
        future: dataManagerService.refreshValuesFromDatabase(),
        builder: (context, snapshot) {
          articleTileList = _redrawList();
          if (snapshot.hasData) {
            return MaterialApp(
                title: 'Welcome to Flutter',
                home: Scaffold(
                  persistentFooterButtons: [],
                  appBar: AppBar(
                    title: const Text('Welcome to Flutter'),
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: articleTileList,
                    ),
                  ),
                  extendBody: true,
                  //bottomNavigationBar: TypeArticleListViewWidget(),
                ));
          } else {
            return Container(
              color: Colors.white,
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
              ),
            );
          }
        });
  }

}










