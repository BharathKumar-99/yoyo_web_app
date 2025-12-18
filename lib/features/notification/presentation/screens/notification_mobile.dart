import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/notification/presentation/notification_view_model.dart';

import '../widgets/widgets.dart';

notificationMobile(NotificationViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBarMobile(),
  body: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NotificationWidget.header(),
        NotificationWidget.activationList(viewModel),
      ],
    ),
  ),
);
