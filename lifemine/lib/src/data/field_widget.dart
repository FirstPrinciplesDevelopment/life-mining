import 'select_option.dart';

/// The definition of a Widget to use for a single Field of a Model
class FieldWidget {
  FieldWidget(
    this.fieldName,
    this.type,
    this.max,
    this.min,
    this.maxLabel,
    this.minLabel,
    this.step,
    this.numericDefault,
    this.stringDefault,
    this.optionList,
    this.auto,
    this.isRequired,
    this.maxLength,
  );

  static const String defaultType = 'Text';
  static const num defaultMax = 10;
  static const num defaultMin = 0;
  static const num defaultStep = 1;
  static const num defaultNumericDefault = 0;
  static const bool defaultAuto = false;
  static const bool defaultIsRequired = false;

  final String fieldName;
  final String type;
  final num max;
  final num min;
  final String? maxLabel;
  final String? minLabel;
  final num step;
  final num numericDefault;
  final String? stringDefault;
  final List<SelectOption>? optionList;
  final bool auto;
  final bool isRequired;
  final int? maxLength;

  static FieldWidget? fromJson(Map<String, Object?>? json, String fieldName) {
    if (json != null) {
      return FieldWidget(
        fieldName,
        (json['type'] ?? defaultType) as String,
        (json['max'] ?? defaultMax) as num,
        (json['min'] ?? defaultMin) as num,
        json['maxLabel'] as String?,
        json['minLabel'] as String?,
        (json['step'] ?? defaultStep) as num,
        (json['numericDefault'] ?? defaultNumericDefault) as num,
        json['stringDefault'] as String?,
        SelectOption.selectOptionsFromJson(json['options'] as List<dynamic>?),
        (json['auto'] ?? defaultAuto) as bool,
        (json['isRequired'] ?? defaultIsRequired) as bool,
        json['maxLength'] as int?,
      );
    }
  }

  Map<String, Object?> toJson() {
    // note: always include type even if it's the default, for clarity
    return {
      'type': type,
      if (max != defaultMax) 'max': max,
      if (min != defaultMin) 'min': min,
      if (maxLabel != null) 'maxLabel': maxLabel,
      if (minLabel != null) 'minLabel': minLabel,
      if (step != defaultStep) 'step': step,
      if (numericDefault != defaultNumericDefault)
        'numericDefault': numericDefault,
      if (stringDefault != null) 'stringDefault': stringDefault,
      if (optionList != null)
        'options': SelectOption.jsonFromSelectOptions(optionList!),
      if (auto != defaultAuto) 'auto': auto,
      if (isRequired != defaultIsRequired) 'isRequired': isRequired,
      if (maxLength != null) 'maxLength': maxLength,
    };
  }
}
