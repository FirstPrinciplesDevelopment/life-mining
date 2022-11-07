import 'package:lifemine/src/data/invalid_json_exception.dart';

/// A single option for use in a select, dropdown, radio or similar input
class SelectOption {
  SelectOption({
    required this.value,
    this.type,
  });

  final String value;
  final String? type;

  static SelectOption fromJson(Map<String, Object?> json) {
    if (json['value'] == null) {
      throw InvalidJsonException(message: 'SelectOption.value is required');
    }
    return SelectOption(
      value: json['value']! as String,
      type: json['type'] as String?,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'value': value,
      if (type != null) 'type': type,
    };
  }

  static List<SelectOption>? selectOptionsFromJson(List<dynamic>? json) {
    if (json == null) {
      return null;
    }
    List<SelectOption> result = [];
    for (var field in json) {
      if (field is Map<String, Object?>) {
        result.add(SelectOption.fromJson(field));
      }
    }
    return result;
  }

  static List<Map<String, Object?>> jsonFromSelectOptions(
      List<SelectOption> options) {
    List<Map<String, Object?>> result = [];
    for (SelectOption option in options) {
      result.add(option.toJson());
    }
    return result;
  }
}
