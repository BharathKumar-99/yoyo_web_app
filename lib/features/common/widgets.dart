import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';

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

  static AppBar homeAppBar() {
    return AppBar(
      flexibleSpace: Consumer<CommonViewModel>(
        builder: (context, viewModel, w) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                viewModel.teacher?.teacher?.isNotEmpty ?? false
                    ? viewModel.teacher?.schools?.schoolName ?? ''
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
                '${viewModel.user?.firstName} ${viewModel.user?.surName}',
                style: AppTextStyles.textTheme.titleMedium,
              ),
              SizedBox(width: 60),
              GestureDetector(
                onTap: () => NavigationHelper.go(
                  RouteNames.editUsers,
                  extra: viewModel.user?.userId ?? '',
                ),
                child: CircleAvatar(
                  backgroundColor: Color(0xffED8768),
                  child: Text(
                    viewModel.extractCaps(viewModel.user?.username ?? ''),
                    style: AppTextStyles.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
    return AppBar(
      leading: Consumer<CommonViewModel>(
        builder: (context, viewModel, wid) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => NavigationHelper.go(
                RouteNames.editUsers,
                extra: viewModel.user?.userId ?? '',
              ),
              child: CircleAvatar(
                backgroundColor: Color(0xffED8768),
                child: Text(
                  viewModel.extractCaps(viewModel.user?.username ?? ''),
                  style: AppTextStyles.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      title: Text(
        'YoYo Technologies Ltd',
        style: AppTextStyles.textTheme.titleLarge,
      ),
      actions: [
        Consumer<CommonViewModel>(
          builder: (context, viewModel, wid) {
            return Text(
              '${viewModel.user?.firstName} ${viewModel.user?.surName}',
              style: AppTextStyles.textTheme.titleMedium,
            );
          },
        ),
      ],
      actionsPadding: EdgeInsets.only(right: 8),
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
}
