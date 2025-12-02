import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';

import 'screens/dashboard_mobile.dart';
import 'screens/dashboard_tablet.dart';
import 'screens/dashboard_website.dart';
import 'teacher_view_model.dart';

class TeacherDashboard extends StatelessWidget {
  final Widget child;
  const TeacherDashboard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TeacherViewModel>(
      create: (_) => TeacherViewModel(),
      child: Consumer<TeacherViewModel>(
        builder: (context, value, w) => ResponsiveLayout(
          mobile: dashboardMobile(value, child),
          tablet: dashboardTab(value, child),
          desktop: dashboardWeb(value, child),
        ),
      ),
    );
  }
}
