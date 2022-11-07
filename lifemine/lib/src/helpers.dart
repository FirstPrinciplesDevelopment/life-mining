import 'package:flutter/material.dart';

class Helpers {
  static TimeOfDay fromMinutesPastMidnight(int minutesPastMidnight) {
    int hours = minutesPastMidnight ~/ 60;
    int minutes = minutesPastMidnight % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }

  static int toMinutesPastMidnight(TimeOfDay timeOfDay) {
    return ((timeOfDay.hour * 60) + timeOfDay.minute);
  }
}
