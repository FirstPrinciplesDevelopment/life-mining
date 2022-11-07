import 'package:flutter/material.dart';

import '../data.dart';
import '../helpers.dart';

class ReminderViewModel {
  ReminderViewModel({Reminder? reminder}) {
    dayOfWeek = reminder?.dayOfWeek;
    timeOfDay = reminder?.timeOfDay ?? const TimeOfDay(hour: 0, minute: 0);
  }

  late String? dayOfWeek;
  late TimeOfDay timeOfDay;

  Map<String, Object?> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'timeOfDay': Helpers.toMinutesPastMidnight(timeOfDay),
    };
  }

  static List<Map<String, Object?>> listToJson(
      List<ReminderViewModel> reminders) {
    List<Map<String, Object?>> result = [];
    for (ReminderViewModel reminder in reminders) {
      result.add(reminder.toJson());
    }
    return result;
  }
}
