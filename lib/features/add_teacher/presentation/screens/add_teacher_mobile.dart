import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_teacher/presentation/add_teacher_view_model.dart';
import 'package:yoyo_web_app/features/add_teacher/presentation/widgets/widgets.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';

addTeacherMobile(AddTeacherViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBarMobile(),
  body: Padding(
    padding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          AddTeacherWidgets.addTeacher(),
          AddTeacherWidgets.firstNameTextField(viewModel),
          AddTeacherWidgets.lastNameTextField(viewModel),
          AddTeacherWidgets.usernameTextField(viewModel),
          AddTeacherWidgets.emailTextField(viewModel),
          AddTeacherWidgets.jobTextField(viewModel),
          AddTeacherWidgets.permissionDropDown(viewModel),
          AddTeacherWidgets.schoolSelector(viewModel),
          AddTeacherWidgets.classSelector(viewModel),
        ],
      ),
    ),
  ),
);
