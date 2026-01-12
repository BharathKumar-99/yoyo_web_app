import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/send_notification/presentation/widgets/send_notification_mobile.dart';
import 'package:yoyo_web_app/features/send_notification/presentation/widgets/send_notification_tablet.dart';
import 'package:yoyo_web_app/features/send_notification/presentation/widgets/send_notification_website.dart';

import '../../../core/widgets/responsive_screen.dart';
import 'send_notification_view_model.dart';

class SendNotificationScreen extends StatelessWidget {
  const SendNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SendNotificationViewModel(),
      child: Consumer<SendNotificationViewModel>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.all(29.0),
          child: ResponsiveLayout(
            mobile: sendNotificationMobile(value),
            tablet: sendNotificationTablet(value),
            desktop: sendNotificationWebsite(value),
          ),
        ),
      ),
    );
  }
}
