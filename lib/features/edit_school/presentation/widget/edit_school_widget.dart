import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/edit_school/model/remote_config.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school_view_model.dart';

class EditSchoolWidget {
  static editSchool() =>
      Text('Edit School', style: AppTextStyles.textTheme.headlineLarge);

  static editSchoolSettings() => Text(
    'Edit School Settings',
    style: AppTextStyles.textTheme.headlineLarge,
  );

  static streak(EditSchoolViewModel viewmodel) => ListTile(
    title: Text("Streak", style: AppTextStyles.textTheme.titleLarge),
    trailing: Switch.adaptive(
      value: viewmodel.apiCred.streak,
      onChanged: (val) {
        viewmodel.updateStreakEnabled(val);
      },
    ),
  );

  static getSlack(EditSchoolViewModel provider) => Column(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("French", style: AppTextStyles.textTheme.titleLarge),
          Slider(
            value: provider.apiCred.slack.fr.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: provider.apiCred.slack.fr.toDouble().toStringAsFixed(0),
            onChanged: (value) {
              LanguageSlack slack = provider.apiCred.slack;
              slack.fr = value;
              provider.updateSlack(slack);
            },
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Russian", style: AppTextStyles.textTheme.titleLarge),
          Slider(
            value: provider.apiCred.slack.ru.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: provider.apiCred.slack.ru.toDouble().toStringAsFixed(0),
            onChanged: (value) {
              LanguageSlack slack = provider.apiCred.slack;
              slack.ru = value;
              provider.updateSlack(slack);
            },
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Spanish", style: AppTextStyles.textTheme.titleLarge),
          Slider(
            value: provider.apiCred.slack.sp.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: provider.apiCred.slack.sp.toDouble().toStringAsFixed(0),
            onChanged: (value) {
              LanguageSlack slack = provider.apiCred.slack;
              slack.sp = value;
              provider.updateSlack(slack);
            },
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("German", style: AppTextStyles.textTheme.titleLarge),
          Slider(
            value: provider.apiCred.slack.de.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: provider.apiCred.slack.de.toDouble().toStringAsFixed(0),
            onChanged: (value) {
              LanguageSlack slack = provider.apiCred.slack;
              slack.de = value;
              provider.updateSlack(slack);
            },
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Korean", style: AppTextStyles.textTheme.titleLarge),
          Slider(
            value: provider.apiCred.slack.kr.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: provider.apiCred.slack.kr.toDouble().toStringAsFixed(0),
            onChanged: (value) {
              LanguageSlack slack = provider.apiCred.slack;
              slack.kr = value;
              provider.updateSlack(slack);
            },
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mandarin", style: AppTextStyles.textTheme.titleLarge),
          Slider(
            value: provider.apiCred.slack.promaxCn.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: provider.apiCred.slack.promaxCn.toDouble().toStringAsFixed(
              0,
            ),
            onChanged: (value) {
              LanguageSlack slack = provider.apiCred.slack;
              slack.promaxCn = value;
              provider.updateSlack(slack);
            },
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Japanese", style: AppTextStyles.textTheme.titleLarge),
          Slider(
            value: provider.apiCred.slack.jp.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: provider.apiCred.slack.jp.toDouble().toStringAsFixed(0),
            onChanged: (value) {
              LanguageSlack slack = provider.apiCred.slack;
              slack.jp = value;
              provider.updateSlack(slack);
            },
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("English", style: AppTextStyles.textTheme.titleLarge),
          Slider(
            value: provider.apiCred.slack.promax.toDouble(),
            min: 0,
            max: 100,
            divisions: 10,
            label: provider.apiCred.slack.promax.toDouble().toStringAsFixed(0),
            onChanged: (value) {
              LanguageSlack slack = provider.apiCred.slack;
              slack.promax = value;
              provider.updateSlack(slack);
            },
          ),
        ],
      ),
    ],
  );

  static schoolName(EditSchoolViewModel viewModel) => TextField(
    controller: viewModel.schoolName,
    decoration: InputDecoration(
      labelText: "School Name",
      border: OutlineInputBorder(),
    ),
  );

  static schoolAddress(EditSchoolViewModel viewModel) => TextField(
    controller: viewModel.schoolAdrs,
    decoration: InputDecoration(
      labelText: "School Address",
      border: OutlineInputBorder(),
    ),
  );

  static schoolTelephone(EditSchoolViewModel viewModel) => TextField(
    controller: viewModel.schoolTelephone,
    decoration: InputDecoration(
      labelText: "School Telephone",
      border: OutlineInputBorder(),
    ),
  );

  static schoolPrinciple(EditSchoolViewModel viewModel) => TextField(
    controller: viewModel.schoolPrinciple,
    decoration: InputDecoration(
      labelText: "School Principle",
      border: OutlineInputBorder(),
    ),
  );

  static schoolStudents(EditSchoolViewModel viewModel) => TextField(
    controller: viewModel.schoolStudents,
    decoration: InputDecoration(
      labelText: "School Students",
      border: OutlineInputBorder(),
    ),
  );

  static updateSchoolDataBtn(EditSchoolViewModel viewModel) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => viewModel.updateSchool(),
      child: Text('Update'),
    ),
  );

  static Widget schoolImage(EditSchoolViewModel viewModel) {
    return GestureDetector(
      onTap: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
          withData: true,
        );
        viewModel.updateImage(result);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "School Image",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            clipBehavior: Clip.antiAlias,
            child: _buildImagePreview(viewModel),
          ),

          const SizedBox(height: 8),

          const Text(
            "Click to change image",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  static Widget _buildImagePreview(EditSchoolViewModel viewModel) {
    if (viewModel.selectedImageBytes != null) {
      return Image.memory(viewModel.selectedImageBytes!, fit: BoxFit.fill);
    }

    if (viewModel.school?.image != null &&
        (viewModel.school?.image?.isNotEmpty ?? false)) {
      return Image.network(viewModel.school!.image!, fit: BoxFit.fill);
    }

    return const Center(child: Icon(Icons.image, size: 50, color: Colors.grey));
  }
}
