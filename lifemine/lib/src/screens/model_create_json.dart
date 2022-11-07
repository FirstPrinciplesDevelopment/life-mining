import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lifemine/src/data/invalid_json_exception.dart';
import 'package:lifemine/src/service.dart';
import 'package:lifemine/src/view_models/model_view_model.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class ModelCreateJsonScreen extends StatefulWidget {
  const ModelCreateJsonScreen({Key? key}) : super(key: key);

  @override
  _ModelCreateJsonScreenState createState() => _ModelCreateJsonScreenState();
}

class _ModelCreateJsonScreenState extends State<ModelCreateJsonScreen> {
  final TextEditingController jsonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Model From JSON'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(maxWidth: 600),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Model Json'),
                  controller: jsonController,
                  maxLines: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              child: OutlinedButton(
                onPressed: () => createModelFromJson(jsonController.text),
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue)),
                child: const Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createModelFromJson(String s) {
    Map<String, Object?> json;
    String? error;
    try {
      json = jsonDecode(s);
      // create Model from json with placeholder documentId
      Model model = Model.fromJson(json, '');
      // create Model view model from Model
      ModelViewModel modelVM = ModelViewModel(model: model);
      Provider.of<DataService>(context, listen: false)
          .createModel(modelVM.toJson());
      Navigator.popUntil(context, ModalRoute.withName('/models'));
    } on FormatException {
      error = 'Badly formatted JSON.';
    } on InvalidJsonException {
      error = 'Invalid Model definition.';
    } catch (e) {
      error = 'Something went wrong.';
    } finally {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
