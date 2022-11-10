import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodstock/service/data_manager.dart';
import 'package:foodstock/service/widget_service_state.dart';
import 'package:foodstock/widgets/menu_widget/main_menu_bar_widget.dart';

import '../../domain/model/article.dart';
import '../generic_items/generic_button_widget.dart';

class ArticleRemoveDialog extends StatefulWidget {

  Article currentArticle;

  ArticleRemoveDialog({super.key, required this.currentArticle});

  @override
  State<StatefulWidget> createState() => _ArticleRemoveDialog();
}

class _ArticleRemoveDialog extends State<ArticleRemoveDialog> {
  DataManagerService dataManagerService = DataManagerService();

  WidgetServiceState widgetServiceState = WidgetServiceState();

  String articleNameString = "";

  @override
  void initState() {
    super.initState();
    articleNameString = widget.currentArticle.labelArticle;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
          clipBehavior: Clip.hardEdge,
          height: 230,
          width: 415,
          decoration: BoxDecoration(
              color: const Color(0xFFE9E9E9),
              borderRadius: BorderRadius.circular(30)),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFFFFFFF)),
              margin: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Text("L'article $articleNameString et son stock associé est"
                            " sur le point d'être supprimé."
                            "\nVeuillez valider pour confirmer cette action.",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: "Segue UI")),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: GenericButtonWidget(
                                colorsToApply: const [
                                  Color(0xFF70AC62),
                                  Color(0xFF377F29)
                                ],
                                onTapFunction: _removeArticle,
                                iconData: Icons.check_rounded,
                                iconSize: 50))),
                  ])
                ],
              ))),
    );
  }

  _removeArticle() async {
    bool articleRemovalState =
        await dataManagerService.removeArticle(widget.currentArticle);
    if(articleRemovalState) {
      widgetServiceState.triggerListUpdate.value++;
      Navigator.of(context).pop();
    }
  }
}
