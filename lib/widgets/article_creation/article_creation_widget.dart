import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                    child: const Icon(Icons.add, size: 50, color: Colors.white),
                    curve: Curves.linear,
                    height: 90,
                    margin: const EdgeInsets.fromLTRB(10, 7, 12, 7),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF377F29), Color(0xFF71AF54)]),
                        color: const Color(0xFFE9E9E9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x33000000),
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
