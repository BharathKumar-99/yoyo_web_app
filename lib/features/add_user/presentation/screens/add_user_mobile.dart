import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_user/presentation/add_user_view_model.dart';

import '../../../home/presentation/widget/widgets.dart';
import '../widgets/widgets.dart';

addUserMobile(AddUserViewModel viewModel) => Scaffold(
  appBar: HomeWidgets.homeAppBarMobile(),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 20,
        children: [
          AddUserWidgets.firstNameTextField(viewModel),
          AddUserWidgets.lastNameTextField(viewModel),
          AddUserWidgets.emailTextField(viewModel),
          AddUserWidgets.userType(viewModel),
          AddUserWidgets.schoolSelector(viewModel),
          AddUserWidgets.classSelector(viewModel),
          (viewModel.selectedUserType == 'Teacher')
              ? Column(
                  spacing: 20,
                  children: [
                    AddUserWidgets.selectJob(viewModel),
                    AddUserWidgets.selectPermisionLvl(viewModel),
                  ],
                )
              : Column(
                  spacing: 20,
                  children: [AddUserWidgets.selectLevel(viewModel)],
                ),
          AddUserWidgets.elevatedBtn(viewModel),
        ],
      ),
    ),
  ),
);
