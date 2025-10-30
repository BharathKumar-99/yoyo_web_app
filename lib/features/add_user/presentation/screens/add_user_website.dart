import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_user/presentation/widgets/widgets.dart';
import '../../../home/presentation/widget/widgets.dart';
import '../add_user_view_model.dart';

addUserWebsite(AddUserViewModel viewModel) => Scaffold(
  appBar: HomeWidgets.homeAppBar(),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 20,
        children: [
          Row(
            spacing: 20,
            children: [
              Expanded(child: AddUserWidgets.firstNameTextField(viewModel)),
              Expanded(child: AddUserWidgets.lastNameTextField(viewModel)),
              Expanded(child: AddUserWidgets.emailTextField(viewModel)),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(child: AddUserWidgets.userType(viewModel)),
              Expanded(child: AddUserWidgets.schoolSelector(viewModel)),
              Expanded(child: AddUserWidgets.classSelector(viewModel)),
            ],
          ),
          (viewModel.selectedUserType == 'Teacher')
              ? Row(
                  spacing: 20,
                  children: [
                    Expanded(child: AddUserWidgets.selectJob(viewModel)),
                    Expanded(
                      child: AddUserWidgets.selectPermisionLvl(viewModel),
                    ),
                  ],
                )
              : Row(
                  spacing: 20,
                  children: [
                    Expanded(child: AddUserWidgets.selectLevel(viewModel)),
                    Expanded(child: Container()),
                    Expanded(child: Container()),
                  ],
                ),

          AddUserWidgets.elevatedBtn(viewModel),
        ],
      ),
    ),
  ),
);
