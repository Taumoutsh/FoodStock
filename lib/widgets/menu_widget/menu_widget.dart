import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/type_article.dart';
import 'package:inventaire_m_et_t/service/widget_service_state.dart';

class MenuWidget extends StatefulWidget {
  WidgetServiceState widgetServiceState = WidgetServiceState();

  final TypeArticle typeArticle;

  MenuWidget({super.key, required this.typeArticle});

  @override
  State<StatefulWidget> createState() => _MenuWidget();
}

class _MenuWidget extends State<MenuWidget> {
  _MenuWidget();

  late Color _menuColorSelection = Color(0xFFE9E9E9);

  _selectTypeArticle() {
    widget.widgetServiceState.currentSelectedTypeArticle.value =
        widget.typeArticle;
  }

  _selectColorDependingOnSelectedArticle() {
    if (widget.widgetServiceState.currentSelectedTypeArticle.value ==
        widget.typeArticle) {
      _menuColorSelection = Color(0xFFBCBCBC);
    } else {
      _menuColorSelection = Color(0xFFE9E9E9);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.widgetServiceState.currentSelectedTypeArticle.addListener(() {
      setState(() {
        _selectColorDependingOnSelectedArticle();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.widgetServiceState.currentSelectedTypeArticle.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _selectColorDependingOnSelectedArticle();
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        width: 90,
        height: 45,
        child: Row(
          children: [
            GestureDetector(
                onTap: _selectTypeArticle,
                child: Container(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFFFA795), Color(0xFFFBC3B8)]),
                        shape: BoxShape.circle),
                  ),
                  height: 45,
                  width: 65,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: _menuColorSelection,
                  ),
                )),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFBCBCBC),
              ),
              width: 4,
            ),
          ],
        ));
  }
}
