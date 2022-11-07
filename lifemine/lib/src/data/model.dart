import 'package:lifemine/src/data/invalid_json_exception.dart';

import 'field.dart';
import 'model_options.dart';

/// A model defines the fields, UI, and options of an entity that can be tracked
class Model {
  Model({
    required this.id,
    required this.name,
    this.description,
    required this.options,
    required this.fields,
  });

  static Model fromJson(Map<String, Object?> json, String documentId) {
    if (json['name'] == null) {
      throw InvalidJsonException(message: 'Model.name is required.');
    }
    if (json['options'] == null) {
      throw InvalidJsonException(message: 'Model.options are required.');
    }
    if (json['fields'] == null) {
      throw InvalidJsonException(message: 'Model.fields are required.');
    }
    return Model(
      id: documentId,
      name: json['name']! as String,
      description: json['description'] as String?,
      options: ModelOptions.fromJson(json['options']! as Map<String, Object?>),
      fields: Field.fieldsFromJson(json['fields']! as List<dynamic>),
    );
  }

  final String id;
  final String name;
  final String? description;
  final ModelOptions options;
  final List<Field> fields;
  // final List<Visualization> visualizations;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'options': options.toJson(),
      'fields': Field.jsonFromFields(fields),
    };
  }
}
