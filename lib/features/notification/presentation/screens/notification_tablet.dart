import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/notification/presentation/notification_view_model.dart';

import '../notification_settings.dart';
import 'notification_desktop.dart';

notificationTablet(NotificationViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBar(isTablet: true),
  body: DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        flexibleSpace: Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            isScrollable: true,
            labelPadding: const EdgeInsets.only(right: 20),
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'Notifications'),
              Tab(text: 'Notification Logs'),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(29.0),
        child: TabBarView(
          children: [
            NotificationSettings(viewModel: viewModel),
            NotificationLogs(viewModel: viewModel),
          ],
        ),
      ),
    ),
  ),
);
