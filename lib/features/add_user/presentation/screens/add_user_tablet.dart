import 'package:flutter/material.dart';
import '../../../common/widgets.dart'; 
import '../add_user_view_model.dart';
import '../widgets/widgets.dart';

addUserTablet(AddUserViewModel viewModel) => Scaffold(
  appBar:  CommonWidgets.homeAppBar(),
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
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(child: AddUserWidgets.emailTextField(viewModel)),
              Expanded(child: AddUserWidgets.userType(viewModel)),
            ],
          ),
          Row(
            spacing: 20,
            children: [
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
                  ],
                ),

          AddUserWidgets.elevatedBtn(viewModel),
        ],
      ),
    ),
  ),
);
