import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/add_user_name_view_model.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/screens/add_user_name_mobile.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/screens/add_user_name_tablet.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/screens/add_user_name_website.dart';

import '../../../core/widgets/responsive_screen.dart';

class AddUserNameScreen extends StatelessWidget {
  const AddUserNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => AddUserNameViewModel(),
        child: Consumer<AddUserNameViewModel>(
          builder: (context, value, w) => ResponsiveLayout(
            mobile: addUserNameScreenMobile(value),
            tablet: addUserNameScreenTablet(value),
            desktop: addUserNameScreenWeb(value),
          ),
        ),
      ),
    );
  }
}
