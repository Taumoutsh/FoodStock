import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstock/theme/theme_mode.dart';

import '../../theme/theme_notifier.dart';

class OptionPopup extends StatefulWidget {

  ThemeNotifier themeNotifier = ThemeNotifier();



  @override
  State<StatefulWidget> createState() => _OptionPopupState();

}

class _OptionPopupState extends State<OptionPopup> {

  static const List<Widget> icons = <Widget>[
    Icon(Icons.sunny),
    Icon(Icons.nightlight)
  ];

  @override
  Widget build(BuildContext context) {

    final List<bool> _selectedWeather = <bool>[
      widget.themeNotifier.currentTheme.value == CustomThemeMode.LIGHT_MODE,
      widget.themeNotifier.currentTheme.value == CustomThemeMode.DARK_MODE];

    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: AnimatedContainer(
                clipBehavior: Clip.hardEdge,
                height: 150,
                width: 200,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(20)),
                duration: const Duration(milliseconds: 300),
                child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  child: Text("Sélection du thème",
                                      style: Theme.of(context).textTheme.bodySmall),
                                  padding:
                                  const EdgeInsets.fromLTRB(5, 10, 10, 15)),
                              ToggleButtons(
                                          direction: Axis.horizontal,
                                          onPressed: (int index) {
                                            setState(() {
                                              // The button that is tapped is set to true, and the others to false.
                                              for (int i = 0; i < _selectedWeather.length; i++) {
                                                _selectedWeather[i] = i == index;
                                              }
                                              if(index == 0) {
                                                widget.themeNotifier.currentTheme.value =
                                                    CustomThemeMode.LIGHT_MODE;
                                              } else {
                                                widget.themeNotifier.currentTheme.value =
                                                    CustomThemeMode.DARK_MODE;
                                              }
                                            });
                                          },
                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                          selectedBorderColor: Theme.of(context).colorScheme.tertiary,
                                          selectedColor: Colors.white,
                                          fillColor: Theme.of(context).colorScheme.secondary,
                                          color: Theme.of(context).colorScheme.primary,
                                          isSelected: _selectedWeather,
                                          children: icons,
                                        )
                                      ]))
                                ],
                              )
                          ),
    )));
  }



}