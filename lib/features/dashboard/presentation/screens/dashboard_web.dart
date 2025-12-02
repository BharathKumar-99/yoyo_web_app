import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/widgets/widgets.dart';
import '../dashboard_view_model.dart';

Widget dashboardWeb(DashboardViewModel dashboardVM, Widget body) => Scaffold(
  body: SafeArea(
    child: Row(
      children: [
        SizedBox(width: 250, child: DashboardWidget.drawer(dashboardVM)),
        Expanded(child: body),
      ],
    ),
  ),
);
