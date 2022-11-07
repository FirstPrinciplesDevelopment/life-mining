import 'package:flutter/material.dart';
import 'package:lifemine/src/data.dart';

import 'field_widget_view_model.dart';

class FieldViewModel {
  FieldViewModel({Field? field}) {
    nameController = TextEditingController(text: field?.name);
    showOnList = field?.showOnList;
    fieldWidget = FieldWidgetViewModel(widget: field?.widget);
  }

  late TextEditingController nameController;
  bool? showOnList;
  late FieldWidgetViewModel fieldWidget;

  Map<String, Object?> toJson() {
    return {
      'name': nameController.text,
      'showOnList': showOnList,
      'widget': fieldWidget.toJson(),
    };
  }

  static List<Map<String, Object?>> listToJson(List<FieldViewModel>? fields) {
    List<Map<String, Object?>> result = [];
    for (FieldViewModel field in fields ?? []) {
      result.add(field.toJson());
    }
    return result;
  }
}
