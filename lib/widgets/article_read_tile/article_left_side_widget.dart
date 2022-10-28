import 'package:flutter/material.dart';

class ArticleLeftSideTile extends StatelessWidget {
  ArticleLeftSideTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: double.infinity,
      child: Container(
        height: 60,
        width: 60,
        decoration:
        BoxDecoration(color: Color(0xFF7A7A7A), shape: BoxShape.circle),
      ),
    );
  }
}