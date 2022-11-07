import 'package:flutter/material.dart';
import 'package:lifemine/src/data.dart';
import 'package:lifemine/src/widgets/error.dart';
import 'package:lifemine/src/widgets/loading.dart';
import 'package:provider/provider.dart';

import '../service.dart';
import '../widgets/model_list.dart';

class ModelsScreen extends StatelessWidget {
  const ModelsScreen({Key? key}) : super(key: key);

  final String title = 'Models';

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<DataService>(context);

    return FutureBuilder<List<Model>>(
      future: service.getModels(),
      builder: (BuildContext context, AsyncSnapshot<List<Model>> snapshot) {
        if (snapshot.hasError) {
          return const ErrorIndicator(errorMessage: 'Something is wrong.');
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return ErrorIndicator(
            errorMessage: 'There are no models.',
            appBar: buildAppBar(title, context),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: buildAppBar(title, context),
            body: ModelList(
              initialModels: snapshot.data ?? [],
              onTap: (model) {
                Navigator.pushNamed(context, '/models/${model.id}/records');
              },
              onTrack: (model) {
                Navigator.pushNamed(
                    context, '/models/${model.id}/records/create');
              },
              onChart: (model) {
                // TODO: future versions will support visualizations
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Not yet implemented.'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              onViewJson: (model) {
                Navigator.pushNamed(context, '/models/${model.id}/json');
              },
              onEditModel: (model) {
                Navigator.pushNamed(context, '/models/${model.id}/edit');
              },
            ),
          );
        }

        return const LoadingIndicator();
      },
    );
  }

  AppBar buildAppBar(String title, BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (String result) {
            switch (result) {
              case 'new_model':
                Navigator.pushNamed(context, '/models/create');
                break;
              case 'new_model_from_json':
                Navigator.pushNamed(context, '/models/fromjson');
                break;
              case 'settings':
                Navigator.pushNamed(context, '/settings');
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'new_model',
              child: Text('New Model'),
            ),
            const PopupMenuItem<String>(
              value: 'new_model_from_json',
              child: Text('New Model From JSON'),
            ),
            const PopupMenuItem<String>(
              value: 'settings',
              child: Text('Settings'),
            ),
          ],
        ),
      ],
    );
  }
}
