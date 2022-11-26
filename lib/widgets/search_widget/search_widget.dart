import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../service/widget_service_state.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidget();
}

class _SearchWidget extends State<SearchWidget> {
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
            decoration: _computeWidgetStyleDependingOnValue(value),
            duration: const Duration(milliseconds: 250),
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
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.linearToEaseOut,
                  height: 45,
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 5),
                  width: _computeTextFieldSizeDependingOnValue(value),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    controller: _searchController,
                    scrollPadding: EdgeInsets.zero,
                    style: const TextStyle(
                        fontSize: 16, fontFamily: ".AppleSystemUIFont"),
                    decoration: const InputDecoration(
                        contentPadding:
                        EdgeInsets.fromLTRB(0, 0, 0, 0),
                        hintText: "Intitulé de l'article"),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _updateListOnSearchModeTrigger(bool isSearchMode) {
    if (!isSearchMode) {
      _searchController.text = "";
    }
    widgetServiceState.isSearchModeActivated.value = !isSearchMode;
    widgetServiceState.triggerListUpdate.value++;
  }

  BoxDecoration _computeWidgetStyleDependingOnValue(bool isSearchMode) {
    if (isSearchMode) {
      return getSearchModeLayout();
    } else {
      return getNormalModeLayout();
    }
  }

  double _computeTextFieldSizeDependingOnValue(bool isSearchMode) {
    if (isSearchMode) {
      return MediaQuery.of(context).size.width - 70;
    } else {
      return 0;
    }
  }

  Icon _computeIconDependingOnValue(bool isSearchMode) {
    if (isSearchMode) {
      return const Icon(
        Icons.delete_forever,
        size: 35,
        color: Color(0xFF8B8787),
      );
    } else {
      return const Icon(
        Icons.search_rounded,
        size: 35,
        color: Color(0xFF8B8787),
      );
    }
  }

  BoxDecoration getNormalModeLayout() {
    return BoxDecoration(
        color: Color(0xFFCFCDCD),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(60),
        boxShadow: const [
          BoxShadow(
              color: Color(0x66000000),
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 4))
        ]);
  }

  BoxDecoration getSearchModeLayout() {
    return BoxDecoration(
        color: const Color(0xFFCFCDCD),
        borderRadius: BorderRadius.circular(20),
        shape: BoxShape.rectangle,
        boxShadow: const [
          BoxShadow(
              color: Color(0x66000000),
              blurRadius: 5,
              spreadRadius: 1,
              offset: Offset(0, 4))
        ]);
  }

  void _updateListIfSearchMode() {
    widgetServiceState.currentResearchContent.value = _searchController.text;
    if(widgetServiceState.isSearchModeActivated.value) {
      widgetServiceState.triggerListUpdate.value++;
    }
  }
}
