import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/config/utils/textfield_extention.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/users/model/student_langugaes.dart';
import 'package:yoyo_web_app/features/users/presentation/users_view_model.dart';

import '../../../../config/theme/app_text_styles.dart';

class UserWidgets {
  static Wrap userHeading(UsersViewModel viewModel) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      runAlignment: WrapAlignment.start,
      children: [Text('Users', style: AppTextStyles.textTheme.headlineLarge)],
    );
  }

  static userDrop(UsersViewModel viewModel, bool isMobile, bool isTab) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );
    return Consumer<CommonViewModel>(
      builder: (context, commonViewModel, w) {
        return Row(
          spacing: 10,
          children: [
            IntrinsicWidth(
              child: DropdownButtonFormField<String?>(
                initialValue: viewModel.selectedUserType,
                isExpanded: true,
                selectedItemBuilder: (context) {
                  final items = <Widget>[];

                  items.addAll(
                    viewModel.userTypes.map(
                      (e) => Text(
                        e,
                        style: AppTextStyles.textTheme.bodyMedium!.copyWith(
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );

                  return items;
                },

                items: [
                  ...viewModel.userTypes.map(
                    (e) => DropdownMenuItem<String?>(
                      value: e,
                      child: Text(
                        e,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.textTheme.bodyMedium!.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
                onChanged: (val) => viewModel.selectUser(val),
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
            if (commonViewModel.selectedSchool != null &&
                commonViewModel.selectedClass != null)
              Row(
                spacing: 10,
                children: [
                  GestureDetector(
                    onTap: () => viewModel.toggleAddUser(
                      viewModel.selectedUserType == 'Teacher',
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xff9D5DE6), width: 2),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Color(0xff9D5DE6),
                            size: 25,
                            fontWeight: FontWeight.w900,
                          ),
                          Text(
                            '1',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (viewModel.selectedUserType == 'Student')
                    GestureDetector(
                      onTap: () =>
                          viewModel.showBulkUploadDialog(isMobile, isTab),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xff9D5DE6),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: Color(0xff9D5DE6),
                              size: 25,
                              fontWeight: FontWeight.w900,
                            ),
                            Text(
                              'Bulk',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }

  static addSingleStudent(UsersViewModel viewModel) {
    TextEditingController nameController = TextEditingController();
    TextEditingController surNameController = TextEditingController();
    TextEditingController userNameController = TextEditingController();
    TextEditingController activationController = TextEditingController();
    StudentLanguageModel? selectedLanguage = viewModel.studentLanguage
        .where((e) => e.language == 'English')
        .firstOrNull;

    return (viewModel.showAddStudent)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Wrap(
              spacing: 30,
              runSpacing: 30,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 46,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff9D5DE6)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff9D5DE6)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surname Initial',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 46,
                      child: TextField(
                        controller: surNameController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff9D5DE6)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff9D5DE6)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 46,
                      child: TextField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff9D5DE6)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff9D5DE6)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activation Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 46,
                      child: TextField(
                        controller: activationController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [ActivationCodeFormatter()],
                        decoration: InputDecoration(
                          hintText: '-',

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff9D5DE6)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff9D5DE6)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 46,
                      child: DropdownButtonFormField<StudentLanguageModel?>(
                        isExpanded: true,
                        initialValue: viewModel.studentLanguage
                            .where((element) => element.language == 'English')
                            .firstOrNull,
                        items: viewModel.studentLanguage
                            .map(
                              (e) => DropdownMenuItem<StudentLanguageModel?>(
                                value: e,
                                child: Text(
                                  e.language.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.textTheme.bodyMedium
                                      ?.copyWith(color: Colors.black),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => selectedLanguage = val,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () async => viewModel.addStudent(
                      nameController.text.trim().toString(),
                      surNameController.text.trim().toString(),
                      userNameController.text.trim().toString(),
                      activationController.text.trim().toString(),
                      selectedLanguage?.id,
                    ),
                    child: Container(
                      height: 46,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
                        ),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
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
      ...viewModel.teacher.map((val) {
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
          tableCellRow(
            (val.teacher != null && (val.teacher?.isNotEmpty ?? false)
                ? val.teacher?.first.jobTitle ?? ''
                : 'Student'),
          ),
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
      tableCellHeader('Job Title'),
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

// if (viewModel.commonViewModel.teacher?.teacher?.isEmpty ?? true)
//         GestureDetector(
//           onTap: () => NavigationHelper.go(RouteNames.addUsers),
//           child: Chip(
//             label: Text(
//               'Add Student',
//               style: AppTextStyles.textTheme.headlineMedium!.copyWith(
//                 color: Colors.white,
//               ),
//             ),
//             avatar: Icon(Icons.add, color: Colors.white),
//             color: WidgetStatePropertyAll(Colors.green),
//           ),
//         ),
//       if (viewModel.commonViewModel.teacher?.teacher?.isEmpty ?? true)
//         GestureDetector(
//           onTap: () => NavigationHelper.go(RouteNames.addUserName),
//           child: Chip(
//             label: Text(
//               'Create Username(s)',
//               style: AppTextStyles.textTheme.headlineMedium!.copyWith(
//                 color: Colors.white,
//               ),
//             ),
//             avatar: Icon(Icons.add, color: Colors.white),
//             color: WidgetStatePropertyAll(Colors.green),
//           ),
//         ),
//       if (viewModel.commonViewModel.teacher?.teacher != null &&
//               (viewModel.commonViewModel.teacher?.teacher?.isNotEmpty ??
//                   false)
//           ? (viewModel.commonViewModel.teacher?.teacher?.first.permissionLevel
//                         ?.toLowerCase()
//                         .contains('principle') ??
//                     false)
//                 ? true
//                 : false
//           : true)
//         GestureDetector(
//           onTap: () => NavigationHelper.go(RouteNames.addTeacher),
//           child: Chip(
//             label: Text(
//               'Add Teacher',
//               style: AppTextStyles.textTheme.headlineMedium!.copyWith(
//                 color: Colors.white,
//               ),
//             ),
//             avatar: Icon(Icons.add, color: Colors.white),
//             color: WidgetStatePropertyAll(Colors.green),
//           ),
//         ),
