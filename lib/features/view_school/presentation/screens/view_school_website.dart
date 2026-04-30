import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/view_school/presentation/view_school_view_model.dart';
import 'package:yoyo_web_app/features/view_school/presentation/widgets/widgets.dart';

Widget viewSchoolWebsite(ViewSchoolViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(29.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [
          Text('Schools', style: Theme.of(ctx!).textTheme.headlineMedium),
          AddSchoolBtn(viewModel: viewModel),
          ViewSchoolWidgets().addWidgetWeb(viewModel),
          SchoolTable(school: viewModel.school ?? []),
        ],
      ),
    ),
  ),
);
