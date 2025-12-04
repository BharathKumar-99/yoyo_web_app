import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/view_school/presentation/screens/view_school_mobile.dart';
import 'package:yoyo_web_app/features/view_school/presentation/screens/view_school_tablet.dart';
import 'package:yoyo_web_app/features/view_school/presentation/screens/view_school_website.dart';
import 'package:yoyo_web_app/features/view_school/presentation/view_school_view_model.dart';

class ViewSchoolScreen extends StatelessWidget {
  final int schoolId;
  const ViewSchoolScreen({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ViewSchoolViewModel>(
      create: (_) => ViewSchoolViewModel(schoolId),
      child: Consumer<ViewSchoolViewModel>(
        builder: (context, viewModel, child) => viewModel.loading
            ? Container()
            : ResponsiveLayout(
                mobile: viewSchoolMobile(viewModel),
                tablet: viewSchooltablet(viewModel),
                desktop: viewSchoolWebsite(viewModel),
              ),
      ),
    );
  }
}
