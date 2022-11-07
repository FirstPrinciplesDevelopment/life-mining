import 'package:flutter/material.dart';
import 'package:lifemine/src/data.dart';
import 'package:lifemine/src/widgets/error.dart';
import 'package:lifemine/src/widgets/loading.dart';
import 'package:lifemine/src/widgets/record_list.dart';
import 'package:provider/provider.dart';

import '../service.dart';
import '../widgets/record_list.dart';

class RecordListScreen extends StatelessWidget {
  const RecordListScreen({
    required this.modelId,
    Key? key,
  }) : super(key: key);

  final String modelId;

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<DataService>(context);

    return FutureBuilder<Model?>(
        future: service.getModelById(modelId),
        builder: (context, modelSnapshot) {
          if (modelSnapshot.hasError) {
            return const ErrorIndicator(errorMessage: 'Something went wrong.');
          }

          if (modelSnapshot.hasData &&
              modelSnapshot.connectionState == ConnectionState.done) {
            if (modelSnapshot.data == null) {
              return ErrorIndicator(
                errorMessage: 'There are no records.',
                floatingActionButton: FloatingActionButton(
                  onPressed: () => Navigator.pushNamed(context,
                      '/models/${modelSnapshot.data!.id}/records/create'),
                  child: const Icon(
                    Icons.add,
                    size: 40,
                  ),
                ),
              );
            }
            return FutureBuilder<List<Map<String, Object?>>>(
              future: service.getRecords(modelId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
                if (snapshot.hasError) {
                  return const ErrorIndicator(
                      errorMessage: 'Something went wrong.');
                }

                if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return ErrorIndicator(
                    errorMessage: 'There are no records.',
                    floatingActionButton: FloatingActionButton(
                      onPressed: () => Navigator.pushNamed(context,
                          '/models/${modelSnapshot.data!.id}/records/create'),
                      child: const Icon(
                        Icons.add,
                        size: 40,
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(modelSnapshot.data!.name),
                    ),
                    body: RecordList(
                      model: modelSnapshot.data!,
                      records: snapshot.data ?? [],
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () => Navigator.pushNamed(context,
                          '/models/${modelSnapshot.data!.id}/records/create'),
                      child: const Icon(
                        Icons.add,
                        size: 40,
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
}
