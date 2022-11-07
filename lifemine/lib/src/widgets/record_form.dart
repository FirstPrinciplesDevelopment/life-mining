import 'package:flutter/material.dart';

import '../data.dart';
import 'record_form_field.dart';

/// Function called when the RecordForm's submit button is pressed
typedef OnSubmit = void Function(List<RecordFormField> fields, String modelId);

class RecordForm extends StatefulWidget {
  const RecordForm({
    Key? key,
    required this.model,
    required this.submitButtonText,
    required this.onSubmit,
    this.record,
  }) : super(key: key);

  final Model model;
  final String submitButtonText;
  final OnSubmit onSubmit;
  final Map<String, Object?>? record;

  @override
  _RecordFormState createState() => _RecordFormState();
}

class _RecordFormState extends State<RecordForm> {
  final _formKey = GlobalKey<FormState>();
  final List<RecordFormField> _fields = <RecordFormField>[];

  @override
  void initState() {
    super.initState();
    for (Field field in widget.model.fields) {
      _fields.add(RecordFormField(
        field: field,
        initialValue: widget.record?[field.name],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            for (RecordFormField field in _fields)
              Padding(
                padding: const EdgeInsets.all(10),
                child: field,
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              child: OutlinedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(_fields, widget.model.id);
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
}
