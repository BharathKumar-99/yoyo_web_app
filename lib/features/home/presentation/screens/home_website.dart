import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/presentation/home_view_model.dart';
import 'package:yoyo_web_app/features/home/presentation/widget/widgets.dart';

import '../../../common/widgets.dart';
import '../widget/student_table.dart';

Widget homeWebsite(HomeViewModel viewModel, BuildContext context) => Padding(
  padding: const EdgeInsets.all(29.0),
  child: Scaffold(
    appBar: CommonWidgets.homeAppBar(),
    floatingActionButton: viewModel.commonViewModel.selectedSchool != null
        ? ElevatedButton(
            onPressed: () => viewModel.pdfCreater(),
            child: Text('Generate PDF'),
          )
        : null,

    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 29.0),
        child: Column(
          spacing: 30,
          children: [
            // HomeWidgets.schoolHeading(),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: HomeWidgets.getFilters(viewModel),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      spacing: 20,

                      children: [
                        Expanded(
                          child: HomeWidgets.homeCard(
                            'Participation',
                            '${viewModel.participation}%',
                            '5%',
                          ),
                        ),
                        Expanded(
                          child: HomeWidgets.homeCard(
                            'Effort',
                            viewModel.effort.toString(),
                            '15%',
                          ),
                        ),
                        Expanded(
                          child: HomeWidgets.homeCard(
                            'Avg. Score',
                            '${viewModel.avrageScore}%',
                            '8%',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 180,
                      child: Column(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: HomeWidgets.getWordsCard(
                              viewModel.topGoodWords,
                              viewModel.goodWords.toSet().toList(),
                            ),
                          ),
                          Expanded(
                            child: HomeWidgets.getWordsCard(
                              viewModel.topBadWords,
                              viewModel.badWords.toSet().toList(),
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StudentTable(
              students: viewModel.filteredStudents,
              provider: viewModel,
            ),
          ],
        ),
      ),
    ),
  ),
);
