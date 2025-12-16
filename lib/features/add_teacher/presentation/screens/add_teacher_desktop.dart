import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_teacher/presentation/add_teacher_view_model.dart';
import 'package:yoyo_web_app/features/add_teacher/presentation/widgets/widgets.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';

addTeacherDesktop(AddTeacherViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
  body: Padding(
    padding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          AddTeacherWidgets.addTeacher(),
          Row(
            spacing: 20,
            children: [
              Expanded(child: AddTeacherWidgets.firstNameTextField(viewModel)),
              Expanded(child: AddTeacherWidgets.lastNameTextField(viewModel)),
              Expanded(child: AddTeacherWidgets.usernameTextField(viewModel)),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(child: AddTeacherWidgets.emailTextField(viewModel)),
              Expanded(child: AddTeacherWidgets.jobTextField(viewModel)),
              Expanded(child: AddTeacherWidgets.permissionDropDown(viewModel)),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(child: AddTeacherWidgets.schoolSelector(viewModel)),
              Expanded(child: AddTeacherWidgets.classSelector(viewModel)),
            ],
          ),
        ],
      ),
    ),
  ),
  floatingActionButton: ElevatedButton(
    onPressed: () => viewModel.addTeacher(),
    child: Text('Add Teacher'),
  ),
);
