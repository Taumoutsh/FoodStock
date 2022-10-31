
import 'package:flutter/material.dart';
import 'article_creation_dialog.dart';

class ArticleCreationButton extends StatelessWidget {
  const ArticleCreationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment(1, 0.75),
        child: FloatingActionButton(
          onPressed: () {
                showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return ArticleCreationDialog();
          });
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add_rounded,
            size: 40,),
        ));
  }

}