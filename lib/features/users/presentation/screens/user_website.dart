import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/users/presentation/widgets/widgets.dart';
import '../../../common/widgets.dart';
import '../users_view_model.dart';

Widget userWebsite(UsersViewModel viewModel) => Padding(
  padding: const EdgeInsets.all(29.0),
  child: Scaffold(
    appBar: CommonWidgets.homeAppBar(),
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 29.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserWidgets.userHeading(viewModel),
            SizedBox(height: 20),
            UserWidgets.userTable(viewModel),
          ],
        ),
      ),
    ),
  ),
);
