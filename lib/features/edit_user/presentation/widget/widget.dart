import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/edit_user/presentation/edit_user_view_model.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';

class EditUserWidgets {
  userDetails(EditUserViewModel value) => Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Profile Information',
            style: AppTextStyles.textTheme.headlineSmall,
          ),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10,
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'First Name',
                  initialValue: value.user.firstName,
                  onChanged: value.updateFirstName,
                ),
              ),
              if (value.user.firstName != value.firstName)
                ElevatedButton(
                  onPressed: () {
                    value.updateFirstNameRepo();
                  },
                  child: Text('Update'),
                ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10,
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Surname',
                  initialValue: value.user.surName,
                  onChanged: value.updateSurName,
                ),
              ),
              if (value.user.surName != value.surName)
                ElevatedButton(
                  onPressed: () {
                    value.updateSurNameRepo();
                  },
                  child: Text('Update'),
                ),
            ],
          ),
          _buildReadOnlyField(label: 'Email', value: value.user.email ?? 'N/A'),
          _buildReadOnlyField(
            label: 'Username',
            value: value.user.username ?? 'N/A',
          ),
          _buildReadOnlyField(
            label: 'Account Status',
            value: value.user.isActivated == true ? 'Activated' : 'Pending',
          ),
          _buildReadOnlyField(
            label: 'Logged In',
            value: value.user.isLoggedIn == true ? 'Yes' : 'No',
          ),
          ListTile(
            title: Text('Tester'),
            trailing: Switch.adaptive(
              value: value.user.isTester ?? false,
              onChanged: (val) {
                value.updateTester(val);
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 10,
            children: [
              Expanded(
                child: ListTile(
                  title: const Text(
                    'School',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: value.changeSchool
                      ? Column(
                          spacing: 10,
                          children: [
                            schoolSelector(value),
                            classSelector(value),
                          ],
                        )
                      : Text(
                          value.user.schools?.schoolName ?? '',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                  trailing: GestureDetector(
                    onTap: () => value.toogleSchool(),
                    child: const Icon(Icons.edit),
                  ),
                ),
              ),
              if ((value.selectedSchool != null &&
                      value.selectedSchool?.schoolName !=
                          value.user.schools?.schoolName) &&
                  (value.selectedClasses != null &&
                      value.selectedClasses?.id !=
                          value.user.student?.first.classId))
                ElevatedButton(
                  onPressed: () {
                    value.updateSchoolAndClass();
                  },
                  child: Text('Update'),
                ),
            ],
          ),
        ],
      ),
    ),
  );

  static schoolSelector(EditUserViewModel viewModel) =>
      viewModel.schools.isNotEmpty
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
            items: viewModel.schools
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

  static classSelector(EditUserViewModel viewModel) =>
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

  userMetrics(EditUserViewModel value) => Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '📊 Student Metrics',
            style: AppTextStyles.textTheme.headlineSmall,
          ),
          const Divider(),

          _buildMetricRow(
            'Language Level',
            'Level ${value.user.student?.first.languageLevel ?? 'N/A'}',
            Icons.language,
          ),
          _buildMetricRow(
            'Vocabulary Count',
            '${value.user.student?.first.vocab ?? 'N/A'} Words',
            Icons.book,
          ),
          _buildMetricRow(
            'Effort Score',
            '${value.user.student?.first.effort ?? 'N/A'}%',
            Icons.trending_up,
          ),
          _buildMetricRow(
            'Overall Score',
            '${value.user.student?.first.score ?? 'N/A'}%',
            Icons.star,
          ),
        ],
      ),
    ),
  );
}

Widget _buildTextField({
  required String label,
  String? initialValue,
  required ValueChanged<String> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    ),
  );
}

Widget _buildReadOnlyField({required String label, required String value}) {
  return Padding(
    padding: const EdgeInsets.only(top: 16.0),
    child: TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        enabled: false, // Make it read-only
        fillColor: Colors.grey.shade100,
        filled: true,
      ),
    ),
  );
}

Widget _buildMetricRow(String title, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

String _formatWordsForTooltip(List<String>? words, bool good) {
  if (words == null || words.isEmpty) {
    return 'No ${good ? 'good' : 'bad'} words.';
  }

  return '${good ? 'Good' : 'Bad'} Words:\n${words.join('\n')}';
}

class UserResultTable extends StatelessWidget {
  final List<UserResult> result;
  const UserResultTable({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('Phrase')),
          DataColumn(label: Text('Score'), numeric: true),
          DataColumn(label: Text('Vocab'), numeric: true),
          DataColumn(label: Text('Good Words'), numeric: true),
          DataColumn(label: Text('Bad Words'), numeric: true),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Listened'), numeric: true),
        ],

        rows: result.map<DataRow>((item) {
          return DataRow(
            cells: <DataCell>[
              DataCell(
                SizedBox(
                  width: 200,
                  child: Text(item.phraseModel?.phrase ?? ''),
                ),
              ),
              DataCell(
                Text(
                  '${(item.scoreSubmitted ?? false) ? item.score ?? 'Not Submitted' : "Not Submitted"}',
                ),
              ),
              DataCell(
                Text(
                  '${(item.scoreSubmitted ?? false) ? item.vocab ?? 'Not Submitted' : "Not Submitted"}',
                ),
              ),

              DataCell(
                Tooltip(
                  message: _formatWordsForTooltip(item.goodWords, true),

                  preferBelow: false,
                  verticalOffset: 20,
                  textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),

                  child: InkWell(child: Text('${item.goodWords?.length ?? 0}')),
                ),
              ),
              DataCell(
                Tooltip(
                  message: _formatWordsForTooltip(item.badWords, false),

                  preferBelow: false,
                  verticalOffset: 20,
                  textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),

                  child: InkWell(child: Text('${item.badWords?.length ?? 0}')),
                ),
              ),

              DataCell(Text(item.type ?? '')),
              DataCell(Text((item.listen ?? 0).toString())),
            ],
          );
        }).toList(),
      ),
    );
  }
}
