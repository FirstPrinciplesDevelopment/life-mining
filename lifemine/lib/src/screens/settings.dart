import 'package:flutter/material.dart';
import 'package:lifemine/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Theme:',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButton<ThemeMode>(
                // Read the selected themeMode from the controller
                value: Provider.of<SettingsController>(context, listen: false)
                    .themeMode,
                // Call the updateThemeMode method when a user selects a theme.
                onChanged:
                    Provider.of<SettingsController>(context, listen: false)
                        .updateThemeMode,
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark Theme'),
                  )
                ],
              ),
            ),
          ],
        ),
      );
}
