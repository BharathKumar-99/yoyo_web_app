import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/notification/presentation/notification_view_model.dart';
import 'package:yoyo_web_app/features/notification/presentation/widgets/widgets.dart';

notificationDesktop(NotificationViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
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
