import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school_view_model.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/widget/edit_school_widget.dart';

editSchoolWeb(EditSchoolViewModel viewModel) => Scaffold(
  // appBar: CommonWidgets.homeAppBar(),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          EditSchoolWidget.editSchool(),
          Row(
            spacing: 20,
            children: [
              Expanded(child: EditSchoolWidget.schoolImage(viewModel)),
              Expanded(
                child: Column(
                  spacing: 20,
                  children: [
                    Row(
                      spacing: 20,
                      children: [
                        Expanded(child: EditSchoolWidget.schoolName(viewModel)),
                        Expanded(
                          child: EditSchoolWidget.schoolStudents(viewModel),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: EditSchoolWidget.schoolTelephone(viewModel),
                        ),
                        Expanded(
                          child: EditSchoolWidget.schoolPrinciple(viewModel),
                        ),
                      ],
                    ),
                    EditSchoolWidget.schoolAddress(viewModel),
                    EditSchoolWidget.updateSchoolDataBtn(viewModel),
                  ],
                ),
              ),
            ],
          ),
          EditSchoolWidget.editSchool(),
          EditSchoolWidget.streak(viewModel),
          EditSchoolWidget.matery(viewModel),
          EditSchoolWidget.warmup(viewModel),
          EditSchoolWidget.getSlack(viewModel),
        ],
      ),
    ),
  ),
);
