import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/home/presentation/home_view_model.dart';
import 'package:yoyo_web_app/features/home/presentation/screens/home_mobile.dart';
import 'package:yoyo_web_app/features/home/presentation/screens/home_tablet.dart';
import 'package:yoyo_web_app/features/home/presentation/screens/home_website.dart';

import '../../../core/widgets/responsive_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, value, w) => ResponsiveLayout(
          mobile: homeMobile(value, context),
          tablet: homeTablet(value, context),
          desktop: homeWebsite(value, context),
        ),
      ),
    );
  }
}
