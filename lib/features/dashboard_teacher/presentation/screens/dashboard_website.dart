import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/dashboard_teacher/presentation/teacher_view_model.dart';
import 'package:yoyo_web_app/features/dashboard_teacher/presentation/widgets/widgets.dart';

Widget dashboardWeb(TeacherViewModel dashboardVM, Widget body) => Scaffold(
  body: SafeArea(
    child: Row(
      children: [
        SizedBox(width: 250, child: TeacherWidget.drawer(dashboardVM)),
        Expanded(child: body),
      ],
    ),
  ),
);
