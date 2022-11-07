import 'package:flutter/material.dart';
import 'package:lifemine/src/data.dart';
import 'package:lifemine/src/widgets/error.dart';
import 'package:lifemine/src/widgets/loading.dart';
import 'package:lifemine/src/widgets/model_form.dart';
import 'package:provider/provider.dart';

import '../service.dart';
import '../view_models.dart';

class ModelEditScreen extends StatefulWidget {
  const ModelEditScreen({Key? key, required this.modelId}) : super(key: key);

  final String modelId;

  @override
  _ModelEditScreenState createState() => _ModelEditScreenState();
}

class _ModelEditScreenState extends State<ModelEditScreen> {
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
                  child: ModelForm(
                    submitButtonText: 'Update',
                    modelVM: ModelViewModel(model: snapshot.data),
                    onSubmit: (viewModel) {
                      // check if there are any records
                      showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Warning!'),
                                content: const Text(
                                    'Any records created with the previous model version will be deleted!'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => updateModel(
                                        viewModel, snapshot.data!.id),
                                    child: const Text(
                                      'Confirm',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ));
                    },
                  ),
                ),
              ),
            );
          }

          return const LoadingIndicator();
        });
  }

  void updateModel(ModelViewModel modelViewModel, String modelId) {
    Provider.of<DataService>(context, listen: false)
        .updateModel(modelViewModel.toJson(), modelId);
    Navigator.popUntil(context, ModalRoute.withName('/models'));
  }
}
