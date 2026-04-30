import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/utils/textfield_extention.dart';
import 'package:yoyo_web_app/features/users/presentation/users_view_model.dart'
    show UsersViewModel;

class AddSingleTeacher extends StatefulWidget {
  final UsersViewModel viewModel;

  const AddSingleTeacher({super.key, required this.viewModel});

  @override
  State<AddSingleTeacher> createState() => _AddSingleTeacherState();
}

class _AddSingleTeacherState extends State<AddSingleTeacher> {
  late final TextEditingController nameController;
  late final TextEditingController surNameController;
  late final TextEditingController emailController;
  late final TextEditingController jobTitleController;
  late final TextEditingController userNameController;
  late final TextEditingController activationController;

  String selectedPermission = 'Teacher';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    surNameController = TextEditingController();
    emailController = TextEditingController();
    jobTitleController = TextEditingController();
    userNameController = TextEditingController();
    activationController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    surNameController.dispose();
    emailController.dispose();
    jobTitleController.dispose();
    userNameController.dispose();
    activationController.dispose();
    super.dispose();
  }

  void selectPermission(String? value) {
    if (value == null) return;
    setState(() {
      selectedPermission = value;
    });
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xff9D5DE6)),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xff9D5DE6)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          TextField(controller: controller, decoration: _inputDecoration()),
        ],
      ),
    );
  }

  Widget _activationField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activation Code',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          TextField(
            controller: activationController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [ActivationCodeFormatter()],
            decoration: _inputDecoration(hint: '-'),
          ),
        ],
      ),
    );
  }

  Widget _permissionDropdown() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Permission Level',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            child: DropdownButton<String>(
              value: selectedPermission,
              isDense: true,
              isExpanded: true,
              underline: const SizedBox(),
              items: widget.viewModel.permission
                  .map(
                    (val) =>
                        DropdownMenuItem<String>(value: val, child: Text(val)),
                  )
                  .toList(),
              onChanged: selectPermission,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    if (!viewModel.showAddTeacher) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// FORM
          Expanded(
            child: Column(
              children: [
                Row(
                  spacing: 15,
                  children: [
                    _field('Name', nameController),
                    _field('Surname', surNameController),
                    _field('Email', emailController),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  spacing: 15,
                  children: [
                    _field('Job Title', jobTitleController),
                    _field('Username', userNameController),
                    _activationField(),
                    _permissionDropdown(),
                  ],
                ),
              ],
            ),
          ),

          /// ADD BUTTON
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20),
            child: GestureDetector(
              onTap: () {
                viewModel.addTeacher(
                  nameController.text.trim(),
                  surNameController.text.trim(),
                  emailController.text.trim(),
                  jobTitleController.text.trim(),
                  userNameController.text.trim(),
                  activationController.text.trim(),
                  selectedPermission,
                );
              },
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
                  ),
                ),
                child: const Text(
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
    );
  }
}
