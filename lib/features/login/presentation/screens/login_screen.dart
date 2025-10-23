import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/login/presentation/screens/login_screen_mobile.dart';
import 'package:yoyo_web_app/features/login/presentation/screens/login_screen_tablet.dart';
import 'package:yoyo_web_app/features/login/presentation/screens/login_screen_website.dart';
import 'package:yoyo_web_app/features/login/presentation/login_view_model.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
      child: ResponsiveLayout(
        mobile: loginMobile(context),
        tablet: loginTablet(context),
        desktop: loginWeb(context),
      ),
    );
  }
}
