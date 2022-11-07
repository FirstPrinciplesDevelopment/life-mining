class Constants {
  static const List<String> frequencyOptionList = [
    'none',
    'daily',
    'weekly',
    'monthly',
    'yearly',
  ];

  static const String defaultFrequencyOption = 'none';

  static const List<String> fieldWidgetTypeList = [
    'Text', // String
    'MultilineText', // String
    'Slider', // num
    'NumberInput', // num
    'Date', // DateTime
    'DateTime', // DateTime
    'DateRange', // DateTimeRange
    'Timestamp', // num
    'ElapsedTime', // Duration
    'Checkbox', // bool
    'Radio', // String
    'MultiSelect', // String
    'Select', // String
  ];

  static const String defaultFieldWidgetType = 'Text';

  static const List<String> dayOfWeekList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}
