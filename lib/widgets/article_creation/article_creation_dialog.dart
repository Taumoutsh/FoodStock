import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodstock/service/data_manager.dart';
import 'package:foodstock/service/widget_service_state.dart';
import 'package:foodstock/widgets/menu_widget/main_menu_bar_widget.dart';
import 'package:logging/logging.dart';

import '../../domain/model/article.dart';
import '../generic_items/generic_button_widget.dart';

class ArticleCreationDialog extends StatefulWidget {

  ArticleCreationDialog(this.potentialCurrentArticle, {super.key});

  Article? potentialCurrentArticle;

  @override
  State<StatefulWidget> createState() => _ArticleCreationDialog();
}

class _ArticleCreationDialog extends State<ArticleCreationDialog> {
  final log = Logger('ArticleCreationDialog');

  Color _mainContainerColor = const Color(0xFFE9E9E9);

  bool isValidForm = true;

  Timer? timer;

  DataManagerService dataManagerService = DataManagerService();

  WidgetServiceState widgetServiceState = WidgetServiceState();

  final _articleNameController = TextEditingController();

  final _articleDurationController = TextEditingController();

  final _alertLevelController = TextEditingController();

  final _criticalLevelController = TextEditingController();

  void _predefineControllersText() {
    if(widget.potentialCurrentArticle != null) {
      _articleNameController.text =
          widget.potentialCurrentArticle!.labelArticle;
      _articleDurationController.text =
          widget.potentialCurrentArticle!.peremptionEnJours.toString();
      _alertLevelController.text =
          widget.potentialCurrentArticle!.quantiteAlerte.toString();
      _criticalLevelController.text =
          widget.potentialCurrentArticle!.quantiteCritique.toString();
    } else {
      log.info("_predefineControllersText() - No initial text is required"
          "it appears to be the article creation use case");
    }
  }

  @override
  Widget build(BuildContext context) {
    _predefineControllersText();
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: AnimatedContainer(
                clipBehavior: Clip.hardEdge,
                height: 430,
                width: 300,
                decoration: BoxDecoration(
                    color: _mainContainerColor,
                    borderRadius: BorderRadius.circular(20)),
                duration: const Duration(milliseconds: 300),
                child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: TextField(
                            controller: _articleNameController,
                            scrollPadding: EdgeInsets.zero,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: ".AppleSystemUIFont"),
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 10, 0, 0),
                                hintText: "Intitulé de l'article"),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: const Text("Catégorie d'article",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: ".AppleSystemUIFont")),
                                  padding: const EdgeInsets.fromLTRB(
                                      5, 10, 10, 10)),
                              Flex(
                                direction: Axis.horizontal,
                                children: [MainMenuBarWidget()],
                              )
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            child: TextField(
                              controller: _articleDurationController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              scrollPadding: EdgeInsets.zero,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: ".AppleSystemUIFont"),
                              decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  hintText: "Péremption en jours"),
                            )),
                        Container(
                          height: 65,
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Container(
                                        child: const Text("Niveaux d'alertes",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: ".AppleSystemUIFont")),
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 10))),
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    alignment: Alignment.center,
                                    width: 60.0,
                                    constraints: const BoxConstraints(
                                        maxHeight: double.infinity),
                                    decoration: BoxDecoration(
                                        color: const Color(0x70F16060),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color(0x336B6B6B),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                              offset: Offset(0, 2))
                                        ]),
                                    child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 10),
                                        child: TextField(
                                          controller: _criticalLevelController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          scrollPadding: EdgeInsets.zero,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              fontFamily: ".AppleSystemUIFont"),
                                          decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      0, 10, 0, 0)),
                                        ))),
                                Container(
                                    alignment: Alignment.center,
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    width: 60.0,
                                    constraints: const BoxConstraints(
                                        maxHeight: double.infinity),
                                    decoration: BoxDecoration(
                                        color: const Color(0x70EBA131),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color(0x336B6B6B),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                              offset: Offset(0, 2))
                                        ]),
                                    child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 10),
                                        child: TextField(
                                          controller: _alertLevelController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          scrollPadding: EdgeInsets.zero,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              fontFamily: ".AppleSystemUIFont"),
                                          decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      0, 10, 0, 0)),
                                        )))
                              ]),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: GenericButtonWidget(
                                          colorsToApply: const [
                                            Color(0xFF70AC62),
                                            Color(0xFF377F29)
                                          ],
                                          onTapFunction: () => _addOrUpdateArticle(
                                              widget.potentialCurrentArticle),
                                          iconData: Icons.check_rounded,
                                          iconSize: 50))),
                            ])
                      ],
                    )))));
  }

  _addOrUpdateArticle(Article? potentialCurrentArticle) async {
    isValidForm = true;
    if (_articleNameController.value.text == "") {
      isValidForm &= false;
    }
    if (_articleDurationController.value.text == "") {
      isValidForm &= false;
    }
    if (_alertLevelController.value.text == "") {
      isValidForm &= false;
    }
    if (_criticalLevelController.value.text == "") {
      isValidForm &= false;
    }

    if (isValidForm) {
      bool result = false;
      if(potentialCurrentArticle == null) {
        log.info("_addOrUpdateArticle() - Calling the data manager service"
            " to add a new article <$_articleNameController.value.text>");
        result = await dataManagerService.addNewArticle(
            _articleNameController.value.text,
            int.parse(_articleDurationController.value.text),
            int.parse(_alertLevelController.value.text),
            int.parse(_criticalLevelController.value.text),
            widgetServiceState.currentSelectedTypeArticle.value!);
      } else {
        log.info("_addOrUpdateArticle() - Calling the data manager service"
            " to update the existing article"
            " <$_articleNameController.value.text>");
        result = await dataManagerService.updateArticle(
            potentialCurrentArticle,
            _articleNameController.value.text,
            int.parse(_articleDurationController.value.text),
            int.parse(_alertLevelController.value.text),
            int.parse(_criticalLevelController.value.text),
            widgetServiceState.currentSelectedTypeArticle.value!);
      }
      if (result) {
        widgetServiceState.triggerListUpdate.value++;
      }
      Navigator.of(context).pop();
    } else {
      log.severe("_addOrUpdateArticle() - Form is not properly filled");
      int blinkCountLimit = 2;
      if (timer != null) {
        timer!.cancel();
      }
      timer = Timer.periodic(const Duration(milliseconds: 400), (Timer timer) {
        setState(() {
          if (blinkCountLimit % 2 == 0) {
            _mainContainerColor = const Color(0xFFF00000);
          } else {
            _mainContainerColor = const Color(0xFFE9E9E9);
          }
          blinkCountLimit--;
          if (blinkCountLimit == 0) {
            timer.cancel();
          }
        });
      });
    }
  }
}
