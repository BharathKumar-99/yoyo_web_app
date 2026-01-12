import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/send_notification/presentation/send_notification_view_model.dart';

import '../../../home/model/school.dart';

class SendNotificationWidget {
  static header() =>
      Text('Send Notification', style: AppTextStyles.textTheme.headlineLarge);

  static titleTextfield(SendNotificationViewModel provider) => TextField(
    controller: provider.title,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Title",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.title),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static bodyTextfield(SendNotificationViewModel provider) => TextField(
    controller: provider.body,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Body",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.notifications),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static schoolDropDown(SendNotificationViewModel provider) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );

    DropdownMenuItem<T?> allItem<T>() =>
        DropdownMenuItem<T>(value: null, child: Text("All"));
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'School',
            style: AppTextStyles.textTheme.headlineMedium!.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<School?>(
            initialValue: provider.selectedSchool,
            items: [
              allItem<School>(),
              ...provider.schools.map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e.schoolName ?? '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            onChanged: (val) => provider.selectSchool(val),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: const BorderSide(
                  color: Color(0xff9D5DE6),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 
}
