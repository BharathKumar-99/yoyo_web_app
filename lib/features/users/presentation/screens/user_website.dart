import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/users/presentation/admin_table.dart';
import 'package:yoyo_web_app/features/users/presentation/user_tables.dart';
import 'package:yoyo_web_app/features/users/presentation/user_teacher_table.dart';
import 'package:yoyo_web_app/features/users/presentation/widgets/add_single_teacher.dart';
import 'package:yoyo_web_app/features/users/presentation/widgets/widgets.dart';
import '../../../common/widgets.dart';
import '../users_view_model.dart';

Widget userWebsite(UsersViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
  body: Padding(
    padding: const EdgeInsets.all(29.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserWidgets.userHeading(viewModel),
          UserWidgets.userDrop(viewModel, false, false),
          UserWidgets.addSingleStudent(viewModel),
          AddSingleTeacher(viewModel: viewModel),
          SizedBox(height: 20),
          (viewModel.selectedUserType == 'Student')
              ? StudentUserTable(
                  student: viewModel.teacher
                      .where(
                        (user) =>
                            (user.studentClasses != null ||
                                (user.teacher?.isNotEmpty ?? false)) &&
                            user.isAdmin != true,
                      )
                      .toList(),
                )
              : (viewModel.selectedUserType == 'Teacher')
              ? TeacherUserTable(
                  teacher: viewModel.teacher
                      .where(
                        (user) =>
                            (user.teacher != null &&
                                (user.teacher?.isNotEmpty ?? false)) &&
                            user.isAdmin != true,
                      )
                      .toList(),
                )
              : AdminUserTable(
                  student: viewModel.teacher
                      .where((user) => user.isAdmin == true)
                      .toList(),
                ),
        ],
      ),
    ),
  ),
);
