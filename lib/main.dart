import 'dart:core';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodstock/domain/model/enumerate/database_source.dart';
import 'package:foodstock/service/application_start_service.dart';
import 'package:foodstock/service/data_manager.dart';
import 'package:foodstock/service/data_provider.dart';
import 'package:foodstock/service/widget_service_state.dart';
import 'package:foodstock/theme/theme_notifier.dart';

import 'package:foodstock/widgets/article_tile_list.dart';
import 'package:foodstock/widgets/inventory_mode/inventory_mode_menu.dart';
import 'package:foodstock/widgets/menu_widget/main_menu_bar_widget.dart';
import 'package:foodstock/widgets/search_widget/search_widget.dart';
import 'package:logging/logging.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

final log = Logger('Main');

void main() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  ApplicationStartMonitor applicationStartService = ApplicationStartMonitor();
  DataProviderService dataProviderService = DataProviderService();
  DataManagerService dataManagerService = DataManagerService();
  WidgetServiceState widgetServiceState = WidgetServiceState();
  ThemeNotifier themeNotifier = ThemeNotifier();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: dataManagerService
            .refreshValuesFromDatabase(DatabaseSource.FIREBASE_DATABASE),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            widgetServiceState.currentSelectedTypeArticle.value =
                dataProviderService.typeArticleMap.values.first;
            return
              ValueListenableBuilder(valueListenable: themeNotifier.currentTheme, builder:
              (context, value, widget) => MaterialApp(
                  title: "FoodStock",
                  theme: themeNotifier.getCurrentTheme(),
                  home: Scaffold(
                      body: GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Stack(children: <Widget>[
                            Column(children: [
                              Row(children: [
                                Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        10, 35, 5, 0),
                                    child: const SearchWidget()),
                                Expanded(
                                    child: Container(
                                      margin:
                                      const EdgeInsets.fromLTRB(0, 35, 5, 0),
                                      child: MainMenuBarWidget(isResizable: true),
                                    ))
                              ]),
                              ArticleTileListWidget(),
                            ]),
                            const Align(
                                alignment: Alignment.bottomRight,
                                child: InventoryModeMenuWidget())
                          ]))
                    //bottomNavigationBar: TypeArticleListViewWidget(),
                  )));

          } else {
            return const LoadingWidget();
          }
        });
  }
}

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<StatefulWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  DataManagerService dataManagerService = DataManagerService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              height: 200,
              width: 200,
              clipBehavior: Clip.antiAlias,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(40)),
              child:
                  const Image(image: AssetImage('assets/images/foodstock.png')),
            ),
            Container(
              height: 20,
            ),
            Directionality(
                textDirection: TextDirection.rtl,
                child: ValueListenableBuilder<int>(
                    valueListenable: dataManagerService.loadingPercent,
                    builder: (context, loadingValue, child) {
                      var percentage = loadingValue / 100;
                      return CircularPercentIndicator(
                        percent: percentage,
                        progressColor: const Color(0xFFF1730E),
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          (loadingValue).toString() + "%",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        radius: 35,
                      );
                    })),
          ]),
    );
  }
}
