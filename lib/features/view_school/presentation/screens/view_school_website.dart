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
                  Expanded(
                    flex: 3,
                    child: ViewSchoolWidget.schoolImage(viewModel),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ViewSchoolWidget.schoolName(viewModel),
                            Spacer(),
                            ViewSchoolWidget.schoolStudents(viewModel),
                            Spacer(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ViewSchoolWidget.schoolTelephone(viewModel),
                            Spacer(),
                            ViewSchoolWidget.schoolprinciple(viewModel),
                            Spacer(),
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
