import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:inventaire_m_et_t/domain/article.dart';
import 'package:inventaire_m_et_t/domain/data_provider.dart';

import 'domain/inventaire.dart';
import 'domain/type_article.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  DataProviderService dataProviderService = DataProviderService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: dataProviderService.refreshValuesFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Widget> articleTileArray = [];
            for (Article article in dataProviderService.articleMap.values) {
              articleTileArray.add(articleTile(article));
            }
            return MaterialApp(
                title: 'Welcome to Flutter',
                home: Scaffold(
                  persistentFooterButtons: [],
                  appBar: AppBar(
                    title: const Text('Welcome to Flutter'),
                  ),
                  body: SingleChildScrollView(
                    child:
                      Column(
                        children: articleTileArray,
                      ),
                  ),
                  extendBody: true,
                  //bottomNavigationBar: TypeArticleListViewWidget(),
                ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget articleTile(Article article) {
    DateTime date = DateTime.now().add(Duration(days: article.peremptionEnJours));
    String dateToPrint = date.day.toString() + "-" + date.year.toString();
    return Container(
        height: 90,
        margin: EdgeInsets.fromLTRB(10, 7, 10 ,7),
        decoration: BoxDecoration(
          color: Color(0xFFE9E9E9), //Color.fromARGB(1, 233, 233, 233),
          borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(
                color: Color(0x14000000),
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(4, 4)
            )]),
        child: Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xFF7A7A7A),
                      shape: BoxShape.circle
                    ),
                  ),
                ), // Image de la tile
                Container(
                  margin: EdgeInsets.fromLTRB(0,10,0,10),
                  decoration: BoxDecoration(
                      color: Color(0xFFBCBCBC), //Color.fromARGB(1, 233, 233, 233),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  width: 5.0,
                ), // barre latérale
                Expanded(child:
                  Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child:
                      Container(
                          margin: EdgeInsets.all(7),
                          child: Row(
                            children: [
                            Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [ // Colonne du nom de l'article et de la quantité
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(article.labelArticle,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              fontFamily: "Segue UI"
                                          )),
                                      Icon(Icons.star,
                                      color: Color(0xFFFFA795),
                                      size: 18,)
                                    ],
                                  ),
                                   // Nom de l'article
                                  Text("DLUO min : " + dateToPrint,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 12,
                                          fontFamily: "Segue UI"
                                      )) // DLUO
                                ])
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 90.0,
                              constraints: BoxConstraints(
                                maxHeight: double.infinity
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0x7049AC57)
                              ),
                              child: Text(dataProviderService
                                  .getNumberOfAvailableArticleInInventory(article)
                                  .toString(),
                              style: TextStyle(
                                  color: Color(0xFF303030),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: "Segue UI"
                              ),
                              textAlign: TextAlign.center,), //Quantité
                            ),
                          ],
                        )
                      )
                  )
                )
              ],
        ),
      );
  }

  Widget listView() {
    return ListView.builder(
      itemCount: dataProviderService.inventaireMap.length,
      itemBuilder: (context, index) {
        Inventaire? inventaire = dataProviderService.inventaireMap[index];
        return Column(
          children: [_createCustomTile(inventaire!, context)],
        );
      },
    );
  }

  ListTile _createCustomTile(Inventaire inventaire, BuildContext context) {
    return ListTile(
      leading: Icon(Icons.food_bank),
      title: Text(inventaire.article.labelArticle +
          " de type : " +
          inventaire.article.typeArticle.labelTypeArticle),
      subtitle: Text(inventaire.article.peremptionEnJours.toString() +
          ", acheté le : " +
          inventaire.dateAchatArticle),
      onLongPress: () {
        dataProviderService.removeFromInventaire(inventaire.pkInventaire);
        Navigator.of(context).pop();
      },
    );
  }
}

class TypeArticleListViewWidget extends StatelessWidget {
  DataProviderService dataProviderService = DataProviderService();

  List<TypeArticleTileWidget> typeArticleTileWidgetList = [];

  TypeArticleListViewWidget({super.key}) {
    typeArticleTileWidgetList.add(TypeArticleTileWidget(
        typeArticle: dataProviderService.typeArticleMap.values.toList()[0]));
    typeArticleTileWidgetList.add(TypeArticleTileWidget(
        typeArticle: dataProviderService.typeArticleMap.values.toList()[1]));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: typeArticleTileWidgetList,
    );
  }
}

class TypeArticleTileWidget extends StatefulWidget {
  final TypeArticle typeArticle;

  const TypeArticleTileWidget({super.key, required this.typeArticle});

  @override
  State<TypeArticleTileWidget> createState() =>
      _TypeArticleTileWidgetStateful();
}

class _TypeArticleTileWidgetStateful extends State<TypeArticleTileWidget> {
  void _onLongPress(String typeArticle) {
    setState(() {
      print(typeArticle);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this.widget.typeArticle.labelTypeArticle),
      onLongPress: () {
        _onLongPress(widget.typeArticle.labelTypeArticle);
      },
    );
  }
}
