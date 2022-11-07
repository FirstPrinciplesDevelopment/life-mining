import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lifemine/src/data.dart';
import 'package:lifemine/src/service.dart';
import 'package:lifemine/src/widgets/error.dart';
import 'package:lifemine/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class ModelJsonScreen extends StatefulWidget {
  const ModelJsonScreen({Key? key, required this.modelId}) : super(key: key);

  final String modelId;

  @override
  _ModelJsonScreenState createState() => _ModelJsonScreenState();
}

class _ModelJsonScreenState extends State<ModelJsonScreen> {
  final int jsonIndent = 4;

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
                child: SingleChildScrollView(
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: TextField(
                        maxLines: 200,
                        controller: TextEditingController(
                            text: JsonEncoder.withIndent(' ' * jsonIndent)
                                .convert(snapshot.data!.toJson())),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return const LoadingIndicator();
        });
  }
}
