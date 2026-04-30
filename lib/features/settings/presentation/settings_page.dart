import 'package:flutter/material.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/settings/presentation/data_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: settingsMobile(),
      tablet: settingsTablet(),
      desktop: settingsDesktop(),
    );
  }
}
