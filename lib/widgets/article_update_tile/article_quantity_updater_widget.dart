import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
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

  final log = Logger('_ArticleQuantityUpdaterWidget');

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
        log.config("_addValue() -"
            " Incrémentation de 1 de la valeur de l'article dans le service"
            " WidgetServiceState : " +
            widget.currentArticle.toString() +
            ", quantité courante <$currentQuantity>");
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
        log.config("_removeValue() -"
            " Décrémentation de 1 de la valeur de l'article dans le service"
            " WidgetServiceState : " +
            widget.currentArticle.toString() +
            ", quantité courante <$currentQuantity>");
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
      width: 130,
      constraints: const BoxConstraints(
        minWidth: 130,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Theme.of(context).colorScheme.background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: _removeValue,
              child: Icon(Icons.remove_rounded,
                  color: computeRemoveColor(context, currentQuantity), size: 47)),
          Container(
            width: 36,
            child: Text(currentQuantity.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
          )),
          GestureDetector(
              onTap: _addValue,
              child: Icon(Icons.add_rounded,
                  color: computeAddColor(context, currentQuantity), size: 47))
        ],
      ),
    );
  }

  Color computeRemoveColor(BuildContext context, int quantityValue) {
    Color colorToReturn;
    if (quantityValue > 0) {
      colorToReturn = Theme.of(context).colorScheme.secondary;
    } else {
      colorToReturn = Theme.of(context).colorScheme.primary;
    }
    return colorToReturn;
  }

  Color computeAddColor(BuildContext context, int quantityValue) {
    Color colorToReturn;
    if (quantityValue < 20) {
      colorToReturn = Theme.of(context).colorScheme.secondary;
    } else {
      colorToReturn = Theme.of(context).colorScheme.primary;
    }
    return colorToReturn;
  }
}
