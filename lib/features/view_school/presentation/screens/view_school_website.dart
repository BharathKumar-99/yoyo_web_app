import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/view_school/presentation/view_school_view_model.dart';
import 'package:yoyo_web_app/features/view_school/presentation/widgets/widgets.dart';

Widget viewSchoolWebsite(ViewSchoolViewModel viewModel) => Padding(
  padding: const EdgeInsets.all(29.0),
  child: Scaffold(
    appBar: CommonWidgets.homeAppBar(),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 29.0),
        child: Column(
          spacing: 30,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(ctx!).height / 3,
              child: Row(
                children: [
                  Expanded(child: ViewSchoolWidget.schoolImage(viewModel)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ViewSchoolWidget.schoolName(viewModel),
                            ViewSchoolWidget.schoolStudents(viewModel),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ViewSchoolWidget.schoolTelephone(viewModel),
                            ViewSchoolWidget.schoolprinciple(viewModel),
                          ],
                        ),
                        ViewSchoolWidget.schoolAddress(viewModel),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (viewModel.school?.classes?.isNotEmpty ?? false)
              ReusableUserTable(school: viewModel.school),
          ],
        ),
      ),
    ),
  ),
);
