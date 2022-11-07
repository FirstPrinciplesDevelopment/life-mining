import 'package:flutter/material.dart';

import '../data.dart';

class SelectOptionViewModel {
  SelectOptionViewModel({SelectOption? selectOption}) {
    valueController = TextEditingController(text: selectOption?.value);
    typeController = TextEditingController(text: selectOption?.type);
  }

  late TextEditingController valueController;
  late TextEditingController typeController;

  Map<String, Object?> toJson() {
    return {
      'value': valueController.text,
      'type': typeController.text,
    };
  }

  static List<Map<String, Object?>> listToJson(
      List<SelectOptionViewModel> selectOptions) {
    List<Map<String, Object?>> result = [];
    for (SelectOptionViewModel opt in selectOptions) {
      result.add(opt.toJson());
    }
    return result;
  }
}
