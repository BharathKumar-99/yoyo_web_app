import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/add_user_name_view_model.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/widget/widgets.dart';

import '../../../common/widgets.dart';

addUserNameScreenMobile(AddUserNameViewModel value) => Scaffold(
  appBar: CommonWidgets.homeAppBarMobile(),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              AddUserNameWidget.getHeader(),
              AddUserNameWidget.addXl(value),
              AddUserNameWidget.schoolSelector(value),
              AddUserNameWidget.classSelector(value),
              AddUserNameWidget.selectLevel(value),
              AddUserNameWidget.userTable(value.list),
              AddUserNameWidget.addUserNameBtn(value),
            ],
          ),
        ),
      ),
    ),
  ),
);
