import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/presentation/home_view_model.dart';
import 'package:yoyo_web_app/features/home/presentation/widget/widgets.dart';

import '../../../common/widgets.dart';

Widget homeWebsite(HomeViewModel viewModel) => Padding(
  padding: const EdgeInsets.all(29.0),
  child: Scaffold(
    appBar: CommonWidgets.homeAppBar(),
    body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 29.0),
      child: Column(
        spacing: 30,
        children: [
          HomeWidgets.schoolHeading(),
          Row(
            children: [
              Expanded(
                child: Wrap(
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
                      'Average Score',
                      '${viewModel.avrageScore}%',
                      '8%',
                    ),
                  ],
                ),
              ),
              Expanded(child: FilterSection(viewModel: viewModel)),
            ],
          ),
          HomeWidgets.schoolWidget(viewModel),
        ],
      ),
    ),
  ),
);
