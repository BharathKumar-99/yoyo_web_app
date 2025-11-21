import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/add_user_name_view_model.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart'
    show Classes;
import 'package:yoyo_web_app/features/home/model/school.dart' show School;

import '../../../add_user/model/level.dart';

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

  static getUserTextfield(AddUserNameViewModel value) => TextField(
    controller: value.userCount,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: const InputDecoration(
      labelText: "User Count",
      border: OutlineInputBorder(),
    ),
  );

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
}
