import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/data_manager.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';

import '../../domain/article.dart';
import '../../service/widget_service_state.dart';

class ArticleValidButtonWidget extends StatefulWidget {
  final Article currentArticle;

  const ArticleValidButtonWidget({super.key, required this.currentArticle});

  @override
  State<StatefulWidget> createState() => _ArticleValidButtonWidget();
}

class _ArticleValidButtonWidget extends State<ArticleValidButtonWidget> {

  var dataProviderService = DataProviderService();

  var dataManagerService = DataManagerService();

  var widgetServiceState = WidgetServiceState();

  _updateArticleQuantity() {
    setState(() {
      dataManagerService.addOrRemoveFromInventaire(
          widget.currentArticle,
      widgetServiceState.currentQuantityByArticle
      [widget.currentArticle.pkArticle]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(7.5, 0, 0, 0),
        height: 70,
        width: 70,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF70AC62), Color(0xFF377F29)]),
        ),
        child: GestureDetector(
          onTap: _updateArticleQuantity,
          child: const Icon(
            Icons.check_rounded,
            size: 50,
            color: Colors.white,
          )
        ));
  }

}
