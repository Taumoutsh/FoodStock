import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../domain/model/constants/ui_constants.dart' as UiConstants;

import 'article_creation_dialog.dart';

class ArticleCreationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
            child: GestureDetector(
                onTap: () {
                  showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return ArticleCreationDialog(null);
                      });
                },
                child: AnimatedContainer(
                    child: Icon(Icons.add_rounded,
                        size: 50, color: Theme.of(context).colorScheme.onBackground),
                    curve: Curves.linear,
                    height: 90,
                    margin: const EdgeInsets.fromLTRB(10, 7, 12, 7),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF377F29), Color(0xFF71AF54)]),
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).colorScheme.surface,
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(0, 4))
                        ]),
                    duration: const Duration(milliseconds: 100))))
      ],
    )
     ;
  }
}
