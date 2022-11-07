import 'package:flutter/material.dart';
import '../data.dart';
import '../view_models.dart';

class ModelViewModel {
  ModelViewModel({Model? model}) {
    nameController = TextEditingController(text: model?.name);
    descriptionController = TextEditingController(text: model?.description);
    options = ModelOptionsViewModel(modelOptions: model?.options);
    fields = model?.fields.map((f) => FieldViewModel(field: f)).toList();
  }

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late ModelOptionsViewModel options;
  late List<FieldViewModel>? fields;

  Map<String, Object?> toJson() {
    return {
      'name': nameController.text,
      'description': descriptionController.text,
      'options': options.toJson(),
      'fields': FieldViewModel.listToJson(fields),
    };
  }
}
