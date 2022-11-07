import 'package:flutter/material.dart';
import 'package:lifemine/src/data.dart';
import 'package:lifemine/src/service.dart';
import 'package:lifemine/src/widgets/error.dart';
import 'package:lifemine/src/widgets/loading.dart';
import 'package:lifemine/src/widgets/record_form.dart';
import 'package:lifemine/src/widgets/record_form_field.dart';
import 'package:provider/provider.dart';

class RecordEditScreen extends StatefulWidget {
  const RecordEditScreen({
    Key? key,
    required this.modelId,
    required this.recordId,
  }) : super(key: key);

  final String modelId;
  final String recordId;

  @override
  _RecordEditScreenState createState() => _RecordEditScreenState();
}

class _RecordEditScreenState extends State<RecordEditScreen> {
  @override
  Widget build(BuildContext context) {
    final service = Provider.of<DataService>(context, listen: false);

    return FutureBuilder<Model?>(
        future: service.getModelById(widget.modelId),
        builder: (context, modelSnapshot) {
          if (modelSnapshot.hasError) {
            return const ErrorIndicator(errorMessage: 'Something went wrong.');
          }

          if (modelSnapshot.hasData &&
              modelSnapshot.connectionState == ConnectionState.done) {
            if (modelSnapshot.data == null) {
              return const ErrorIndicator(
                  errorMessage: 'Record does not exist.');
            }
            return FutureBuilder(
              future: service.getRecord(
                widget.modelId,
                widget.recordId,
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const ErrorIndicator(
                      errorMessage: 'Something went wrong.');
                }

                if (snapshot.hasData && snapshot.data == null) {
                  return const ErrorIndicator(
                      errorMessage: 'Record does not exist.');
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(modelSnapshot.data!.name),
                    ),
                    body: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: RecordForm(
                          model: modelSnapshot.data!,
                          submitButtonText: 'Update',
                          onSubmit: updateRecord,
                          record: snapshot.data! as Map<String, Object?>?,
                        ),
                      ),
                    ),
                  );
                }

                return const LoadingIndicator();
              },
            );
          }

          return const LoadingIndicator();
        });
  }

  void updateRecord(List<RecordFormField> fields, String modelId) {
    Map<String, Object?> map = <String, Object?>{};
    for (RecordFormField field in fields) {
      map[field.field.name] = field.value;
    }
    Provider.of<DataService>(context, listen: false).updateRecord(
      modelId,
      widget.recordId,
      map,
    );
    Navigator.popUntil(
        context, ModalRoute.withName('/models/:modelId/records'));
  }
}
