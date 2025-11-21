import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/add_user/presentation/add_user_view_model.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';

class AddUserWidgets {
  // static emailTextField(AddUserViewModel vm) => TextField(
  //   controller: vm.emailController,
  //   style: AppTextStyles.textTheme.bodySmall,
  //   decoration: InputDecoration(
  //     contentPadding: EdgeInsets.all(16),
  //     hintText: "Email Address",
  //     hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
  //       color: Colors.grey,
  //     ),
  //     prefixIcon: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //       child: Image.asset(IconConstants.emailIcon),
  //     ),
  //     prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: BorderSide(color: Colors.grey.shade300),
  //     ),
  //   ),
  // );
  static firstNameTextField(AddUserViewModel vm) => TextField(
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
  static lastNameTextField(AddUserViewModel vm) => TextField(
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

  static userSelector(AddUserViewModel viewModel) => viewModel.user.isNotEmpty
      ? InputDecorator(
          decoration: InputDecoration(
            labelText: 'Select User Name',
            labelStyle: AppTextStyles.textTheme.titleSmall,

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          child: DropdownButton<UserModel>(
            value: viewModel.selectedUser,

            hint: Text(
              'Select User Name',
              style: AppTextStyles.textTheme.bodyLarge,
            ),
            isDense: true, // makes it compact
            isExpanded: true, // fills available width
            items: viewModel.user
                .map(
                  (val) => DropdownMenuItem<UserModel>(
                    value: val,
                    child: Text(
                      val.username ?? '',
                      style: AppTextStyles.textTheme.titleSmall,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => viewModel.selectUser(value),
            underline: Container(),
          ),
        )
      : Container();

  // static schoolSelector(AddUserViewModel viewModel) =>
  //     viewModel.school?.isNotEmpty ?? false
  //     ? InputDecorator(
  //         decoration: InputDecoration(
  //           labelText: 'Select School',
  //           labelStyle: AppTextStyles.textTheme.titleSmall,

  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //           contentPadding: const EdgeInsets.symmetric(
  //             horizontal: 12,
  //             vertical: 8,
  //           ),
  //         ),
  //         child: DropdownButton<School>(
  //           value: viewModel.selectedSchool,

  //           hint: Text(
  //             'Select School',
  //             style: AppTextStyles.textTheme.bodyLarge,
  //           ),
  //           isDense: true, // makes it compact
  //           isExpanded: true, // fills available width
  //           items:
  //               viewModel.school
  //                   ?.map(
  //                     (val) => DropdownMenuItem<School>(
  //                       value: val,
  //                       child: Text(
  //                         val.schoolName ?? '',
  //                         style: AppTextStyles.textTheme.titleSmall,
  //                       ),
  //                     ),
  //                   )
  //                   .toList() ??
  //               [],
  //           onChanged: (value) => viewModel.selectSchools(value),
  //           underline: Container(),
  //         ),
  //       )
  //     : Container();

  // static classSelector(AddUserViewModel viewModel) =>
  //     viewModel.selectedSchool?.classes?.isNotEmpty ?? false
  //     ? InputDecorator(
  //         decoration: InputDecoration(
  //           labelText: (viewModel.selectedSchool?.classes?.isEmpty ?? true)
  //               ? 'Select a School'
  //               : 'Select Class',
  //           labelStyle: AppTextStyles.textTheme.titleSmall,

  //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //           contentPadding: const EdgeInsets.symmetric(
  //             horizontal: 12,
  //             vertical: 8,
  //           ),
  //         ),
  //         child: DropdownButton<Classes>(
  //           value: viewModel.selectedClasses,
  //           hint: Text(
  //             (viewModel.selectedSchool?.classes?.isEmpty ?? true)
  //                 ? 'Select a School'
  //                 : 'Select Class',
  //             style: AppTextStyles.textTheme.bodyLarge,
  //           ),
  //           isDense: true,
  //           isExpanded: true,
  //           items:
  //               viewModel.selectedSchool?.classes
  //                   ?.map(
  //                     (val) => DropdownMenuItem<Classes>(
  //                       value: val,
  //                       child: Text(
  //                         val.className ?? '',
  //                         style: AppTextStyles.textTheme.titleSmall,
  //                       ),
  //                     ),
  //                   )
  //                   .toList() ??
  //               [],
  //           onChanged: (value) => viewModel.selectClass(value),
  //           underline: Container(),
  //         ),
  //       )
  //     : Container();

  // static userType(AddUserViewModel viewModel) => InputDecorator(
  //   decoration: InputDecoration(
  //     labelText: 'Select User Type',
  //     labelStyle: AppTextStyles.textTheme.titleSmall,

  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //   ),
  //   child: DropdownButton<String>(
  //     value: viewModel.selectedUserType,
  //     hint: Text('Select User Type', style: AppTextStyles.textTheme.bodyLarge),
  //     isDense: true,
  //     isExpanded: true,
  //     items: viewModel.userType
  //         .map(
  //           (val) => DropdownMenuItem<String>(
  //             value: val,
  //             child: Text(val, style: AppTextStyles.textTheme.titleSmall),
  //           ),
  //         )
  //         .toList(),
  //     onChanged: (value) => viewModel.selectUserType(value),
  //     underline: Container(),
  //   ),
  // );

  // static selectLevel(AddUserViewModel viewModel) => InputDecorator(
  //   decoration: InputDecoration(
  //     labelText: 'Select User Level',
  //     labelStyle: AppTextStyles.textTheme.titleSmall,
  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //   ),
  //   child: DropdownButton<Level>(
  //     value: viewModel.selectedLevel,
  //     hint: Text('Select User Level', style: AppTextStyles.textTheme.bodyLarge),
  //     isDense: true,
  //     isExpanded: true,
  //     items: viewModel.level
  //         .map(
  //           (val) => DropdownMenuItem<Level>(
  //             value: val,
  //             child: Text(
  //               val.level ?? '',
  //               style: AppTextStyles.textTheme.titleSmall,
  //             ),
  //           ),
  //         )
  //         .toList(),
  //     onChanged: (value) => viewModel.selectLevel(value),
  //     underline: Container(),
  //   ),
  // );

  // static selectJob(AddUserViewModel vm) => TextField(
  //   controller: vm.jobTitle,
  //   style: AppTextStyles.textTheme.bodySmall,
  //   decoration: InputDecoration(
  //     contentPadding: EdgeInsets.all(16),
  //     hintText: "Enter Job Title",
  //     hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
  //       color: Colors.grey,
  //     ),
  //     prefixIcon: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //       child: Icon(Icons.assignment_ind_outlined),
  //     ),
  //     prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: BorderSide(color: Colors.grey.shade300),
  //     ),
  //   ),
  // );
  // static selectPermisionLvl(AddUserViewModel vm) => TextField(
  //   controller: vm.permissionLvl,
  //   style: AppTextStyles.textTheme.bodySmall,
  //   decoration: InputDecoration(
  //     contentPadding: EdgeInsets.all(16),
  //     hintText: "Enter Permission Level",
  //     hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
  //       color: Colors.grey,
  //     ),
  //     prefixIcon: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //       child: Icon(Icons.add_moderator_outlined),
  //     ),
  //     prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: BorderSide(color: Colors.grey.shade300),
  //     ),
  //   ),
  // );

  static elevatedBtn(AddUserViewModel viewModel) => ElevatedButton(
    onPressed: () {
      viewModel.addUser();
    },
    child: Text('Add User'),
  );
}
