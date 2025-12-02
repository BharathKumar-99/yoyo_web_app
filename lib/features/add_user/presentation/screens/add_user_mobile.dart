import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_user/presentation/add_user_view_model.dart';
import '../../../common/widgets.dart';
import '../widgets/widgets.dart';

addUserMobile(AddUserViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBarMobile(),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 20,
        children: [
          AddUserWidgets.firstNameTextField(viewModel),
          AddUserWidgets.lastNameTextField(viewModel),

          // (viewModel.selectedUserType == 'Teacher')
          //     ? Column(
          //         spacing: 20,
          //         children: [
          //           AddUserWidgets.selectJob(viewModel),
          //           AddUserWidgets.selectPermisionLvl(viewModel),
          //         ],
          //       )
          //     : Column(
          //         spacing: 20,
          //         children: [AddUserWidgets.selectLevel(viewModel)],
          //       ),
          AddUserWidgets.elevatedBtn(viewModel),
        ],
      ),
    ),
  ),
);
