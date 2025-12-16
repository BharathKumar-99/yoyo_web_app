import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/add_teacher/presentation/add_teacher_view_model.dart';
import 'package:yoyo_web_app/features/add_teacher/presentation/screens/add_teacher_desktop.dart';
import 'package:yoyo_web_app/features/add_teacher/presentation/screens/add_teacher_mobile.dart';
import 'package:yoyo_web_app/features/add_teacher/presentation/screens/add_teacher_tablet.dart';

class AddTeacherScreen extends StatelessWidget {
  const AddTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddTeacherViewModel>(
      create: (_) => AddTeacherViewModel(),
      child: Consumer<AddTeacherViewModel>(
        builder: (context, value, child) => ResponsiveLayout(
          mobile: addTeacherMobile(value),
          tablet: addTeacherTablet(value),
          desktop: addTeacherDesktop(value),
        ),
      ),
    );
  }
}
