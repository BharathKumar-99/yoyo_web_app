import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/add_teacher/presentation/add_teacher_view_model.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

class AddTeacherWidgets {
  static addTeacher() =>
      Text('Add Teacher', style: AppTextStyles.textTheme.headlineLarge);

  static firstNameTextField(AddTeacherViewModel vm) => TextField(
    controller: vm.firstNameController,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "First Name",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.account_circle_outlined, color: Colors.grey.shade500),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static lastNameTextField(AddTeacherViewModel vm) => TextField(
    controller: vm.lastNameController,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Last Name",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.account_circle_outlined, color: Colors.grey.shade500),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static usernameTextField(AddTeacherViewModel vm) => TextField(
    controller: vm.userNameController,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "User Name",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.account_circle_outlined, color: Colors.grey.shade500),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static emailTextField(AddTeacherViewModel vm) => TextField(
    controller: vm.emailController,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Email",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.email_outlined, color: Colors.grey.shade500),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );
  static jobTextField(AddTeacherViewModel vm) => TextField(
    controller: vm.jobController,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Job Title",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),

      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static permissionDropDown(AddTeacherViewModel viewModel) =>
      viewModel.permission.isNotEmpty
      ? InputDecorator(
          decoration: InputDecoration(
            labelText: 'Select Position',
            labelStyle: AppTextStyles.textTheme.titleSmall,

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          child: DropdownButton<String>(
            value: viewModel.selectedPermission,

            hint: Text(
              'Select Position',
              style: AppTextStyles.textTheme.bodyLarge,
            ),
            isDense: true, // makes it compact
            isExpanded: true, // fills available width
            items: viewModel.permission
                .map(
                  (val) => DropdownMenuItem<String>(
                    value: val,
                    child: Text(val, style: AppTextStyles.textTheme.titleSmall),
                  ),
                )
                .toList(),
            onChanged: (value) => viewModel.selectPermission(value),
            underline: Container(),
          ),
        )
      : Container();

  static schoolSelector(AddTeacherViewModel viewModel) =>
      viewModel.school.isNotEmpty
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
            items: viewModel.school
                .map(
                  (val) => DropdownMenuItem<School>(
                    value: val,
                    child: Text(
                      val.schoolName ?? '',
                      style: AppTextStyles.textTheme.titleSmall,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => viewModel.selectSchools(value),
            underline: Container(),
          ),
        )
      : Container();

  static classSelector(AddTeacherViewModel viewModel) =>
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
}
