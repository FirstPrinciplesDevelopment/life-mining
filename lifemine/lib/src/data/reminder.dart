import 'package:flutter/material.dart';
import 'package:lifemine/src/data/invalid_json_exception.dart';
import '../helpers.dart';

/// A single reminder event with day of week and time of day
class Reminder {
  Reminder({required this.dayOfWeek, required this.timeOfDay});

  final String dayOfWeek;
  final TimeOfDay timeOfDay;

  static Reminder fromJson(Map<String, Object?> json) {
    if (json['dayOfWeek'] == null) {
      throw InvalidJsonException(message: 'Reminder.dayOfWeek is required.');
    }
    return Reminder(
      dayOfWeek: json['dayOfWeek']! as String,
      timeOfDay:
          Helpers.fromMinutesPastMidnight((json['timeOfDay'] ?? 0) as int),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'timeOfDay': Helpers.toMinutesPastMidnight(timeOfDay),
    };
  }

  static List<Reminder> remindersFromJson(List<dynamic>? json) {
    List<Reminder> result = [];
    for (var reminder in json ?? []) {
      if (reminder is Map<String, Object?>) {
        result.add(Reminder.fromJson(reminder));
      }
    }
    return result;
  }

  static List<Map<String, Object?>> jsonFromReminders(
      List<Reminder> reminders) {
    List<Map<String, Object?>> result = [];
    for (Reminder reminder in reminders) {
      result.add(reminder.toJson());
    }
    return result;
  }
}
