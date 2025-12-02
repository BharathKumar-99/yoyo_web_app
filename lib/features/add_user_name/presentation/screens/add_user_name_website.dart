import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/add_user_name_view_model.dart';
import '../../../common/widgets.dart';
import '../widget/widgets.dart';

addUserNameScreenWeb(AddUserNameViewModel value) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          AddUserNameWidget.getHeader(),
          Row(
            spacing: 20,
            children: [
              Expanded(child: AddUserNameWidget.addXl(value)),
              Expanded(child: AddUserNameWidget.schoolSelector(value)),
              Expanded(child: AddUserNameWidget.classSelector(value)),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(child: AddUserNameWidget.selectLevel(value)),
              Expanded(child: Container()),
              Expanded(child: Container()),
            ],
          ),

          AddUserNameWidget.userTable(value.list),
          AddUserNameWidget.addUserNameBtn(value),
        ],
      ),
    ),
  ),
);
