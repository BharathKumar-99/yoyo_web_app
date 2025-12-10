import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school_view_model.dart';

import '../widget/edit_school_widget.dart';

editSchoolMobile(EditSchoolViewModel viewModel) => Scaffold(
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          EditSchoolWidget.editSchool(),
          EditSchoolWidget.schoolImage(viewModel),
          EditSchoolWidget.schoolName(viewModel),
          EditSchoolWidget.schoolStudents(viewModel),
          EditSchoolWidget.schoolTelephone(viewModel),
          EditSchoolWidget.schoolPrinciple(viewModel),
          EditSchoolWidget.schoolAddress(viewModel),
          EditSchoolWidget.updateSchoolDataBtn(viewModel),
          EditSchoolWidget.editSchool(),
          EditSchoolWidget.streak(viewModel),
          EditSchoolWidget.matery(viewModel),
          EditSchoolWidget.getSlack(viewModel),
        ],
      ),
    ),
  ),
);
