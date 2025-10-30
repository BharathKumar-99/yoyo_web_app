import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/widgets/widgets.dart';
import '../dashboard_view_model.dart';

Widget dashboardTab(DashboardViewModel dashboardVM, Widget body) => Scaffold(
  body: SafeArea(
    child: Row(
      children: [
        DashboardWidget.tabDrawer(dashboardVM),
        Expanded(child: body),
      ],
    ),
  ),
);
