import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/users/presentation/screens/user_mobile.dart';
import 'package:yoyo_web_app/features/users/presentation/screens/user_tablet.dart';
import 'package:yoyo_web_app/features/users/presentation/screens/user_website.dart';

import '../../../core/widgets/responsive_screen.dart';
import 'users_view_model.dart';

class UsersScreens extends StatelessWidget {
  const UsersScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UsersViewModel>(
      create: (_) => UsersViewModel(),
      child: Consumer<UsersViewModel>(
        builder: (context, value, w) => ResponsiveLayout(
          mobile: userMobile(value),
          tablet: userTablet(value),
          desktop: userWebsite(value),
        ),
      ),
    );
  }
}
