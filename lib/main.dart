import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/data_manager.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';
import 'package:inventaire_m_et_t/service/widget_service_state.dart';
import 'package:inventaire_m_et_t/widgets/article_creation/article_creation.dart';
import 'package:inventaire_m_et_t/widgets/article_tile_list.dart';
import 'package:inventaire_m_et_t/widgets/menu_widget/main_menu_bar_widget.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  DataProviderService dataProviderService = DataProviderService();
  DataManagerService dataManagerService = DataManagerService();
  WidgetServiceState widgetServiceState = WidgetServiceState();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: dataManagerService.refreshValuesFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            widgetServiceState.currentSelectedTypeArticle.value =
                dataProviderService.typeArticleMap.values.first;
            return MaterialApp(
                title: 'Welcome to Flutter',
                home: Scaffold(
                  persistentFooterButtons: [],
                  body: Column(children: [
                    ArticleTileListWidget(),
                    Flex(
                      direction: Axis.horizontal,
                      children: [MainMenuBarWidget()],
                    )
                  ]),
                  floatingActionButton: ArticleCreationButton(),
                  //bottomNavigationBar: TypeArticleListViewWidget(),
                ));
          } else {
            return LoadingWidget();
          }
        });
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          ]),
    );
  }
}
