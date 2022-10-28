import 'package:flutter/cupertino.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';
import 'package:inventaire_m_et_t/domain/type_article.dart';

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
            margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: const Border.fromBorderSide(BorderSide(
                    color: Color(0xFFCBCBCB), width: 1)),
                color: Color(0xFFE9E9E9),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 4))
                ]),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.hardEdge,
                child: Row(
                  children: menuWidgetList,
                ))));
  }

}