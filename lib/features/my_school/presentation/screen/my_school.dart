import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school.dart';
import 'package:yoyo_web_app/features/view_school/presentation/view_school_screen.dart';

class MySchool extends StatelessWidget {
  const MySchool({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonViewModel>(
      builder: (context, value, child) => value.selectedSchool != null
          ? EditSchoolScreen(id: value.selectedSchool?.id ?? 0)
          : ViewSchoolScreen(),
    );
  }
}
