import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/add_school/presentation/add_school_view_model.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';

class AddSchoolWidgets {
  static addSchoolHeader() =>
      Text('Add School', style: AppTextStyles.textTheme.headlineLarge);

  static schoolNameTextfiled(AddSchoolViewModel vm) => TextField(
    controller: vm.schoolNameController,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Enter School Name",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.school_outlined),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static schoolprincipleTextfiled(AddSchoolViewModel vm) => TextField(
    controller: vm.schoolPrincipalController,
    style: AppTextStyles.textTheme.bodySmall,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Enter School Principal Name",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.person),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static schoolAddressTextfiled(AddSchoolViewModel vm) => TextField(
    controller: vm.schoolAddressController,
    style: AppTextStyles.textTheme.bodySmall,
    maxLines: 5,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Enter School Address",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.location_pin),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static schoolTelephoneTextfiled(AddSchoolViewModel vm) => TextField(
    controller: vm.schoolTelePhoneController,
    style: AppTextStyles.textTheme.bodySmall,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Enter School Telphone Number",
      hintStyle: AppTextStyles.textTheme.bodySmall!.copyWith(
        color: Colors.grey,
      ),
 prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(Icons.phone_enabled_outlined),
      ),
      prefixIconConstraints: const BoxConstraints(maxHeight: 40, maxWidth: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    ),
  );

  static schoolStudentCountTextfiled(AddSchoolViewModel vm) => TextField(
    controller: vm.schoolNoOfStudentsController,
    style: AppTextStyles.textTheme.bodySmall,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
    decoration: InputDecoration(
      contentPadding: EdgeInsets.all(16),
      hintText: "Enter Student Count of School",
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

  static selectLanguageList(AddSchoolViewModel vm) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 20,
        children: [
          Text(
            'Select Language and Level',
            style: AppTextStyles.textTheme.titleLarge,
          ),
          ListView.separated(
            separatorBuilder: (context, index) => Container(height: 5),
            shrinkWrap: true,
            itemCount: vm.languageList?.length ?? 0,
            itemBuilder: (context, index) {
              Language? language = vm.languageList?[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: language?.gradient ?? []),
                  image: DecorationImage(
                    image: NetworkImage(language?.image ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListTile(
                  leading: Checkbox.adaptive(
                    value: vm.selectedLanguageList.contains(language),
                    onChanged: (val) => vm.selectLanguage(val, language),
                  ),
                  title: Text(
                    language?.language ?? '',
                    style: AppTextStyles.textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  trailing: Text(
                    language?.levelData?.level ?? '',
                    style: AppTextStyles.textTheme.titleSmall!.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ),
  );

  static imageSelector(AddSchoolViewModel vm) => DragTarget<Uint8List>(
    onWillAcceptWithDetails: (data) {
      vm.onDragEntered();
      return true;
    },
    onLeave: (_) => vm.onDragExited(),
    onAcceptWithDetails: (data) => vm.onDrop(data.data),
    builder: (context, candidateData, rejectedData) {
      return GestureDetector(
        onTap: vm.pickImage,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: vm.isDragging
                ? Colors.blue.withOpacity(0.1)
                : Colors.grey[200],
            border: Border.all(
              color: vm.isDragging ? Colors.blue : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: vm.imageBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    vm.imageBytes!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_upload_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        vm.isDragging
                            ? "Drop image here"
                            : "Click or drag & drop an image",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
        ),
      );
    },
  );

  static addSchoolBtn(AddSchoolViewModel vm) => ElevatedButton(
    onPressed: () => vm.addSchool(),
    child: Text('Add School'),
  );
}
