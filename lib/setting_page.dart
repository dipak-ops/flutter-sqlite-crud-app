import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_database/theme_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Setting'),
        ),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return SwitchListTile.adaptive(
            title: const Text("Dark Mode"),
            subtitle: const Text("Change theme mode here"),
            value: provider.getThemeValue(),
            onChanged: (value) {
              provider.updateTheme(value: value);
            },
          );
        },
      ),
    );
  }
}