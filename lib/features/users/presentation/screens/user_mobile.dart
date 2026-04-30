import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/users/presentation/user_tables.dart';
import 'package:yoyo_web_app/features/users/presentation/user_teacher_table.dart';
import 'package:yoyo_web_app/features/users/presentation/widgets/add_single_teacher.dart';

import '../users_view_model.dart';
import '../widgets/widgets.dart';

Widget userMobile(UsersViewModel viewModel, BuildContext context) => Scaffold(
  appBar: CommonWidgets.homeAppBarMobile(),
  body: Padding(
    padding: const EdgeInsets.all(29.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserWidgets.userHeading(viewModel),
          UserWidgets.userDrop(viewModel, true, false),
          UserWidgets.addSingleStudent(viewModel),
          AddSingleTeacher(viewModel: viewModel),
          SizedBox(height: 20),
          (viewModel.selectedUserType == 'Student')
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 3,
                    child: StudentUserTable(
                      student: viewModel.teacher
                          .where(
                            (user) =>
                                user.teacher == null ||
                                (user.teacher?.isEmpty ?? true),
                          )
                          .toList(),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 3,
                    child: TeacherUserTable(
                      teacher: viewModel.teacher
                          .where(
                            (user) =>
                                user.teacher != null &&
                                (user.teacher?.isNotEmpty ?? false),
                          )
                          .toList(),
                    ),
                  ),
                ),
        ],
      ),
    ),
  ),
);
