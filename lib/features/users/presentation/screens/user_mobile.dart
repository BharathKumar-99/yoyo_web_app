import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';

import '../users_view_model.dart';
import '../widgets/widgets.dart';

Widget userMobile(UsersViewModel viewModel) => Padding(
  padding: const EdgeInsets.all(29.0),
  child: Scaffold(
    appBar: CommonWidgets.homeAppBarMobile(),
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 29.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserWidgets.userHeading(),
            SizedBox(height: 20),
            UserWidgets.userTable(viewModel),
          ],
        ),
      ),
    ),
  ),
);
