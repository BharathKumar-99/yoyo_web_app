import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/features/users/presentation/users_view_model.dart';

import '../../../../config/theme/app_text_styles.dart';

class UserWidgets {
  static Row userHeading(UsersViewModel viewModel) {
    return Row(
      spacing: 20,
      children: [
        Text('Users', style: AppTextStyles.textTheme.headlineLarge),
        GestureDetector(
          onTap: () => NavigationHelper.go(RouteNames.addUsers),
          child: Chip(
            label: Text(
              'Add Users',
              style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                color: Colors.white,
              ),
            ),
            avatar: Icon(Icons.add, color: Colors.white),
            color: WidgetStatePropertyAll(Colors.green),
          ),
        ),
        GestureDetector(
          onTap: () => NavigationHelper.go(RouteNames.addUserName),
          child: Chip(
            label: Text(
              'Create Username(s)',
              style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                color: Colors.white,
              ),
            ),
            avatar: Icon(Icons.add, color: Colors.white),
            color: WidgetStatePropertyAll(Colors.green),
          ),
        ),
      ],
    );
  }

  static Table userTable(UsersViewModel viewModel) => Table(
    columnWidths: const {0: FlexColumnWidth(0.6)},
    children: [
      tableHeader(),
      tableRow([
        tableCellRow(''),
        tableCellRow(''),
        tableCellRow(''),
        tableCellRow(''),
        tableCellRow(''),
        tableCellRow(''),
      ]),
      ...viewModel.users.map((val) {
        String extractCaps(String text) {
          final matches = RegExp(
            r'(^[A-Za-z])|-(\s*[A-Za-z])',
          ).allMatches(text);

          // Extract the actual letters, remove '-', trim spaces
          final letters = matches.map((m) {
            return (m.group(1) ?? m.group(2))!
                .replaceAll('-', '')
                .trim()
                .toUpperCase();
          }).join();

          return letters;
        }

        final nameFromUser = extractCaps(val.username ?? '');
        return tableRow([
          TableCell(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
                  ),
                ),
                child: Text(
                  nameFromUser,
                  style: AppTextStyles.textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          tableCellRow(
            "${val.firstName ?? ''} ${val.surName ?? ''}",
            isMain: true,
          ),
          tableCellRow(val.schools?.schoolName ?? ''),
          tableCellRow((val.student?.isEmpty ?? true) ? 'Teacher' : 'Student'),
          tableCellRow(val.username ?? ''),
          TableCell(
            child: GestureDetector(
              onTap: () =>
                  NavigationHelper.go(RouteNames.editUsers, extra: val.userId),
              child: Chip(label: Text('View/Edit')),
            ),
          ),
        ]);
      }),
    ],
  );

  static TableRow tableHeader() => TableRow(
    children: [
      tableCellHeader('Avatar'),
      tableCellHeader('Name'),
      tableCellHeader('School'),
      tableCellHeader('Role'),
      tableCellHeader('User Name'),
      tableCellHeader(''),
    ],
  );

  static TableRow tableRow(List<TableCell> cells) => TableRow(children: cells);

  static TableCell tableCellHeader(String data) => TableCell(
    child: Text(data, style: AppTextStyles.textTheme.headlineMedium),
  );

  static TableCell tableCellRow(String data, {bool isMain = false}) =>
      TableCell(
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isMain ? Colors.blueGrey.shade100 : Colors.transparent,
          ),
          child: Text(data, style: AppTextStyles.textTheme.titleMedium),
        ),
      );
}
