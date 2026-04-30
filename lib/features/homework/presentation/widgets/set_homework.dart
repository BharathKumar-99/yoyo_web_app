import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/homework/presentation/set_homework_viewmodel.dart';
import 'package:yoyo_web_app/features/homework/presentation/widgets/previous_homework.dart';
import 'package:yoyo_web_app/features/login/presentation/widgets/loader.dart';

import '../../../../config/constants/constants.dart';

class SetHomeworkTab extends StatelessWidget {
  final SetHomeworkViewmodel value;
  const SetHomeworkTab(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: value.isLoading
          ? Padding(padding: const EdgeInsets.all(16.0), child: YoyoWaiting())
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 16, 16, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildTabMenuRadio(
                          label: "By Prompt",
                          isSelected: value.isByPrompt,
                          onTap: () => value.setIsByPrompt(true),
                        ),
                        const SizedBox(width: 24),
                        _buildTabMenuRadio(
                          label: "By Selection",
                          isSelected: !value.isByPrompt,
                          onTap: () => value.setIsByPrompt(false),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: value.isByPrompt
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(40, 16, 16, 4),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 30,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 20,
                                          children: [
                                            Row(
                                              spacing: 30,
                                              children: [
                                                Icon(Icons.home_outlined),
                                                Text(
                                                  'Set NEW Homework',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.titleLarge,
                                                ),
                                              ],
                                            ),
                                            TextField(
                                              maxLines: 6,
                                              controller:
                                                  value.setPromptController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                                hintText:
                                                    'Example: Create speaking homework on holidays, focusing on the past tense, opinions, and extending answers',
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: value.pickSetFile,
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.upload_file_outlined,
                                                    size: 30,
                                                  ),
                                                  const SizedBox(width: 10),

                                                  // File name or placeholder
                                                  Expanded(
                                                    child: Text(
                                                      value.setFileName ??
                                                          'UPLOAD Docs:: Text book material, print off exercises etc',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            value.setFileName ==
                                                                null
                                                            ? Colors.grey
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                  ),

                                                  // Remove button
                                                  if (value.setFileName != null)
                                                    GestureDetector(
                                                      onTap:
                                                          value.removeSetFile,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 6,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color:
                                                                Colors.purple,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        child: const Text(
                                                          'X',
                                                          style: TextStyle(
                                                            color:
                                                                Colors.purple,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: value.useUploads,
                                                  onChanged: (v) {
                                                    value.setUseUploads(v!);
                                                  },
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Tick if you want YoYo to use the content on the uploads exactly as it is (e.g. list of phrases)',
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: Size(319, 56),
                                                backgroundColor: Color(
                                                  0xff6061F6,
                                                ),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () => value
                                                  .saveSetHomework(context),
                                              child: Text(
                                                'Create Homework',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '*Homework is sent according to settings',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  ImageConstants.remember,
                                                  height: 40,
                                                  width: 40,
                                                  cacheHeight: 40,
                                                  cacheWidth: 40,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Remember:',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 12),

                                            const Text(
                                              'We already know: Language, Class, Year, Level, Previous work and results.',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                height: 1.4,
                                              ),
                                            ),

                                            const SizedBox(height: 24),

                                            _actionRow(
                                              label: 'Topic',
                                              color: const Color(0xFFFF8A3D),
                                              description:
                                                  'e.g.: holidays, friends, school, family',
                                            ),

                                            const SizedBox(height: 14),

                                            _actionRow(
                                              label: 'Focus',
                                              color: const Color(0xFF7B61FF),
                                              description:
                                                  'e.g. past tense and opinions',
                                            ),

                                            const SizedBox(height: 14),

                                            _actionRow(
                                              label: 'Outcome',
                                              color: const Color(0xFFFF5C5C),
                                              description:
                                                  'e.g. Outcome: short but developable speaking answers',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  PreviousHomework(
                                    value.previousHomework ?? [],
                                    value
                                            .commonViewModel
                                            .selectedClass
                                            ?.studentClasses
                                            ?.length ??
                                        0,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Due Date
                                  _buildDatePickerBox(
                                    context,
                                    'Due Date',
                                    value,
                                  ),

                                  const SizedBox(height: 20),

                                  /// Structures
                                  Text(
                                    "Structures (Select 0-1)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: value.structures.map((item) {
                                      return _structureChip(
                                        item,
                                        Colors.orange,
                                        value,
                                      );
                                    }).toList(),
                                  ),

                                  const SizedBox(height: 20),

                                  /// Subjects
                                  Text(
                                    "Subjects (Select 0-2)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: value.subjects.map((item) {
                                      return _subjectChip(
                                        item,
                                        Colors.purple,
                                        value,
                                      );
                                    }).toList(),
                                  ),

                                  const SizedBox(height: 20),

                                  Text(
                                    "Anything Else",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  _buildInputBox(
                                    "Type here (e.g any other structure of subjects)",
                                    context,
                                    value.anythingElseController,
                                    maxLines: 4,
                                  ),
                                  SizedBox(height: 20),

                                  /// Button
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        fixedSize: Size(319, 56),
                                        backgroundColor: Color(0xff6061F6),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () =>
                                          value.createHomework(context),
                                      child: Text("Create Homework"),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  PreviousHomework(
                                    value.previousHomework ?? [],
                                    value
                                            .commonViewModel
                                            .selectedClass
                                            ?.studentClasses
                                            ?.length ??
                                        0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}

_buildInputBox(
  String hint,
  BuildContext context,
  TextEditingController controller, {
  int maxLines = 1,
}) {
  return SizedBox(
    width: MediaQuery.sizeOf(context).width / 3,
    child: TextField(
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

String _formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}

Widget _buildDatePickerBox(
  BuildContext context,
  String hint,
  SetHomeworkViewmodel provider,
) {
  return SizedBox(
    width: MediaQuery.sizeOf(context).width / 4,
    child: InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: provider.selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          provider.pickDate(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined),
            const SizedBox(width: 10),

            /// Text / Selected Date
            Text(
              provider.selectedDate != null
                  ? _formatDate(provider.selectedDate!)
                  : hint,
              style: TextStyle(
                color: provider.selectedDate != null
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _structureChip(String text, Color color, SetHomeworkViewmodel provider) {
  return GestureDetector(
    onTap: () => provider.selectStructure(text),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: provider.selectedStructure.contains(text)
            ? color
            : color.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget _subjectChip(String text, Color color, SetHomeworkViewmodel provider) {
  return GestureDetector(
    onTap: () => provider.selectSubject(text),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: provider.selectedSubject.contains(text)
            ? color
            : color.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget _buildTabMenuRadio({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black54, width: 1),
            color: isSelected ? const Color(0xFFCBA4FA) : Colors.transparent,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    ),
  );
}

Widget _actionRow({
  required String label,
  required Color color,
  required String description,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 1.2),
        ),
        child: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Text(
          description,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ),
    ],
  );
}
