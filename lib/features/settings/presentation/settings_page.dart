import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/settings/presentation/data_page.dart';
import 'package:yoyo_web_app/features/settings/presentation/settings_view_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsViewModel>(
      create: (_) => SettingsViewModel(),
      child: Consumer<SettingsViewModel>(
        builder: (context, value, wid) => value.schools.isEmpty
            ? Center(child: CircularProgressIndicator.adaptive())
            : ResponsiveLayout(
                mobile: settingsMobile(value),
                tablet: settingsTablet(value),
                desktop: settingsDesktop(value),
              ),
      ),
    );
  }
}
