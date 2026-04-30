import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/presentation/home_view_model.dart';

import '../../../common/widgets.dart';
import '../widget/student_table.dart';
import '../widget/widgets.dart';

Widget homeTablet(HomeViewModel viewModel, BuildContext context) => Scaffold(
  appBar: CommonWidgets.homeAppBar(isTablet: true),
  floatingActionButton: viewModel.commonViewModel.selectedSchool != null
      ? ElevatedButton(
          onPressed: viewModel.pdfCreater,
          child: Text('Generate PDF'),
        )
      : null,
  body: Padding(
    padding: const EdgeInsets.all(29.0),
    child: SingleChildScrollView(
      child: Column(
        spacing: 30,
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: HomeWidgets.getFilters(viewModel),
          ),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            children: [
              HomeWidgets.homeCard(
                'Participation',
                '${viewModel.participation}%',
                '${viewModel.participationPercentage}%',
              ),
              HomeWidgets.homeCard(
                'Effort',
                viewModel.effort.toString(),
                '${viewModel.effortPercentage}%',
              ),
              HomeWidgets.homeCard(
                'Avg. Score',
                '${viewModel.avrageScore}%',
                '${viewModel.avrageScorePercentage}%',
              ),
            ],
          ),
          SizedBox(
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
          StudentTable(students: viewModel.students, provider: viewModel),
        ],
      ),
    ),
  ),
);
