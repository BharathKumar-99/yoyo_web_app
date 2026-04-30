import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

class CommonWidgets {
  static Widget buildDropdown(
    String? label,
    List<String> items,
    Function(dynamic) onChanged,
  ) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );
    return SizedBox(
      width: 160,
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label,
              style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                color: Colors.grey,
              ),
            ),

          DropdownButtonFormField<String>(
            initialValue: items.first,
            isExpanded: true,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
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

  static AppBar homeAppBar({bool isTablet = false}) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );

    return AppBar(
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Consumer<DashboardViewModel>(
          builder: (context, dashboardVM, ws) {
            return Consumer<CommonViewModel>(
              builder: (context, commonViewModel, w) {
                return Row(
                  children: [
                    (dashboardVM.isinTabMode || isTablet)
                        ? Expanded(
                            child: Row(
                              children: [
                                if (commonViewModel.teacher?.teacher?.isEmpty ??
                                    true)
                                  Expanded(
                                    child: DropdownButtonFormField<School?>(
                                      initialValue:
                                          commonViewModel.selectedSchool,
                                      isExpanded: true,
                                      selectedItemBuilder: (context) {
                                        final items = <Widget>[];

                                        if (commonViewModel.isTeacher) {
                                          items.add(
                                            Text(
                                              "All",
                                              style: AppTextStyles
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Colors.black,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }

                                        items.addAll(
                                          commonViewModel.schools.map(
                                            (e) => Text(
                                              e.schoolName ?? '',
                                              style: AppTextStyles
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Colors.black,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        );

                                        return items;
                                      },

                                      items: [
                                        if (!commonViewModel.isTeacher)
                                          DropdownMenuItem<School?>(
                                            value: null,
                                            child: Text(
                                              "All",
                                              style: AppTextStyles
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Colors.black,
                                                  ),
                                            ),
                                          ),
                                        ...commonViewModel.schools.map(
                                          (e) => DropdownMenuItem<School?>(
                                            value: e,
                                            child: Text(
                                              e.schoolName ?? '',
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyles
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Colors.black,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      onChanged: (val) =>
                                          commonViewModel.selectSchool(val),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
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
                                SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonFormField<Classes?>(
                                    initialValue: commonViewModel.selectedClass,
                                    isExpanded: true,

                                    selectedItemBuilder: (context) {
                                      final widgets = <Widget>[];

                                      if (!commonViewModel.isTeacher) {
                                        widgets.add(
                                          Text(
                                            "All",
                                            style: AppTextStyles
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }

                                      widgets.addAll(
                                        commonViewModel.selectedSchool?.classes
                                                ?.map(
                                                  (e) => Text(
                                                    e.className ?? '',
                                                    style: AppTextStyles
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color: Colors.black,
                                                        ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ) ??
                                            [],
                                      );

                                      return widgets;
                                    },

                                    // ✅ DROPDOWN LIST (BLACK TEXT)
                                    items: [
                                      if (!commonViewModel.isTeacher)
                                        DropdownMenuItem<Classes?>(
                                          value: null,
                                          child: Text(
                                            "All",
                                            style: AppTextStyles
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ...commonViewModel.selectedSchool?.classes
                                              ?.map(
                                                (
                                                  e,
                                                ) => DropdownMenuItem<Classes?>(
                                                  value: e,
                                                  child: Text(
                                                    e.className ?? '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: AppTextStyles
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color: Colors.black,
                                                        ),
                                                  ),
                                                ),
                                              ) ??
                                          [],
                                    ],

                                    onChanged: (val) =>
                                        commonViewModel.selectClass(val),

                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                SizedBox(width: 10),
                              ],
                            ),
                          )
                        : Spacer(),
                    Text(
                      commonViewModel.teacher?.teacher?.isNotEmpty ?? false
                          ? commonViewModel.teacher?.schools?.schoolName ?? ''
                          : 'Super Admin',
                      style: AppTextStyles.textTheme.titleLarge,
                    ),
                    SizedBox(width: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: VerticalDivider(),
                    ),
                    SizedBox(width: 30),
                    Text(
                      '${commonViewModel.user?.firstName} ${commonViewModel.user?.surName}',
                      style: AppTextStyles.textTheme.titleMedium,
                    ),
                    SizedBox(width: 60),
                    GestureDetector(
                      onTap: () => NavigationHelper.go(
                        RouteNames.profile,
                        extra: commonViewModel.user?.userId ?? '',
                      ),
                      child: CircleAvatar(
                        backgroundColor: Color(0xffED8768),
                        child: Text(
                          commonViewModel.extractCaps(
                            commonViewModel.user?.username ?? '',
                          ),
                          style: AppTextStyles.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
            ),
          ),
        ),
      ),
    );
  }

  static homeAppBarMobile() {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0, // VERY IMPORTANT (Flutter 3.7+)
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent, // Material 3 divider killer
      backgroundColor: Colors.transparent,
      flexibleSpace: Consumer<CommonViewModel>(
        builder: (context, commonViewModel, w) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<CommonViewModel>(
                  builder: (context, viewModel, wid) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => NavigationHelper.go(
                          RouteNames.profile,
                          extra: viewModel.user?.userId ?? '',
                        ),
                        child: CircleAvatar(
                          backgroundColor: Color(0xffED8768),
                          child: Text(
                            viewModel.extractCaps(
                              viewModel.user?.username ?? '',
                            ),
                            style: AppTextStyles.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    'YoYo Technologies Ltd',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textTheme.titleLarge,
                  ),
                ),
                Consumer<CommonViewModel>(
                  builder: (context, viewModel, wid) {
                    return Text(
                      '${viewModel.user?.firstName} ${viewModel.user?.surName}',
                      style: AppTextStyles.textTheme.titleMedium,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
            ),
          ),
          child: Consumer<CommonViewModel>(
            builder: (context, commonViewModel, wid) {
              return Column(
                spacing: 5,
                children: [
                  Row(
                    children: [
                      if (commonViewModel.teacher?.teacher?.isEmpty ?? true)
                        Expanded(
                          child: DropdownButtonFormField<School?>(
                            initialValue: commonViewModel.selectedSchool,
                            isExpanded: true,
                            selectedItemBuilder: (context) {
                              final items = <Widget>[];

                              if (!commonViewModel.isTeacher) {
                                items.add(
                                  Text(
                                    "All",
                                    style: AppTextStyles.textTheme.bodyMedium!
                                        .copyWith(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }

                              items.addAll(
                                commonViewModel.schools.map(
                                  (e) => Text(
                                    e.schoolName ?? '',
                                    style: AppTextStyles.textTheme.bodyMedium!
                                        .copyWith(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );

                              return items;
                            },

                            items: [
                              if (!commonViewModel.isTeacher)
                                DropdownMenuItem<School?>(
                                  value: null,
                                  child: Text(
                                    "All",
                                    style: AppTextStyles.textTheme.bodyMedium!
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                              ...commonViewModel.schools.map(
                                (e) => DropdownMenuItem<School?>(
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
                            onChanged: (val) =>
                                commonViewModel.selectSchool(val),
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
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<Classes?>(
                          initialValue: commonViewModel.selectedClass,
                          isExpanded: true,

                          selectedItemBuilder: (context) {
                            final widgets = <Widget>[];

                            if (!commonViewModel.isTeacher) {
                              widgets.add(
                                Text(
                                  "All",
                                  style: AppTextStyles.textTheme.bodyMedium!
                                      .copyWith(color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }

                            widgets.addAll(
                              commonViewModel.selectedSchool?.classes?.map(
                                    (e) => Text(
                                      e.className ?? '',
                                      style: AppTextStyles.textTheme.bodyMedium!
                                          .copyWith(color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ) ??
                                  [],
                            );

                            return widgets;
                          },

                          // ✅ DROPDOWN LIST (BLACK TEXT)
                          items: [
                            if (!commonViewModel.isTeacher)
                              DropdownMenuItem<Classes?>(
                                value: null,
                                child: Text(
                                  "All",
                                  style: AppTextStyles.textTheme.bodyMedium!
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ...commonViewModel.selectedSchool?.classes?.map(
                                  (e) => DropdownMenuItem<Classes?>(
                                    value: e,
                                    child: Text(
                                      e.className ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.textTheme.bodyMedium!
                                          .copyWith(color: Colors.black),
                                    ),
                                  ),
                                ) ??
                                [],
                          ],

                          onChanged: (val) => commonViewModel.selectClass(val),

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
                      SizedBox(width: 10),
                    ],
                  ),
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
