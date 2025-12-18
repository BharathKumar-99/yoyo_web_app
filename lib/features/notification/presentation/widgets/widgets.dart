import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/notification/model/activation_model.dart';
import 'package:yoyo_web_app/features/notification/presentation/notification_view_model.dart';

class NotificationWidget {
  static header() =>
      Text('Activation Codes', style: AppTextStyles.textTheme.headlineLarge);

  static activationList(NotificationViewModel notification) =>
      notification.activationModel.isEmpty
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
            ActivationRequestModel model = notification.activationModel[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      '${model.username}',
                      style: AppTextStyles.textTheme.titleLarge,
                    ),
                    Text(' has requested for activation code'),
                  ],
                ),
                subtitle: Text(model.code ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        notification.generateCode(index);
                      },
                      child: Text("Generate"),
                    ),
                    if (model.code != null)
                      ElevatedButton(
                        onPressed: () {
                          notification.update(index);
                        },
                        child: Text("Update"),
                      ),
                  ],
                ),
              ),
            );
          },
        );
}
