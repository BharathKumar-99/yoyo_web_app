import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/add_user_name_view_model.dart';

import '../../../common/widgets.dart';
import '../widget/widgets.dart';

addUserNameScreenTablet(AddUserNameViewModel value) => Scaffold(
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
              Expanded(child: AddUserNameWidget.getUserTextfield(value)),
              Expanded(child: AddUserNameWidget.schoolSelector(value)),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(child: AddUserNameWidget.classSelector(value)),
              Expanded(child: AddUserNameWidget.selectLevel(value)),
            ],
          ),
          AddUserNameWidget.addUserNameBtn(value),
        ],
      ),
    ),
  ),
);
