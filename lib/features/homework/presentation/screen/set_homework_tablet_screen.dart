import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets.dart';
import '../set_homework_viewmodel.dart';
import '../widgets/auto_set_homework.dart';
import '../widgets/set_homework.dart';

class SetHomeworkTabletScreen extends StatelessWidget {
  const SetHomeworkTabletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SetHomeworkViewmodel>(
      builder: (context, value, child) => Scaffold(
        appBar: CommonWidgets.homeAppBar(isTablet: false),
        body:
            value.commonViewModel.selectedSchool == null ||
                value.commonViewModel.selectedClass == null
            ? Center(child: Text('Please Select a School And Class'))
            : DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    bottom: TabBar(
                      isScrollable: true,
                      labelPadding: const EdgeInsets.only(right: 20),
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: "Set Homework"),
                        Tab(text: "Auto Homework"),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      SetHomeworkTab(value),
                      AutoSetHomework(value: value),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
