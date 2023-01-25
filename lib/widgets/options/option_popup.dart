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
      widget.themeNotifier.currentTheme.value == CustomThemeMode.DARK_MODE
    ];

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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                    padding: const EdgeInsets.fromLTRB(
                                        5, 10, 10, 15)),
                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                  const Icon(Icons.sunny,
                                      color: Color(0xFFF5D208)),
                                  CupertinoSwitch(
                                    activeColor: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                      trackColor: Theme.of(context)
                                          .colorScheme
                                          .inverseSurface,
                                      thumbColor: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      value: widget.themeNotifier.currentTheme
                                              .value ==
                                          CustomThemeMode.DARK_MODE,
                                      onChanged: (isDarkMode) {
                                        widget.themeNotifier.switchTheme();
                                      }),
                                  const Icon(Icons.nightlight,
                                      color: Color(0xFF4A578A))
                                ]),
                              ]))
                    ],
                  )),
            )));
  }
}
