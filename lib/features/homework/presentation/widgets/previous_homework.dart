import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/homework/model/homework_model.dart';

import 'previous_homework_table.dart';

class PreviousHomework extends StatelessWidget {
  final List<HomeworkModel> homeList;
  final int studentCount;
  const PreviousHomework(this.homeList, this.studentCount, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.home_outlined),
            Text(
              'Previous Homework',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        PreviousHomeworkTable(homework: homeList, studentLength: studentCount),
      ],
    );
  }
}
