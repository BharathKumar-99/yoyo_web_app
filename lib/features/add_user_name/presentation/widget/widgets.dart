import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/add_user_name_view_model.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart'
    show Classes;
import 'package:yoyo_web_app/features/home/model/school.dart' show School;
import '../../../add_user/model/level.dart';
import '../../model/add_user_from_excel.dart';

class AddUserNameWidget {
  static getHeader() =>
      Text('Add User Name', style: AppTextStyles.textTheme.headlineLarge);

  static schoolSelector(AddUserNameViewModel viewModel) =>
      viewModel.school?.isNotEmpty ?? false
      ? InputDecorator(
          decoration: InputDecoration(
            labelText: 'Select School',
            labelStyle: AppTextStyles.textTheme.titleSmall,

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          child: DropdownButton<School>(
            value: viewModel.selectedSchool,

            hint: Text(
              'Select School',
              style: AppTextStyles.textTheme.bodyLarge,
            ),
            isDense: true, // makes it compact
            isExpanded: true, // fills available width
            items:
                viewModel.school
                    ?.map(
                      (val) => DropdownMenuItem<School>(
                        value: val,
                        child: Text(
                          val.schoolName ?? '',
                          style: AppTextStyles.textTheme.titleSmall,
                        ),
                      ),
                    )
                    .toList() ??
                [],
            onChanged: (value) => viewModel.selectSchools(value),
            underline: Container(),
          ),
        )
      : Container();

  static classSelector(AddUserNameViewModel viewModel) =>
      viewModel.selectedSchool?.classes?.isNotEmpty ?? false
      ? InputDecorator(
          decoration: InputDecoration(
            labelText: (viewModel.selectedSchool?.classes?.isEmpty ?? true)
                ? 'Select a School'
                : 'Select Class',
            labelStyle: AppTextStyles.textTheme.titleSmall,

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          child: DropdownButton<Classes>(
            value: viewModel.selectedClasses,
            hint: Text(
              (viewModel.selectedSchool?.classes?.isEmpty ?? true)
                  ? 'Select a School'
                  : 'Select Class',
              style: AppTextStyles.textTheme.bodyLarge,
            ),
            isDense: true,
            isExpanded: true,
            items:
                viewModel.selectedSchool?.classes
                    ?.map(
                      (val) => DropdownMenuItem<Classes>(
                        value: val,
                        child: Text(
                          val.className ?? '',
                          style: AppTextStyles.textTheme.titleSmall,
                        ),
                      ),
                    )
                    .toList() ??
                [],
            onChanged: (value) => viewModel.selectClass(value),
            underline: Container(),
          ),
        )
      : Container();

  static selectLevel(AddUserNameViewModel viewModel) => InputDecorator(
    decoration: InputDecoration(
      labelText: 'Select User Level',
      labelStyle: AppTextStyles.textTheme.titleSmall,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    child: DropdownButton<Level>(
      value: viewModel.selectedLevel,
      hint: Text('Select User Level', style: AppTextStyles.textTheme.bodyLarge),
      isDense: true,
      isExpanded: true,
      items: viewModel.level
          .map(
            (val) => DropdownMenuItem<Level>(
              value: val,
              child: Text(
                val.level ?? '',
                style: AppTextStyles.textTheme.titleSmall,
              ),
            ),
          )
          .toList(),
      onChanged: (value) => viewModel.selectLevel(value),
      underline: Container(),
    ),
  );

  static addUserNameBtn(AddUserNameViewModel viewModel) => ElevatedButton(
    onPressed: () => viewModel.createUser(),
    child: Text('Create Username'),
  );

  static userTable(List<UserActivationModel> list) {
    if (list.isEmpty) return const SizedBox();

    return Table(
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
      border: TableBorder.all(color: Colors.grey),
      children: [
        // Header
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Username",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Activation Code",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        // Data Rows
        ...list.map(
          (item) => TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(item.username),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(item.activationCode),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static addXl(AddUserNameViewModel viewModel) => InkWell(
    onTap: viewModel.pickFile,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, size: 40, color: Colors.green),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              viewModel.selectedFileName ?? "Upload Excel / CSV file",
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Icon(Icons.upload_file),
        ],
      ),
    ),
  );
}
