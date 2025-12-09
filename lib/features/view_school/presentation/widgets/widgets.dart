import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/view_school/presentation/view_school_view_model.dart';

class ViewSchoolWidget {
  static schoolImage(ViewSchoolViewModel viewModel) =>
      Image.network(viewModel.school?.image ?? '');

  static schoolName(ViewSchoolViewModel viewModel) => Text(
    'School Name: ${viewModel.school?.schoolName}',
    style: AppTextStyles.textTheme.titleLarge,
  );
  static schoolStudents(ViewSchoolViewModel viewModel) => Text(
    'School Students Count: ${viewModel.school?.noOfStudents}',
    style: AppTextStyles.textTheme.titleLarge,
  );
  static schoolTelephone(ViewSchoolViewModel viewModel) => Text(
    'School Number: ${viewModel.school?.schoolTelephoneNo}',
    style: AppTextStyles.textTheme.titleLarge,
  );
  static schoolprinciple(ViewSchoolViewModel viewModel) => Text(
    'School Principle: ${viewModel.school?.principle}',
    style: AppTextStyles.textTheme.titleLarge,
  );
  static schoolAddress(ViewSchoolViewModel viewModel) => Text(
    'School Address: ${viewModel.school?.schoolAddress}',
    style: AppTextStyles.textTheme.titleLarge,
  );
}

class ReusableUserTable extends StatelessWidget {
  final School? school;

  const ReusableUserTable({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 20,
      border: TableBorder.all(color: Colors.grey.shade400),
      headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),
      columns: const [
        DataColumn(label: Text('Username')),
        DataColumn(label: Text('First Name')),
        DataColumn(label: Text('Last Name')),
        DataColumn(label: Text('Logged In')),
        DataColumn(label: Text('Effort')),
        DataColumn(label: Text('Vocab')),
        DataColumn(label: Text('Score')),
      ],
      rows: school!.classes!
          .expand(
            (row) => row.students!.map(
              (data) => DataRow(
                cells: [
                  DataCell(Text(data.userModel?.username ?? "")),
                  DataCell(Text(data.userModel?.firstName ?? "")),
                  DataCell(Text(data.userModel?.surName ?? "")),
                  DataCell(
                    Text(data.userModel?.isActivated ?? false ? 'Yes' : 'No'),
                  ),
                  DataCell(Text(data.effort?.toString() ?? "")),
                  DataCell(Text(data.vocab?.toString() ?? "")),
                  DataCell(Text(data.score?.toString() ?? "")),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
