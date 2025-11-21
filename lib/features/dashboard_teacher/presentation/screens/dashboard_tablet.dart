
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/dashboard_teacher/presentation/teacher_view_model.dart';
import 'package:yoyo_web_app/features/dashboard_teacher/presentation/widgets/widgets.dart';

Widget dashboardTab(TeacherViewModel dashboardVM, Widget body) => Scaffold(
  body: SafeArea(
    child: Row(
      children: [
        TeacherWidget.tabDrawer(dashboardVM),
        Expanded(child: body),
      ],
    ),
  ),
);
