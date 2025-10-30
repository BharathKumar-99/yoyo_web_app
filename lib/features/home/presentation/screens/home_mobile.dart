import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/presentation/home_view_model.dart';

import '../widget/widgets.dart';

Widget homeMobile(HomeViewModel viewModel) => Scaffold(
  appBar: HomeWidgets.homeAppBarMobile(),
  body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          spacing: 30,
          children: [
            HomeWidgets.schoolHeading(),
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
                  'Average Score',
                  '${viewModel.avrageScore}%',
                  '8%',
                ),
              ],
            ),
            FilterSection(viewModel: viewModel),
            HomeWidgets.schoolWidget(viewModel, isMobile: true),
          ],
        ),
      ),
    ),
  ),
);
