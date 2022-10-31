import 'package:flutter/cupertino.dart';

class ConservationData extends ChangeNotifier {

  DateTime olderArticleDateTime;

  int nominalConservationDays;

  int currentConservationDays;

  ConservationData({
    required this.olderArticleDateTime,
    required this.nominalConservationDays,
    required this.currentConservationDays,
  });

  double computeLastingInPercentAbsolute() {
    if(currentConservationDays >= nominalConservationDays) {
      return 1;
    } else {
      return computeLastingInPercent();
    }
  }

  double computeLastingInPercent() {
      return (currentConservationDays/nominalConservationDays).toDouble();
  }

  String computeLastingInDaysOrMonthsOrYearsString() {
    if (isReallyNotInInventory()) {
      return "";
    } else {
      int inDays = nominalConservationDays - currentConservationDays;
      double inMonths = inDays / 30;
      double inYears = inDays / 365;
      if (inMonths > 1) {
        if (inYears > 1) {
          return inYears.toInt().toString() + "a";
        } else {
          return inMonths.toInt().toString() + "m";
        }
      } else {
        return inDays.toString() + "j";
      }
    }
  }

  void updateConservationData(nominalConservationDays,
      currentConservationDays) {
    this.nominalConservationDays = nominalConservationDays;
    this.currentConservationDays = currentConservationDays;
    notifyListeners();
  }

  bool isReallyNotInInventory() {
    return this.currentConservationDays == 0
        && this.nominalConservationDays == 0;
  }

}