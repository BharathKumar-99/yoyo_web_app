import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';
import 'package:yoyo_web_app/features/home/model/student_classes.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/view_school/presentation/view_school_view_model.dart';

class SchoolTable extends StatelessWidget {
  final List<School> school;
  const SchoolTable({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Divider(height: 1),

        ...school.map((row) => _buildRow(row)),
      ],
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          headerCell("Name", "", flex: 2),
          headerCell("Contact", "", flex: 1),
          headerCell("No.Classes", "", flex: 1),
          headerCell("No.Students", "", flex: 1),
          headerCell("Active Student", "", flex: 1),
          headerCell("View/Edit", " ", flex: 1),
        ],
      ),
    );
  }

  Widget headerCell(String text, String key, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
          fontSize: 13,
        ),
      ),
    );
  }

  // ---------------- ROW ----------------
  Widget _buildRow(School row) {
    int studentCount = 0;
    int activeStudent = 0;

    List<UserModel> users = [];
    for (Classes element in row.classes ?? []) {
      for (StudentClassesModel stdClass in element.studentClasses ?? []) {
        if (stdClass.user?.isTester != true) {
          users.add(stdClass.user!);
        }
      }
    }

    for (var element in users) {
      if (element.userResult?.isNotEmpty ?? false) {
        activeStudent += 1;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              spacing: 5,
              children: [
                Text(
                  row.schoolName ?? '',
                  style: Theme.of(ctx!).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '(${row.classes?.length} Classes)',
                      style: Theme.of(ctx!).textTheme.bodySmall!.copyWith(
                        color: Theme.of(ctx!).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),

                    Consumer<ViewSchoolViewModel>(
                      builder: (context, pro, w) {
                        return TextButton(
                          onPressed: () => pro.deleteSchool(context, row.id),
                          child: Text(
                            'delete',
                            style: Theme.of(ctx!).textTheme.bodySmall!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          rowCell('${row.principle}', flex: 1),
          rowCell('${row.classes?.length}', flex: 1),
          rowCell('$studentCount', flex: 1),
          rowCell('$activeStudent', flex: 1),
          Consumer<ViewSchoolViewModel>(
            builder: (context, pro, w) {
              return Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => pro.toEditSchool(row),
                    child: Chip(label: Text('View/Edit')),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget rowCell(
    String text, {
    int flex = 1,
    Color? color,
    double fontsize = 14,
    FontWeight font = FontWeight.normal,
  }) {
    return Expanded(
      flex: flex,
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: fontsize,
              color: color ?? Colors.black87,
              fontWeight: font,
            ),
          ),
        ),
      ),
    );
  }
}

class SchoolBasicInfoRow extends StatelessWidget {
  final ViewSchoolViewModel value;

  const SchoolBasicInfoRow({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: [
        Expanded(
          flex: 2,
          child: CustomTextField(
            label: 'Name',
            controller: value.schoolNameController,
          ),
        ),
        Expanded(
          flex: 3,
          child: CustomTextField(
            label: 'Address',
            controller: value.schoolAddressController,
          ),
        ),
      ],
    );
  }
}

class SchoolBasicInfoMob extends StatelessWidget {
  final ViewSchoolViewModel value;

  const SchoolBasicInfoMob({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        CustomTextField(label: 'Name', controller: value.schoolNameController),
        CustomTextField(
          label: 'Address',
          controller: value.schoolAddressController,
        ),
      ],
    );
  }
}

class SchoolContactRow extends StatelessWidget {
  final ViewSchoolViewModel value;

  const SchoolContactRow({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: [
        Expanded(
          flex: 3,
          child: CustomTextField(
            label: 'Contact Name',
            controller: value.schoolPrincipalController,
          ),
        ),
        Expanded(
          flex: 3,
          child: CustomTextField(
            label: 'Email',
            controller: value.schoolEmailController,
          ),
        ),
        Expanded(
          flex: 3,
          child: CustomTextField(
            label: 'Phone No.',
            controller: value.schoolTelePhoneController,
          ),
        ),
        Expanded(flex: 2, child: ImageUploadField(value: value)),
      ],
    );
  }
}

class SchoolContactTabRow extends StatelessWidget {
  final ViewSchoolViewModel value;

  const SchoolContactTabRow({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        Row(
          spacing: 20,
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'Contact Name',
                controller: value.schoolPrincipalController,
              ),
            ),
            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'Email',
                controller: value.schoolEmailController,
              ),
            ),
          ],
        ),
        Row(
          spacing: 20,
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                label: 'Phone No.',
                controller: value.schoolTelePhoneController,
              ),
            ),
            Expanded(flex: 2, child: ImageUploadField(value: value)),
          ],
        ),
      ],
    );
  }
}

class SchoolContactMobRow extends StatelessWidget {
  final ViewSchoolViewModel value;

  const SchoolContactMobRow({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        CustomTextField(
          label: 'Contact Name',
          controller: value.schoolPrincipalController,
        ),
        CustomTextField(
          label: 'Email',
          controller: value.schoolEmailController,
        ),
        CustomTextField(
          label: 'Phone No.',
          controller: value.schoolTelePhoneController,
        ),
        ImageUploadField(value: value),
      ],
    );
  }
}

class ViewSchoolWidgets {
  Widget addWidgetWeb(ViewSchoolViewModel value) {
    if (!value.showAddStudent) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 30,
      children: [
        Expanded(flex: 5, child: AddSchoolWebsite(value: value)),
        Expanded(flex: 1, child: AddButton(value: value)),
      ],
    );
  }

  Widget addWidgetTab(ViewSchoolViewModel value) {
    if (!value.showAddStudent) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        AddSchoolTablet(value: value),
        AddButton(value: value),
      ],
    );
  }

  Widget addWidgetMob(ViewSchoolViewModel value) {
    if (!value.showAddStudent) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        AddSchoolMobile(value: value),
        AddButton(value: value),
      ],
    );
  }
}

class AddSchoolWebsite extends StatelessWidget {
  final ViewSchoolViewModel value;

  const AddSchoolWebsite({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        SchoolBasicInfoRow(value: value),
        SchoolContactRow(value: value),
      ],
    );
  }
}

class AddSchoolTablet extends StatelessWidget {
  final ViewSchoolViewModel value;

  const AddSchoolTablet({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        SchoolBasicInfoRow(value: value),
        SchoolContactTabRow(value: value),
      ],
    );
  }
}

class AddSchoolMobile extends StatelessWidget {
  final ViewSchoolViewModel value;

  const AddSchoolMobile({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        SchoolBasicInfoMob(value: value),
        SchoolContactMobRow(value: value),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff9D5DE6)),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff9D5DE6)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class ImageUploadField extends StatelessWidget {
  final ViewSchoolViewModel value;

  const ImageUploadField({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Image Upload',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: DragTarget<Uint8List>(
            onWillAcceptWithDetails: (data) {
              value.onDragEntered();
              return true;
            },
            onLeave: (_) => value.onDragExited(),
            onAcceptWithDetails: (data) => value.onDrop(data.data),
            builder: (context, candidateData, rejectedData) {
              return GestureDetector(
                onTap: value.pickImage,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: value.isDragging
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.grey[200],
                    border: Border.all(
                      color: value.isDragging
                          ? Colors.blue
                          : const Color(0xff9D5DE6),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: value.imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            value.imageBytes!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : const Center(child: Icon(Icons.upload)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AddButton extends StatelessWidget {
  final ViewSchoolViewModel value;

  const AddButton({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: GestureDetector(
            onTap: () async => value.addSchool(),
            child: Container(
              height: 56,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
                ),
              ),
              child: const Center(
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
        ),
      ],
    );
  }
}

class AddSchoolBtn extends StatelessWidget {
  final ViewSchoolViewModel viewModel;
  const AddSchoolBtn({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.toggleAddUser(),

      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color(0xff9D5DE6), width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              color: Color(0xff9D5DE6),
              size: 25,
              fontWeight: FontWeight.w900,
            ),
            Text(
              'Add School',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
