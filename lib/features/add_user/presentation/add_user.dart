import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/add_user/presentation/add_user_view_model.dart';
import 'package:yoyo_web_app/features/add_user/presentation/screens/add_user_mobile.dart';
import 'package:yoyo_web_app/features/add_user/presentation/screens/add_user_tablet.dart';
import 'package:yoyo_web_app/features/add_user/presentation/screens/add_user_website.dart';

class AddUserScreen extends StatelessWidget {
  final bool? isTeacher;
  const AddUserScreen({super.key, this.isTeacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => AddUserViewModel(),
        child: Consumer<AddUserViewModel>(
          builder: (context, value, w) => ResponsiveLayout(
            mobile: addUserMobile(value),
            tablet: addUserTablet(value),
            desktop: addUserWebsite(value),
          ),
        ),
      ),
    );
  }
}
