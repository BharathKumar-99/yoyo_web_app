import 'package:flutter/material.dart';
import '../../../common/widgets.dart';
import '../users_view_model.dart';
import '../widgets/widgets.dart';

Widget userTablet(UsersViewModel viewModel) => Padding(
  padding: const EdgeInsets.all(29.0),
  child: Scaffold(
    appBar: CommonWidgets.homeAppBar(),
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 29.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
