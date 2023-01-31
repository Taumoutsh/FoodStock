import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../service/widget_service_state.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidget();
}

class _SearchWidget extends State<SearchWidget> {
  final log = Logger('_SearchWidget');

  WidgetServiceState widgetServiceState = WidgetServiceState();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    _searchController.addListener(_updateListIfSearchMode);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: widgetServiceState.isSearchModeActivated,
        builder: (context, value, child) {
          return AnimatedContainer(
            curve: Curves.linearToEaseOut,
            height: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(60),
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.onSurface,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 4))
                ]),
            duration: const Duration(milliseconds: 300),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _updateListOnSearchModeTrigger(value),
                  child: Container(
                    height: 50,
                    width: 50,
                    child: _computeIconDependingOnValue(value),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linearToEaseOut,
                  height: 45,
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 5),
                  width: _computeTextFieldSizeDependingOnValue(value),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    controller: _searchController,
                    scrollPadding: EdgeInsets.zero,
                    style: Theme.of(context).textTheme.bodySmall,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        hintText: "Intitulé de l'article"),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _updateListOnSearchModeTrigger(bool willBeSearchMode) {
    if (!willBeSearchMode) {
      log.config("_updateListOnSearchModeTrigger() -"
          " Repliement automatique du clavier <$willBeSearchMode>");
      _searchController.text = "";

    } else {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    widgetServiceState.isSearchModeActivated.value = !willBeSearchMode;
  }

  double _computeTextFieldSizeDependingOnValue(bool willBeSearchMode) {
    if (willBeSearchMode) {
      return MediaQuery.of(context).size.width - 70;
    } else {
      return 0;
    }
  }

  Icon _computeIconDependingOnValue(bool willBeSearchMode) {
    if (willBeSearchMode) {
      return Icon(
        Icons.delete_forever,
        size: 35,
        color: Theme.of(context).colorScheme.secondary,
      );
    } else {
      return Icon(
        Icons.search_rounded,
        size: 35,
        color: Theme.of(context).colorScheme.secondary,
      );
    }
  }

  void _updateListIfSearchMode() {
    widgetServiceState.currentResearchContent.value = _searchController.text;
    if (widgetServiceState.isSearchModeActivated.value) {
      widgetServiceState.triggerListUpdate.value++;
    }
  }
}
