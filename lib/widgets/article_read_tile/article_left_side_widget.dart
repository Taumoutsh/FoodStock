import 'package:flutter/material.dart';
import 'package:foodstock/domain/model/conservation_data.dart';
import 'package:foodstock/service/data_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../domain/model/article.dart';

class ArticleLeftSideTile extends StatefulWidget {
  final Article currentArticle;

  const ArticleLeftSideTile({super.key, required this.currentArticle});

  @override
  State<StatefulWidget> createState() => _ArticleLeftSideTile();
}

class _ArticleLeftSideTile extends State<ArticleLeftSideTile> {
  DataProviderService dataProviderService = DataProviderService();

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: double.infinity,
        child: ValueListenableBuilder<ConservationData>(
          valueListenable: dataProviderService
              .conservationDataByArticle[widget.currentArticle.pkArticle]!,
          builder: (context, value, child) {
            return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: CircularPercentIndicator(
                percent: value.computeLastingInPercentAbsolute(),
                center: Text(
                  value.computeLastingInDaysOrMonthsOrYearsString(),
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: ".AppleSystemUIFont",
                      color: Colors.black),
                ),
                progressColor:
                    _updateProgressColor(value.computeLastingInPercent()),
                circularStrokeCap: CircularStrokeCap.round,
                radius: 35,
              ),
              width: 60,
              decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 5))
                  ]),
            );
          },
        ));
  }

  Color _updateProgressColor(double conservationDataDiff) {
    if (conservationDataDiff < 0.5) {
      return const Color(0xFF70AC62);
    } else if (conservationDataDiff < 0.75) {
      return const Color(0xFFEBA131);
    } else if (conservationDataDiff < 1) {
      return const Color(0xFFFF4E4E);
    } else if (conservationDataDiff.isNaN) {
      return const Color(0xFF464545);
    } else {
      return const Color(0xFF744216);
    }
  }
}
