import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';

import '../send_notification_view_model.dart';
import 'send_notification_widget.dart';
import 'student_table.dart';

sendNotificationTablet(SendNotificationViewModel provider) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
  floatingActionButton: provider.selectedSchool != null
      ? ElevatedButton(
          onPressed: () => provider.sendNotification(),
          child: Text('Send'),
        )
      : null,
  body: SingleChildScrollView(
    child: Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SendNotificationWidget.header(),
        if (provider.commonViewModel.teacher?.teacher?.isEmpty ?? true)
          SendNotificationWidget.schoolDropDown(provider),
        SendNotificationWidget.titleTextfield(provider),
        SendNotificationWidget.bodyTextfield(provider),
        NotificationStudentTable(
          students: provider.userModel,
          provider: provider,
        ),
      ],
    ),
  ),
);
