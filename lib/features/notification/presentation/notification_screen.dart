import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/core/widgets/responsive_screen.dart';
import 'package:yoyo_web_app/features/notification/presentation/notification_view_model.dart';
import 'package:yoyo_web_app/features/notification/presentation/screens/notification_desktop.dart';
import 'package:yoyo_web_app/features/notification/presentation/screens/notification_tablet.dart';

import 'screens/notification_mobile.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(),
      child: Consumer<NotificationViewModel>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(29.0),
          child: ResponsiveLayout(
            mobile: notificationMobile(value),
            tablet: notificationTablet(value),
            desktop: notificationDesktop(value),
          ),
        ),
      ),
    );
  }
}
