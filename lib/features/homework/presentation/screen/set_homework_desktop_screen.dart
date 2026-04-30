import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/homework/presentation/set_homework_viewmodel.dart';
import 'package:yoyo_web_app/features/homework/presentation/widgets/auto_set_homework.dart';

import '../../../common/widgets.dart';
import '../widgets/set_homework.dart';

class SetHomeworkDesktopScreen extends StatelessWidget {
  const SetHomeworkDesktopScreen({super.key});

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
                    flexibleSpace: TabBar(
                      padding: EdgeInsets.all(0),
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
