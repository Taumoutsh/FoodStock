import 'package:flutter/cupertino.dart';
import 'package:foodstock/service/data_provider.dart';
import 'package:foodstock/domain/model/type_article.dart';

import 'menu_widget.dart';

class MainMenuBarWidget extends StatelessWidget {
  MainMenuBarWidget({super.key});

  final DataProviderService dataProviderService = DataProviderService();

  @override
  Widget build(BuildContext context) {
    List<MenuWidget> menuWidgetList = [];
    for (TypeArticle typeArticle in dataProviderService.typeArticleMap.values) {
      menuWidgetList.add(MenuWidget(typeArticle: typeArticle));
    }
    return Expanded(
        child: Container(
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            clipBehavior: Clip.antiAlias,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFCFCDCD),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x66000000),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 4))
                ]),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: menuWidgetList,
                ))));
  }
}
