import 'package:lifemine/src/view_models/reminder_view_model.dart';

import '../constants.dart';
import '../data.dart';

class ModelOptionsViewModel {
  ModelOptionsViewModel({ModelOptions? modelOptions}) {
    singleField = modelOptions?.singleField;
    aggregation = Constants.defaultFrequencyOption;
    limit = Constants.defaultFrequencyOption;
    reminders = modelOptions?.reminders
        .map((r) => ReminderViewModel(reminder: r))
        .toList();
  }

  bool? singleField;
  late String? aggregation;
  late String? limit;
  List<ReminderViewModel>? reminders;

  Map<String, Object?> toJson() {
    return {
      'singleField': singleField ?? false,
      'aggregation': aggregation,
      'limit': limit,
      if (reminders != null)
        'reminders': ReminderViewModel.listToJson(reminders!),
    };
  }
}
