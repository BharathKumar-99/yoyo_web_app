import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';

import '../set_homework_viewmodel.dart';
import 'set_homework_desktop_screen.dart';
import 'set_homework_mobile_screen.dart';
import 'set_homework_tablet_screen.dart';

class SetHomeworkScreen extends StatelessWidget {
  const SetHomeworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonViewModel>(
      builder: (context, common, s) {
        return Consumer<SetHomeworkViewmodel>(
          builder: (context, value, child) => ResponsiveLayout(
            mobile: SetHomeworkMobileScreen(),
            tablet: SetHomeworkTabletScreen(),
            desktop: SetHomeworkDesktopScreen(),
          ),
        );
      },
    );
  }
}
