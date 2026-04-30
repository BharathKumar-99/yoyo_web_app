import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/view_school/presentation/view_school_view_model.dart';
import 'package:yoyo_web_app/features/view_school/presentation/widgets/widgets.dart';

Widget viewSchoolMobile(ViewSchoolViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBarMobile(),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(29.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [
          Text('Schools', style: Theme.of(ctx!).textTheme.headlineMedium),
          AddSchoolBtn(viewModel: viewModel),
          ViewSchoolWidgets().addWidgetMob(viewModel),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.sizeOf(ctx!).width * 3,
              child: SchoolTable(school: viewModel.school ?? []),
            ),
          ),
        ],
      ),
    ),
  ),
);
