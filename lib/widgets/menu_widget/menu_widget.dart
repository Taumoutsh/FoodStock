import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inventaire_m_et_t/domain/type_article.dart';
import 'package:inventaire_m_et_t/service/widget_service_state.dart';

class MenuWidget extends StatefulWidget {

  static const ASSETS_DIR = "assets/images/";

  WidgetServiceState widgetServiceState = WidgetServiceState();

  final TypeArticle typeArticle;

  MenuWidget({super.key, required this.typeArticle});

  @override
  State<StatefulWidget> createState() => _MenuWidget();
}

class _MenuWidget extends State<MenuWidget> {
  _MenuWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        width: 90,
        height: 45,
        child: Row(
          children: [
            ValueListenableBuilder<TypeArticle?>(valueListenable:
            widget.widgetServiceState.currentSelectedTypeArticle
                , builder: (context, value, michel) {
          return GestureDetector(
              onTap: _selectTypeArticle,
              child: Container(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child:
                  SvgPicture.asset(MenuWidget.ASSETS_DIR +
                          widget.typeArticle.svgResource),
                ),
                height: 45,
                width: 65,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: _selectColorDependingOnSelectedTypeArticle(value),
                ),
              ));
                }),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF8B8787),
              ),
              width: 4,
              height: 37,
            ),
          ],
        ));
  }


  _selectTypeArticle() {
    widget.widgetServiceState.currentSelectedTypeArticle.value =
        widget.typeArticle;
  }

  _selectColorDependingOnSelectedTypeArticle(TypeArticle? value) {
    if (value != null && value == widget.typeArticle) {
      return Color(0xFF8B8787);
    } else {
      return Color(0x00000000);
    }
  }

}
