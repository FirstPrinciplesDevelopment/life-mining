import 'package:flutter/material.dart';
import 'package:lifemine/src/data.dart';
import 'package:lifemine/src/widgets/error.dart';
import 'package:lifemine/src/widgets/loading.dart';
import 'package:lifemine/src/widgets/record_form.dart';
import 'package:lifemine/src/widgets/record_form_field.dart';
import 'package:provider/provider.dart';

import '../service.dart';

class RecordCreateScreen extends StatefulWidget {
  const RecordCreateScreen({Key? key, required this.modelId}) : super(key: key);

  final String modelId;

  @override
  _RecordCreateScreenState createState() => _RecordCreateScreenState();
}

class _RecordCreateScreenState extends State<RecordCreateScreen> {
  @override
  Widget build(BuildContext context) {
    DataService service = Provider.of<DataService>(context, listen: false);

    return FutureBuilder<Model?>(
        future: service.getModelById(widget.modelId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorIndicator(errorMessage: 'Something went wrong.');
          }

          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) {
              return const ErrorIndicator(
                  errorMessage: 'Model does not exist.');
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(snapshot.data!.name),
              ),
              body: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: RecordForm(
                    model: snapshot.data!,
                    submitButtonText: 'Create',
                    onSubmit: createRecord,
                  ),
                ),
              ),
            );
          }

          return const LoadingIndicator();
        });
  }

  void createRecord(List<RecordFormField> fields, String modelId) {
    Map<String, Object?> map = <String, Object?>{};
    for (RecordFormField field in fields) {
      map[field.field.name] = field.value;
    }
    Provider.of<DataService>(context, listen: false).createRecord(
      modelId,
      map,
    );
    Navigator.pop(context);
  }
}
