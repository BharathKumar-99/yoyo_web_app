import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/screens/dashboard_mobile.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/screens/dashboard_tablet.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/screens/dashboard_web.dart';

class DashboardScreen extends StatelessWidget {
  final Widget child;
  const DashboardScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardViewModel>(
      create: (_) => DashboardViewModel(),
      child: Consumer<DashboardViewModel>(
        builder: (context, value, w) => ResponsiveLayout(
          mobile: dashboardMobile(value, child),
          tablet: dashboardTab(value, child),
          desktop: dashboardWeb(value, child),
        ),
      ),
    );
  }
}
