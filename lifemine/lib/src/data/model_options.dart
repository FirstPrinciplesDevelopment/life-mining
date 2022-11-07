import 'package:lifemine/src/constants.dart';

import '../data.dart';
import 'reminder.dart';

/// The options or settings for a model
class ModelOptions {
  ModelOptions({
    this.singleField = false,
    this.aggregation = Constants.defaultFrequencyOption,
    this.limit = Constants.defaultFrequencyOption,
    this.reminders = const [],
  });

  ModelOptions.fromJson(Map<String, Object?> json)
      : this(
          singleField: (json['singleField'] ?? false) as bool,
          aggregation: (json['aggregation'] ?? Constants.defaultFrequencyOption)
              as String,
          limit: (json['limit'] ?? Constants.defaultFrequencyOption) as String,
          reminders:
              Reminder.remindersFromJson(json['reminders'] as List<dynamic>?),
        );

  final bool singleField;
  String aggregation;
  String limit;
  final List<Reminder> reminders;

  Map<String, Object?> toJson() {
    return {
      'singleField': singleField,
      'aggregation': aggregation,
      'limit': limit,
      'reminders': Reminder.jsonFromReminders(reminders)
    };
  }
}
