import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/add_school/presentation/add_school_view_model.dart';
import 'package:yoyo_web_app/features/add_school/presentation/screens/add_school_mobile.dart';
import 'package:yoyo_web_app/features/add_school/presentation/screens/add_school_tablet.dart';
import 'package:yoyo_web_app/features/add_school/presentation/screens/add_school_website.dart';

class AddSchoolScreen extends StatelessWidget {
  const AddSchoolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddSchoolViewModel>(
      create: (_) => AddSchoolViewModel(),
      child: Consumer<AddSchoolViewModel>(
        builder: (context, value, child) => ResponsiveLayout(
          mobile: addSchoolMobile(value),
          tablet: addSchoolTablet(value),
          desktop: addSchoolWebsite(value),
        ),
      ),
    );
  }
}
