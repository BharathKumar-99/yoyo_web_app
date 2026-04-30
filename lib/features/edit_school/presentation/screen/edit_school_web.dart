import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school_view_model.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/widget/edit_school_widget.dart';

editSchoolWeb(EditSchoolViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
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
              Expanded(
                child: Column(
                  spacing: 20,
                  children: [
                    EditSchoolWidget.editSchoolFirstRow(viewModel),
                    EditSchoolWidget.editSchoolSecondRow(viewModel),
                    EditSchoolWidget.editSchoolthirdRow(viewModel),
                    EditSchoolWidget.updateSchoolDataBtn(viewModel),
                  ],
                ),
              ),
              Expanded(child: EditSchoolWidget.schoolImage(viewModel)),
            ],
          ),

          EditSchoolWidget.editSchoolStat(),
          EditSchoolWidget.editSchoolstats(viewModel),
          EditSchoolWidget.classText(viewModel),
          EditSchoolWidget.addClassBtn(viewModel),
          EditSchoolWidget.addWidget(viewModel),
          ClassTable(
            classes: viewModel.commonViewModel.selectedSchool?.classes ?? [],
          ),
        ],
      ),
    ),
  ),
);
