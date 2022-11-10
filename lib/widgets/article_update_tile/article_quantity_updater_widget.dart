import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../domain/model/article.dart';
import '../../service/data_provider.dart';
import '../../service/widget_service_state.dart';

class ArticleQuantityUpdaterWidget extends StatefulWidget {
  final Article currentArticle;

  const ArticleQuantityUpdaterWidget({super.key, required this.currentArticle});

  @override
  State<StatefulWidget> createState() => _ArticleQuantityUpdaterWidget();
}

class _ArticleQuantityUpdaterWidget
    extends State<ArticleQuantityUpdaterWidget> {
  var dataProviderService = DataProviderService();

  var widgetServiceState = WidgetServiceState();

  bool isInitialized = false;

  var currentQuantity = 0;

  _addValue() {
    setState(() {
      if (currentQuantity < 20) {
        currentQuantity = currentQuantity + 1;
        widgetServiceState
                .currentQuantityByArticle[widget.currentArticle.pkArticle!] =
            currentQuantity;
      }
    });
  }

  _removeValue() {
    setState(() {
      if (currentQuantity > 0) {
        currentQuantity = currentQuantity - 1;
        widgetServiceState
                .currentQuantityByArticle[widget.currentArticle.pkArticle!] =
            currentQuantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      if (!widgetServiceState.currentQuantityByArticle
          .containsKey(widget.currentArticle.pkArticle)) {
        currentQuantity = dataProviderService
            .getNumberOfAvailableArticleInInventory(widget.currentArticle);
        widgetServiceState
                .currentQuantityByArticle[widget.currentArticle.pkArticle!] =
            currentQuantity;
      } else {
        currentQuantity = widgetServiceState
            .currentQuantityByArticle[widget.currentArticle.pkArticle]!;
      }
    }

    return Container(
      height: double.infinity,
      width: 175,
      constraints: const BoxConstraints(
        minWidth: 175,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: _removeValue,
              child: Icon(Icons.remove_rounded,
                  color: computeRemoveColor(currentQuantity), size: 70)),
          Text(currentQuantity.toString(),
              style: const TextStyle(
                  color: Color(0xFF303030),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  fontFamily: "Segue UI")),
          GestureDetector(
              onTap: _addValue,
              child: Icon(Icons.add_rounded,
                  color: computeAddColor(currentQuantity), size: 70))
        ],
      ),
    );
  }

  Color computeRemoveColor(int quantityValue) {
    Color colorToReturn;
    if (quantityValue > 0) {
      colorToReturn = const Color(0xFF747474);
    } else {
      colorToReturn = const Color(0xFFDBDBDB);
    }
    return colorToReturn;
  }

  Color computeAddColor(int quantityValue) {
    Color colorToReturn;
    if (quantityValue < 20) {
      colorToReturn = const Color(0xFF747474);
    } else {
      colorToReturn = const Color(0xFFDBDBDB);
    }
    return colorToReturn;
  }
}
