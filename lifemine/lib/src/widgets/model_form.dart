import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../view_models.dart';

/// Function called when the ModelForm's submit button is pressed
typedef OnSubmit = void Function(ModelViewModel modelViewModel);

class ModelForm extends StatefulWidget {
  const ModelForm({
    Key? key,
    required this.modelVM,
    required this.submitButtonText,
    required this.onSubmit,
  }) : super(key: key);

  final ModelViewModel modelVM;
  final String submitButtonText;
  final OnSubmit onSubmit;

  @override
  _ModelFormState createState() => _ModelFormState();
}

class _ModelFormState extends State<ModelForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // General
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'General',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: TextFormField(
                    controller: widget.modelVM.nameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(labelText: 'Name'),
                    maxLength: 30,
                    validator: (value) {
                      if ((value ?? '').isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: TextFormField(
                    controller: widget.modelVM.descriptionController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLength: 120,
                  ),
                ),
              ],
            ),
            // Fields
            SizedBox(
              width: 600,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Fields',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  if (widget.modelVM.fields != null)
                    for (FieldViewModel field in widget.modelVM.fields!)
                      // Field Form
                      Stack(
                        children: [
                          Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            margin: const EdgeInsets.all(4),
                            child: Column(
                              children: [
                                // Name, Delete
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: TextFormField(
                                          controller: field.nameController,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                              labelText: 'Name'),
                                          maxLength: 30,
                                          validator: (value) {
                                            if ((value ?? '').isEmpty) {
                                              return 'Name is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Type, Required
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Column(
                                          children: [
                                            const Text('Type'),
                                            DropdownButton<String>(
                                              value: field.fieldWidget.type,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  field.fieldWidget.type = value ??
                                                      Constants
                                                          .defaultFieldWidgetType;
                                                });
                                              },
                                              items: Constants
                                                  .fieldWidgetTypeList
                                                  .map((String opt) =>
                                                      DropdownMenuItem(
                                                          value: opt,
                                                          child: Text(opt)))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Checkbox(
                                              value: field
                                                      .fieldWidget.isRequired ??
                                                  false,
                                              onChanged: (value) {
                                                setState(() {
                                                  field.fieldWidget.isRequired =
                                                      value;
                                                });
                                              },
                                            ),
                                            const Text('Required'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isNumeric(field.fieldWidget.type))
                                  // Min, Max, Step
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: TextFormField(
                                            textAlign: TextAlign.end,
                                            controller:
                                                field.fieldWidget.minController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            decoration: const InputDecoration(
                                                labelText: 'Min'),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: TextFormField(
                                            textAlign: TextAlign.end,
                                            controller:
                                                field.fieldWidget.maxController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            decoration: const InputDecoration(
                                                labelText: 'Max'),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: TextFormField(
                                            textAlign: TextAlign.end,
                                            controller: field
                                                .fieldWidget.stepController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9].?[0-9]?')),
                                            ],
                                            decoration: const InputDecoration(
                                                labelText: 'Step'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (isNumeric(field.fieldWidget.type))
                                  // Min Label, Max Label
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: TextFormField(
                                            textAlign: TextAlign.end,
                                            controller: field
                                                .fieldWidget.minLabelController,
                                            decoration: const InputDecoration(
                                                labelText: 'Min Label'),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: TextFormField(
                                            textAlign: TextAlign.end,
                                            controller: field
                                                .fieldWidget.maxLabelController,
                                            decoration: const InputDecoration(
                                                labelText: 'Max Label'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                // Default, Show On List
                                Row(
                                  children: [
                                    if (isNumeric(field.fieldWidget.type))
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 15, 5),
                                          child: TextFormField(
                                            textAlign: TextAlign.end,
                                            controller: field.fieldWidget
                                                .numericDefaultController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9].?[0-9]?')),
                                            ],
                                            decoration: const InputDecoration(
                                                labelText: 'Default'),
                                          ),
                                        ),
                                      ),
                                    if (isText(field.fieldWidget.type))
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 15, 5),
                                          child: TextFormField(
                                            textAlign: TextAlign.start,
                                            controller: field.fieldWidget
                                                .stringDefaultController,
                                            decoration: const InputDecoration(
                                                labelText: 'Default'),
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Checkbox(
                                              value: field.showOnList ?? false,
                                              onChanged: (value) {
                                                setState(() {
                                                  field.showOnList = value;
                                                });
                                              },
                                            ),
                                            const Text('Show On List'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Max Length
                                Row(
                                  children: [
                                    // TODO: remove Auto
                                    // Expanded(
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.symmetric(
                                    //       horizontal: 15,
                                    //
                                    //     ),
                                    //     child: Row(
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.center,
                                    //       children: [
                                    //         Checkbox(
                                    //           value:
                                    //               field.fieldWidget.auto ?? false,
                                    //           onChanged: (value) {
                                    //             setState(() {
                                    //               field.fieldWidget.auto = value;
                                    //             });
                                    //           },
                                    //         ),
                                    //         const Text('Auto'),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    if (isText(field.fieldWidget.type))
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 0, 15, 5),
                                          child: TextFormField(
                                            textAlign: TextAlign.end,
                                            controller: field.fieldWidget
                                                .maxLengthController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            decoration: const InputDecoration(
                                                labelText: 'Max Length'),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (isSelect(field.fieldWidget.type))
                                  // Options
                                  SizedBox(
                                    width: 600,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: const Text(
                                            'Options',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        if (field.fieldWidget.optionList !=
                                            null)
                                          for (SelectOptionViewModel opt
                                              in field.fieldWidget.optionList!)
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 15,
                                                    ),
                                                    child: TextFormField(
                                                      controller:
                                                          opt.valueController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Value'),
                                                      maxLength: 30,
                                                      validator: (value) {
                                                        if ((value ?? '')
                                                            .isEmpty) {
                                                          return 'Value is required';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  tooltip: 'Remove Option',
                                                  color: Colors.red,
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () {
                                                    setState(() {
                                                      field.fieldWidget
                                                          .optionList
                                                          ?.removeWhere(
                                                              (o) => o == opt);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                        Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                field.fieldWidget.optionList ??=
                                                    [];
                                                field.fieldWidget.optionList
                                                    ?.add(
                                                        SelectOptionViewModel());
                                              });
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                  color: Colors.blue),
                                            ),
                                            child: const Text('Add Option'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              tooltip: 'Delete Field',
                              color: Colors.red,
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  widget.modelVM.fields
                                      ?.removeWhere((f) => f == field);
                                });
                              },
                            ),
                          ),
                        ],
                      ), // Add Field Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          widget.modelVM.fields ??= [];
                          widget.modelVM.fields?.add(FieldViewModel());
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue)),
                      child: const Text('Add Field'),
                    ),
                  ),
                ],
              ),
            ),
            // Options
            //ModelOptionsForm(modelVM: widget.modelVM),
            // Submit Button
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              child: OutlinedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(widget.modelVM);
                  }
                },
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue)),
                child: Text(widget.submitButtonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isNumeric(String widgetType) {
    return ['Slider', 'NumberInput'].contains(widgetType);
  }

  bool isText(String widgetType) {
    return ['Text', 'MultilineText'].contains(widgetType);
  }

  bool isSelect(String widgetType) {
    return ['Radio', 'MultiSelect', 'Select'].contains(widgetType);
  }
}
