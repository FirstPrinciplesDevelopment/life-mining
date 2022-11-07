import 'package:flutter/material.dart';
import 'package:lifemine/src/service.dart';
import 'package:lifemine/src/view_models/model_view_model.dart';
import 'package:lifemine/src/widgets/model_form.dart';
import 'package:provider/provider.dart';

class ModelCreateScreen extends StatefulWidget {
  const ModelCreateScreen({Key? key}) : super(key: key);

  @override
  _ModelCreateScreenState createState() => _ModelCreateScreenState();
}

class _ModelCreateScreenState extends State<ModelCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Model'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ModelForm(
            submitButtonText: 'Create',
            modelVM: ModelViewModel(),
            onSubmit: createModel,
          ),
        ),
      ),
    );
  }

  void createModel(ModelViewModel modelViewModel) {
    Provider.of<DataService>(context, listen: false)
        .createModel(modelViewModel.toJson());
    Navigator.popUntil(context, ModalRoute.withName('/models'));
  }
}
