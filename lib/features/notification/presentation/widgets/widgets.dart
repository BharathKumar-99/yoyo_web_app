import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/config/utils/date_externtion.dart';
import 'package:yoyo_web_app/features/notification/model/notification_model.dart';
import 'package:yoyo_web_app/features/notification/presentation/notification_view_model.dart';

class NotificationWidget {
  static header() => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      spacing: 30,
      children: [
        Text('Activation Codes', style: AppTextStyles.textTheme.headlineLarge),
        // GestureDetector(
        //   onTap: () => NavigationHelper.go(RouteNames.sendNotification),
        //   child: Chip(
        //     label: Text(
        //       'Send Notification',
        //       style: AppTextStyles.textTheme.headlineMedium!.copyWith(
        //         color: Colors.white,
        //       ),
        //     ),
        //     avatar: Icon(Icons.add, color: Colors.white),
        //     color: WidgetStatePropertyAll(Colors.green),
        //   ),
        // ),
      ],
    ),
  );
  static headerMobile() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SizedBox(
      width: MediaQuery.sizeOf(ctx!).width * 1.4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 30,
          children: [
            Text(
              'Activation Codes',
              style: AppTextStyles.textTheme.headlineLarge,
            ),
            GestureDetector(
              onTap: () => NavigationHelper.go(RouteNames.sendNotification),
              child: Chip(
                label: Text(
                  'Send Notification',
                  style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
                avatar: Icon(Icons.add, color: Colors.white),
                color: WidgetStatePropertyAll(Colors.green),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  static activationList(NotificationViewModel notification) =>
      notification.commonViewModel.selectedClass == null
      ? SizedBox(
          height: MediaQuery.sizeOf(ctx!).height,
          width: MediaQuery.sizeOf(ctx!).width,
          child: Center(
            child: Text(
              'Please Select Class',
              style: AppTextStyles.textTheme.headlineLarge,
            ),
          ),
        )
      : notification.activationModel.isEmpty
      ? SizedBox(
          height: MediaQuery.sizeOf(ctx!).height,
          width: MediaQuery.sizeOf(ctx!).width,
          child: Center(
            child: Text(
              'No Notification',
              style: AppTextStyles.textTheme.headlineLarge,
            ),
          ),
        )
      : ListView.builder(
          shrinkWrap: true,
          itemCount: notification.activationModel.length,
          itemBuilder: (context, index) {
            NotificationModel model = notification.activationModel[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 2,
              title: Row(
                children: [
                  Text(
                    model.username ?? '',
                    style: AppTextStyles.textTheme.titleLarge,
                  ),
                  Text(
                    model.content != null
                        ? '${model.content} @${formatDateTime(DateTime.parse(model.createdAt!))}'
                        : ' has requested for activation code @${formatDateTime(DateTime.parse(model.requestedAt!))}',
                  ),
                ],
              ),
              subtitle: Text(model.code ?? ''),
            );
          },
        );
}
