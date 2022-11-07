import 'package:flutter/material.dart';
import 'package:lifemine/src/constants.dart';

import '../data.dart';
import '../view_models.dart';

class FieldWidgetViewModel {
  FieldWidgetViewModel({FieldWidget? widget}) {
    type = widget?.type ?? Constants.defaultFieldWidgetType;
    maxController = TextEditingController(text: widget?.max.toString());
    minController = TextEditingController(text: widget?.min.toString());
    maxLabelController = TextEditingController(text: widget?.maxLabel);
    minLabelController = TextEditingController(text: widget?.minLabel);
    stepController = TextEditingController(text: widget?.step.toString());
    numericDefaultController =
        TextEditingController(text: widget?.numericDefault.toString());
    stringDefaultController =
        TextEditingController(text: widget?.stringDefault);
    optionList = widget?.optionList
        ?.map((o) => SelectOptionViewModel(selectOption: o))
        .toList();
    auto = widget?.auto;
    isRequired = widget?.isRequired;
    maxLengthController =
        TextEditingController(text: widget?.maxLength?.toString());
  }

  late String type;
  num? get max =>
      maxController.text.isEmpty ? null : num.parse(maxController.text);
  late TextEditingController maxController;
  num? get min =>
      minController.text.isEmpty ? null : num.parse(minController.text);
  late TextEditingController minController;
  String? get maxLabel => maxLabelController.text;
  late TextEditingController maxLabelController;
  String? get minLabel => minLabelController.text;
  late TextEditingController minLabelController;
  num? get step =>
      stepController.text.isEmpty ? null : num.parse(stepController.text);
  late TextEditingController stepController;
  num? get numericDefault => numericDefaultController.text.isEmpty
      ? null
      : num.parse(numericDefaultController.text);
  late TextEditingController numericDefaultController;
  String? get stringDefault => stringDefaultController.text;
  late TextEditingController stringDefaultController;
  List<SelectOptionViewModel>? optionList;
  bool? auto;
  bool? isRequired;
  int? get maxLength => maxLengthController.text.isEmpty
      ? null
      : int.parse(maxLengthController.text);
  late TextEditingController maxLengthController;

  Map<String, Object?> toJson() {
    // note: always include type even if it's the default, for clarity
    return {
      'type': type,
      if (max != FieldWidget.defaultMax && max != null) 'max': max,
      if (min != FieldWidget.defaultMin && min != null) 'min': min,
      if (maxLabel?.isNotEmpty ?? false) 'maxLabel': maxLabel,
      if (minLabel?.isNotEmpty ?? false) 'minLabel': minLabel,
      if (step != FieldWidget.defaultStep && step != null) 'step': step,
      if (numericDefault != FieldWidget.defaultNumericDefault &&
          numericDefault != null)
        'numericDefault': numericDefault,
      if (stringDefault?.isNotEmpty ?? false) 'stringDefault': stringDefault,
      if (optionList?.isNotEmpty ?? false)
        'options': SelectOptionViewModel.listToJson(optionList!),
      if (auto != FieldWidget.defaultAuto && auto != null) 'auto': auto,
      if (isRequired != FieldWidget.defaultIsRequired && isRequired != null)
        'isRequired': isRequired,
      if (maxLength != null) 'maxLength': maxLength,
    };
  }
}
