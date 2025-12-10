import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/settings/presentation/settings_view_model.dart';

settingsMobile(SettingsViewModel value) =>
    Scaffold(appBar: CommonWidgets.homeAppBarMobile(), body: data(value));
settingsTablet(SettingsViewModel value) =>
    Scaffold(appBar: CommonWidgets.homeAppBar(), body: data(value));
settingsDesktop(SettingsViewModel value) =>
    Scaffold(appBar: CommonWidgets.homeAppBar(), body: data(value));

data(SettingsViewModel value) {
  OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
  );

  return Consumer<SettingsViewModel>(
    builder: (ctx, value, w) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: IntrinsicWidth(
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
                  DropdownButtonFormField<School>(
                    initialValue: value.selectedSchool,
                    items: [
                      ...value.schools.map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.schoolName ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (val) => value.selectSchool(val!),
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
            ),
          ),
          Expanded(
            child: EditSchoolScreen(
              key: ValueKey(value.selectedSchool.id),
              id: value.selectedSchool.id ?? 0,
            ),
          ),
        ],
      );
    },
  );
}
