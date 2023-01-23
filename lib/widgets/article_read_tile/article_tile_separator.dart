import 'package:flutter/material.dart';

class ArticleTileSeparator extends StatelessWidget {
  const ArticleTileSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary, //Color.fromARGB(1, 233, 233, 233),
          borderRadius: BorderRadius.circular(20)),
      width: 5.0,
    );
  }
}