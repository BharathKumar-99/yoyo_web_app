import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/edit_user/presentation/edit_user_view_model.dart';
import 'package:yoyo_web_app/features/edit_user/presentation/widget/edit_user_desktop.dart';
import 'package:yoyo_web_app/features/edit_user/presentation/widget/edit_user_mobile.dart';
import 'package:yoyo_web_app/features/edit_user/presentation/widget/edit_user_tablet.dart';

class EditUserScreen extends StatelessWidget {
  final String userId;
  const EditUserScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditUserViewModel>(
      create: (_) => EditUserViewModel(userId),
      child: Consumer<EditUserViewModel>(
        builder: (context, value, child) => value.isLoading
            ? Container()
            : ResponsiveLayout(
                mobile: editUserMobile(value),
                tablet: editUserTablet(value),
                desktop: editUserDesktop(value),
              ),
      ),
    );
  }
}
