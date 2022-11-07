import 'package:flutter/material.dart';
import 'package:lifemine/src/screens.dart';
import 'package:lifemine/src/service.dart';
import 'package:provider/provider.dart';

import 'settings/settings_controller.dart';

/// Main App class.
class App extends StatefulWidget {
  const App({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  _AppState createState() => _AppState();
}

/// State for the main [App] class.
class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: widget.settingsController),
        ChangeNotifierProvider(create: (_) => DataService())
      ],
      child: AnimatedBuilder(
        animation: widget.settingsController,
        builder: (context, child) => MaterialApp(
          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          darkTheme: ThemeData.dark(),
          themeMode: widget.settingsController.themeMode,
          // https://gist.github.com/johnpryan/48984061c8eddf507db8bee87e30f7fc
          onGenerateRoute: (RouteSettings settings) {
            var uri = Uri.parse(settings.name ?? '/models');

            switch (uri.path) {
              case '/':
              case '/models':
                return MaterialPageRoute(
                  settings: const RouteSettings(name: '/models'),
                  builder: (context) => const ModelsScreen(),
                );
              case '/settings':
                return MaterialPageRoute(
                  settings: const RouteSettings(name: '/settings'),
                  builder: (context) => const SettingsScreen(),
                );
              case '/models/create':
                return MaterialPageRoute(
                  settings: const RouteSettings(name: '/models/create'),
                  builder: (context) => const ModelCreateScreen(),
                );
              case '/models/fromjson':
                return MaterialPageRoute(
                  settings: const RouteSettings(name: '/models/fromjson'),
                  builder: (context) => const ModelCreateJsonScreen(),
                );
            }
            if (uri.pathSegments.first == 'models') {
              String modelId = uri.pathSegments[1];
              // Handle '/models/:modelId/*'
              if (uri.pathSegments.length == 3) {
                // 'models/:modelId/json'
                if (uri.pathSegments[2] == 'json') {
                  return MaterialPageRoute(
                    settings: const RouteSettings(
                      name: '/models/:modelId/json',
                    ),
                    builder: (context) => ModelJsonScreen(modelId: modelId),
                  );
                }
                // 'models/:modelId/edit'
                else if (uri.pathSegments[2] == 'edit') {
                  return MaterialPageRoute(
                    settings: const RouteSettings(
                      name: '/models/:modelId/edit',
                    ),
                    builder: (context) => ModelEditScreen(modelId: modelId),
                  );
                }
                // '/models/:modelId/records'
                else if (uri.pathSegments[2] == 'records') {
                  return MaterialPageRoute(
                    settings: const RouteSettings(
                      name: '/models/:modelId/records',
                    ),
                    builder: (context) => RecordListScreen(modelId: modelId),
                  );
                }
              } else if (uri.pathSegments.length == 4 &&
                  uri.pathSegments[3] == 'create') {
                return MaterialPageRoute(
                  settings: const RouteSettings(
                    name: '/models/:modelId/records/create',
                  ),
                  builder: (context) => RecordCreateScreen(modelId: modelId),
                );
              } else if (uri.pathSegments.length == 5 &&
                  uri.pathSegments[4] == 'edit') {
                String recordId = uri.pathSegments[3];
                return MaterialPageRoute(
                  settings: const RouteSettings(
                    name: '/models/:modelId/records/:recordId/edit',
                  ),
                  builder: (context) =>
                      RecordEditScreen(modelId: modelId, recordId: recordId),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
