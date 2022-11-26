import 'package:flutter/cupertino.dart';
import 'package:foodstock/service/data_provider.dart';
import 'package:foodstock/domain/model/type_article.dart';
import 'package:foodstock/service/widget_service_state.dart';
import 'menu_widget.dart';

class MainMenuBarWidget extends StatelessWidget {

  final bool isResizable;

  MainMenuBarWidget({super.key, required this.isResizable});

  final DataProviderService dataProviderService = DataProviderService();

  final WidgetServiceState widgetServiceState = WidgetServiceState();

  @override
  Widget build(BuildContext context) {
    List<MenuWidget> menuWidgetList = [];
    for (TypeArticle typeArticle in dataProviderService.typeArticleMap.values) {
      menuWidgetList.add(MenuWidget(typeArticle: typeArticle));
    }
    return ValueListenableBuilder<bool>(
        valueListenable: widgetServiceState.isSearchModeActivated,
        builder: (context, value, child) {
          return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.linearToEaseOut,
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              clipBehavior: Clip.antiAlias,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFCFCDCD),
                  boxShadow: _computeShadowDependingOnValue(value)),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: menuWidgetList,
                  )));
        });
  }

  List<BoxShadow>? _computeShadowDependingOnValue(bool isSearchMode) {
    if (isSearchMode && isResizable) {
      return [];
    } else {
      return const [
        BoxShadow(
            color: Color(0x66000000),
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 4))
      ];
    }
  }
}
