import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/notification/presentation/notification_view_model.dart';

class NotificationSettings extends StatelessWidget {
  final NotificationViewModel viewModel;

  const NotificationSettings({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    const Color purpleBorderColor = Color(0xFFC1B0EB);
    const Color textGreyColor = Color(0xFF7A7A7A);
    const Color darkTextColor = Color(0xFF2D2D2D);

    Widget buildLabel(String text) {
      return SizedBox(
        width: 100,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: darkTextColor,
          ),
        ),
      );
    }

    Widget buildTextField({
      required String hint,
      required String subText,
      required int maxLength,
      required TextEditingController controller,
      int maxLines = 1,
    }) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: purpleBorderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                maxLength: maxLength,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: textGreyColor,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subText,
                    style: const TextStyle(
                      color: textGreyColor,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ),
                Text(
                  '${controller.text.length}/$maxLength',
                  style: const TextStyle(
                    color: textGreyColor,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget buildCheckbox(
      String label,
      bool value,
      ValueChanged<bool?> onChanged,
    ) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            side: const BorderSide(color: purpleBorderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            activeColor: purpleBorderColor,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: darkTextColor),
          ),
        ],
      );
    }

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Adjust layout slightly for smaller screens if needed,
            // but typically web UI will have plenty of space.
            return viewModel.commonViewModel.selectedClass == null
                ? SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: Center(
                      child: Text(
                        'Please Select Class',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Field
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: buildLabel('Title'),
                            ),
                            buildTextField(
                              hint: 'Type Notification here',
                              subText:
                                  '[teacher] - insert teacher name\n[class] - insert class name',
                              maxLength: 40,
                              controller: viewModel.titleController,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Body Field
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: buildLabel('Body'),
                            ),
                            buildTextField(
                              hint: 'Type Notification here',
                              subText:
                                  '[teacher] - insert teacher name\n>class< - insert class name\n[date] - insert due date',
                              maxLength: 120,
                              maxLines: 4,
                              controller: viewModel.bodyController,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Trigger Checkboxes
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: buildLabel('Trigger'),
                            ),
                            Expanded(
                              child: Wrap(
                                spacing: 16.0,
                                runSpacing: 8.0,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: buildCheckbox(
                                      'Homework Set',
                                      viewModel.hwSet,
                                      (val) => viewModel.toggleTrigger(
                                        'hwSet',
                                        val ?? false,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: buildCheckbox(
                                      'Revise for Exam',
                                      viewModel.reviseExam,
                                      (val) => viewModel.toggleTrigger(
                                        'reviseExam',
                                        val ?? false,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: buildCheckbox(
                                      'Top of School League',
                                      viewModel.topSchoolLeague,
                                      (val) => viewModel.toggleTrigger(
                                        'topSchoolLeague',
                                        val ?? false,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: buildCheckbox(
                                      'Homework Due',
                                      viewModel.hwDue,
                                      (val) => viewModel.toggleTrigger(
                                        'hwDue',
                                        val ?? false,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: buildCheckbox(
                                      'Homework Champion',
                                      viewModel.hwChampion,
                                      (val) => viewModel.toggleTrigger(
                                        'hwChampion',
                                        val ?? false,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: buildCheckbox(
                                      'Top of Class League',
                                      viewModel.topClassLeague,
                                      (val) => viewModel.toggleTrigger(
                                        'topClassLeague',
                                        val ?? false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Delivery Dropdown
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            buildLabel('Delivery'),
                            if (viewModel.deliveryMode == 'On a date')
                              // Date Selector Mode
                              Container(
                                width: 250,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: purpleBorderColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final date = await showDatePicker(
                                            context: context,
                                            initialDate:
                                                viewModel
                                                    .selectedDeliveryDate ??
                                                DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2100),
                                          );
                                          if (date != null) {
                                            viewModel.setDeliveryDate(date);
                                          }
                                        },
                                        child: Text(
                                          viewModel.selectedDeliveryDate != null
                                              ? "${viewModel.selectedDeliveryDate!.day.toString().padLeft(2, '0')}/${viewModel.selectedDeliveryDate!.month.toString().padLeft(2, '0')}/${viewModel.selectedDeliveryDate!.year}"
                                              : 'Select a date...',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: darkTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (!viewModel.reviseExam)
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: () {
                                            viewModel.resetDelivery();
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            size: 20,
                                            color: textGreyColor,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            else
                              // Dropdown Mode
                              Container(
                                width: 200,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: purpleBorderColor),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: viewModel.deliveryMode,
                                    isExpanded: true,
                                    isDense: true,
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: textGreyColor,
                                    ),
                                    items: viewModel.deliveryOptions.map((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: darkTextColor,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        viewModel.setDeliveryMode(newValue);
                                      }
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Add Button
                        Row(
                          children: [
                            const SizedBox(width: 100), // Offset by label width
                            Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFCA581), // Orange/Peach
                                    Color(0xFFB181FA), // Purple
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () =>
                                      viewModel.updateNotificationSettings(),
                                  child: Center(
                                    child: Text(
                                      viewModel.isEditMode ? 'Save' : 'Add',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // Saved Notification Item
                        if (viewModel.hwSet
                            ? viewModel
                                      .notificationSettingsModel
                                      ?.settings
                                      ?.homeWorkSet
                                      ?.title !=
                                  null
                            : viewModel.hwDue
                            ? viewModel
                                      .notificationSettingsModel
                                      ?.settings
                                      ?.homeWorkDue
                                      ?.title !=
                                  null
                            : viewModel.reviseExam
                            ? viewModel
                                      .notificationSettingsModel
                                      ?.settings
                                      ?.reviseExam
                                      ?.title !=
                                  null
                            : viewModel.hwChampion
                            ? viewModel
                                      .notificationSettingsModel
                                      ?.settings
                                      ?.hwChampion
                                      ?.title !=
                                  null
                            : viewModel.topSchoolLeague
                            ? viewModel
                                      .notificationSettingsModel
                                      ?.settings
                                      ?.topSchoolLeague
                                      ?.title !=
                                  null
                            : viewModel.topClassLeague
                            ? viewModel
                                      .notificationSettingsModel
                                      ?.settings
                                      ?.topClassLeague
                                      ?.title !=
                                  null
                            : false)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Switch
                              Switch.adaptive(
                                value: viewModel.hwSet
                                    ? viewModel
                                              .notificationSettingsModel
                                              ?.settings
                                              ?.homeWorkSet
                                              ?.active ??
                                          false
                                    : viewModel.hwDue
                                    ? viewModel
                                              .notificationSettingsModel
                                              ?.settings
                                              ?.homeWorkDue
                                              ?.active ??
                                          false
                                    : viewModel.reviseExam
                                    ? viewModel
                                              .notificationSettingsModel
                                              ?.settings
                                              ?.reviseExam
                                              ?.active ??
                                          false
                                    : viewModel.hwChampion
                                    ? viewModel
                                              .notificationSettingsModel
                                              ?.settings
                                              ?.hwChampion
                                              ?.active ??
                                          false
                                    : viewModel.topSchoolLeague
                                    ? viewModel
                                              .notificationSettingsModel
                                              ?.settings
                                              ?.topSchoolLeague
                                              ?.active ??
                                          false
                                    : viewModel.topClassLeague
                                    ? viewModel
                                              .notificationSettingsModel
                                              ?.settings
                                              ?.topClassLeague
                                              ?.active ??
                                          false
                                    : false,
                                onChanged: (val) {
                                  viewModel.toggleNotificationSettings(val);
                                },
                                activeThumbColor: Colors.white,
                                activeTrackColor: const Color(
                                  0xFF4ADE80,
                                ), // Bright green
                              ),
                              const SizedBox(width: 16),

                              // Notification Text Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          '🔔',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          viewModel.hwSet
                                              ? viewModel
                                                        .notificationSettingsModel
                                                        ?.settings
                                                        ?.homeWorkSet
                                                        ?.title ??
                                                    'Not Set'
                                              : viewModel.hwDue
                                              ? viewModel
                                                        .notificationSettingsModel
                                                        ?.settings
                                                        ?.homeWorkDue
                                                        ?.title ??
                                                    'Not Set'
                                              : viewModel.reviseExam
                                              ? viewModel
                                                        .notificationSettingsModel
                                                        ?.settings
                                                        ?.reviseExam
                                                        ?.title ??
                                                    'Not Set'
                                              : viewModel.hwChampion
                                              ? viewModel
                                                        .notificationSettingsModel
                                                        ?.settings
                                                        ?.hwChampion
                                                        ?.title ??
                                                    'Not Set'
                                              : viewModel.topSchoolLeague
                                              ? viewModel
                                                        .notificationSettingsModel
                                                        ?.settings
                                                        ?.topSchoolLeague
                                                        ?.title ??
                                                    'Not Set'
                                              : viewModel.topClassLeague
                                              ? viewModel
                                                        .notificationSettingsModel
                                                        ?.settings
                                                        ?.topClassLeague
                                                        ?.title ??
                                                    'Not Set'
                                              : 'Not Set',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: darkTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${viewModel.hwSet
                                          ? viewModel.notificationSettingsModel?.settings?.homeWorkSet?.body ?? 'Not Set'
                                          : viewModel.hwDue
                                          ? viewModel.notificationSettingsModel?.settings?.homeWorkDue?.body ?? 'Not Set'
                                          : viewModel.reviseExam
                                          ? viewModel.notificationSettingsModel?.settings?.reviseExam?.body ?? 'Not Set'
                                          : viewModel.hwChampion
                                          ? viewModel.notificationSettingsModel?.settings?.hwChampion?.body ?? 'Not Set'
                                          : viewModel.topSchoolLeague
                                          ? viewModel.notificationSettingsModel?.settings?.topSchoolLeague?.body ?? 'Not Set'
                                          : viewModel.topClassLeague
                                          ? viewModel.notificationSettingsModel?.settings?.topClassLeague?.body ?? 'Not Set'
                                          : 'Not Set'} for ${viewModel.commonViewModel.selectedClass?.className}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: darkTextColor.withAlpha(
                                          204,
                                        ), // 80% opacity
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Trigger info
                              SizedBox(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      viewModel.hwSet
                                          ? 'Homework Set'
                                          : viewModel.hwDue
                                          ? 'Homework Due'
                                          : viewModel.reviseExam
                                          ? 'Revise Exam'
                                          : viewModel.hwChampion
                                          ? 'Homework Champion'
                                          : viewModel.topSchoolLeague
                                          ? 'Top School League'
                                          : viewModel.topClassLeague
                                          ? 'Top Class League'
                                          : '',
                                      style: TextStyle(
                                        color: Color(0xFF9E77ED), // Purple text
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      viewModel.hwSet
                                          ? viewModel
                                                    .notificationSettingsModel
                                                    ?.settings
                                                    ?.homeWorkSet
                                                    ?.deliveryMode ??
                                                'Not Set'
                                          : viewModel.hwDue
                                          ? viewModel
                                                    .notificationSettingsModel
                                                    ?.settings
                                                    ?.homeWorkDue
                                                    ?.deliveryMode ??
                                                'Not Set'
                                          : viewModel.reviseExam
                                          ? viewModel
                                                    .notificationSettingsModel
                                                    ?.settings
                                                    ?.reviseExam
                                                    ?.deliveryMode ??
                                                'Not Set'
                                          : viewModel.hwChampion
                                          ? viewModel
                                                    .notificationSettingsModel
                                                    ?.settings
                                                    ?.hwChampion
                                                    ?.deliveryMode ??
                                                'Not Set'
                                          : viewModel.topSchoolLeague
                                          ? viewModel
                                                    .notificationSettingsModel
                                                    ?.settings
                                                    ?.topSchoolLeague
                                                    ?.deliveryMode ??
                                                'Not Set'
                                          : viewModel.topClassLeague
                                          ? viewModel
                                                    .notificationSettingsModel
                                                    ?.settings
                                                    ?.topClassLeague
                                                    ?.deliveryMode ??
                                                'Not Set'
                                          : 'Not Set',
                                      style: TextStyle(
                                        color: const Color(
                                          0xFF9E77ED,
                                        ).withAlpha(204), // 80% opacity
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // View / Edit Button
                              GestureDetector(
                                onTap: () {
                                  viewModel.editMode();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: purpleBorderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: const Text(
                                    'View / Edit',
                                    style: TextStyle(
                                      color: darkTextColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }
}
