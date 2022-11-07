import 'package:lifemine/src/data/invalid_json_exception.dart';

import 'field_widget.dart';

/// A single field of a model
class Field {
  Field({
    required this.name,
    required this.widget,
    this.showOnList = false,
  });

  final String name;
  final FieldWidget? widget;
  final bool showOnList;

  static Field fromJson(Map<String, Object?> json) {
    if (json['name'] == null) {
      throw InvalidJsonException(message: 'Field.name field is required.');
    }
    return Field(
      name: json['name']! as String,
      widget: FieldWidget.fromJson(
        json['widget'] as Map<String, Object?>?,
        json['name']! as String,
      ),
      showOnList: (json['showOnList'] ?? false) as bool,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'name': name,
      if (widget != null) 'widget': widget?.toJson(),
      if (showOnList) 'showOnList': showOnList
    };
  }

  static List<Field> fieldsFromJson(List<dynamic> json) {
    List<Field> result = [];
    for (var field in json) {
      if (field is Map<String, Object?>) {
        result.add(Field.fromJson(field));
      }
    }
    return result;
  }

  static List<Map<String, Object?>> jsonFromFields(List<Field> fields) {
    List<Map<String, Object?>> result = [];
    for (Field field in fields) {
      result.add(field.toJson());
    }
    return result;
  }
}
