import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/widgets/widgets.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import '../dashboard_view_model.dart';

Widget dashboardMobile(DashboardViewModel dashboardVM, Widget body) {
  OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
  );

  // Reusable "All" dropdown item
  DropdownMenuItem<T?> allItem<T>() =>
      DropdownMenuItem<T>(value: null, child: Text("All"));
  return Consumer<CommonViewModel>(
    builder: (context, commonViewModel, w) {
      return Scaffold(
        bottomNavigationBar: DashboardWidget.bottomNavBar(dashboardVM),
        appBar: AppBar(
          flexibleSpace: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(ImageConstants.logoBW),
                Row(
                  spacing: 10,
                  children: [
                    if (commonViewModel.teacher?.teacher?.isEmpty ?? true)
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField<School?>(
                          initialValue: commonViewModel.selectedSchool,
                          isExpanded: true,
                          selectedItemBuilder: (context) => [
                            allItem<School>(),
                            ...commonViewModel.schools.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.schoolName ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.textTheme.bodyMedium!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                          items: [
                            allItem<School>(),
                            ...commonViewModel.schools.map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.schoolName ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.textTheme.bodyMedium!
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) => commonViewModel.selectSchool(val),
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
                      ),
                    Icon(Icons.settings_outlined, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: body,
      );
    },
  );
}
