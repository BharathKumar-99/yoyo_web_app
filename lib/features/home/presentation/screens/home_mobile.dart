import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/presentation/home_view_model.dart';

import '../../../common/widgets.dart';
import '../widget/student_table.dart';
import '../widget/widgets.dart';

Widget homeMobile(HomeViewModel viewModel, BuildContext context) => Scaffold(
  appBar: CommonWidgets.homeAppBarMobile(),
  floatingActionButton: viewModel.commonViewModel.selectedSchool != null
      ? ElevatedButton(
          onPressed: () => viewModel.pdfCreater(),
          child: Text('Generate PDF'),
        )
      : null,
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
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
                  '5%',
                ),
                HomeWidgets.homeCard(
                  'Effort',
                  viewModel.effort.toString(),
                  '15%',
                ),
                HomeWidgets.homeCard(
                  'Avg. Score',
                  '${viewModel.avrageScore}%',
                  '8%',
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
