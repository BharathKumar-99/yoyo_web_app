import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/send_notification/presentation/widgets/send_notification_widget.dart';
import 'package:yoyo_web_app/features/send_notification/presentation/widgets/student_table.dart';
import '../send_notification_view_model.dart';

sendNotificationWebsite(SendNotificationViewModel provider) => Scaffold(
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
        Row(
          spacing: 10,
          children: [
            Expanded(child: SendNotificationWidget.titleTextfield(provider)),
            Expanded(child: SendNotificationWidget.bodyTextfield(provider)),
          ],
        ),
        NotificationStudentTable(
          students: provider.userModel,
          provider: provider,
        ),
      ],
    ),
  ),
);
