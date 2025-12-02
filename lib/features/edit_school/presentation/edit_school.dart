import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school_view_model.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/screen/edit_school_mobile.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/screen/edit_school_tablet.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/screen/edit_school_web.dart';

class EditSchoolScreen extends StatelessWidget {
  final int id;
  const EditSchoolScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditSchoolViewModel>(
      create: (_) => EditSchoolViewModel(id),
      child: Consumer<EditSchoolViewModel>(
        builder: (context, viewModel, w) => viewModel.loading
            ? Container()
            : ResponsiveLayout(
                mobile: editSchoolMobile(viewModel),
                tablet: editSchoolTablet(viewModel),
                desktop: editSchoolWeb(viewModel),
              ),
      ),
    );
  }
}
