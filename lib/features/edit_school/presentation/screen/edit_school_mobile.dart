import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school_view_model.dart';

import '../../../../config/router/navigation_helper.dart';
import '../widget/edit_school_widget.dart';

editSchoolMobile(EditSchoolViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBarMobile(),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          EditSchoolWidget.editSchoolFirstRow(viewModel),
          EditSchoolWidget.editSchoolSecondRow(viewModel),
          EditSchoolWidget.editSchoolthirdRow(viewModel),
          EditSchoolWidget.schoolImage(viewModel),
          EditSchoolWidget.updateSchoolDataBtn(viewModel),
          EditSchoolWidget.editSchoolStat(),
          EditSchoolWidget.editSchoolStatsMobile(viewModel),
          EditSchoolWidget.classText(viewModel),
          EditSchoolWidget.addClassBtn(viewModel),
          EditSchoolWidget.addWidget(viewModel),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.sizeOf(ctx!).width * 2,
              child: ClassTable(
                classes:
                    viewModel.commonViewModel.selectedSchool?.classes ?? [],
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
