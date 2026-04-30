import 'package:flutter/material.dart';

import '../../../../config/constants/constants.dart';
import '../set_homework_viewmodel.dart';
import 'previous_homework.dart';

class AutoSetHomework extends StatelessWidget {
  final SetHomeworkViewmodel value;
  const AutoSetHomework({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Toggle
              Row(
                spacing: 10,
                children: [
                  Switch(
                    activeThumbColor: Colors.green,
                    value: value.isEnabled,
                    onChanged: (val) => value.setIsEnabled(val),
                  ),
                  Icon(Icons.home_outlined),
                  Text('ON / OFF'),
                ],
              ),

              if (value.isEnabled) ...[
                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 30,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 20,
                        children: [
                          TextField(
                            maxLines: 6,
                            controller: value.promptController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              hintText:
                                  'Create a new speaking homework task for this class every week. Use the language and structures they have been learning recently, but also revisit older vocabulary regularly for retrieval practice. Keep the phrases appropriate for their age and ability, include a mix of core phrases and a few extension phrases, and vary the topic and sentence patterns so tasks do not feel repetitive.',
                            ),
                          ),
                          GestureDetector(
                            onTap: value.pickFile,
                            child: Row(
                              spacing: 30,
                              children: [
                                Image.asset(
                                  IconConstants.fileUpload,
                                  height: 40,
                                  width: 40,
                                  cacheHeight: 40,
                                  cacheWidth: 40,
                                ),
                                const SizedBox(width: 10),

                                // File name or placeholder
                                Text(
                                  value.fileName ?? 'Select Worksheet',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: value.fileName == null
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),

                                // Remove button
                                if (value.fileName != null)
                                  GestureDetector(
                                    onTap: value.removeFile,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.purple,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'X',
                                        style: TextStyle(color: Colors.purple),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(319, 56),
                              backgroundColor: Color.fromARGB(100, 96, 97, 246),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => value.saveconfig(context),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: Text(
                                'Save Homework',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Text(
                            '*Homework is sent according to settings',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            label: 'Build',
                            color: const Color(0xFFFF8A3D),
                            description: 'Use what the class has been learning',
                          ),

                          const SizedBox(height: 14),

                          _actionRow(
                            label: 'Retrieve',
                            color: const Color(0xFF7B61FF),
                            description:
                                'Bring back older vocabulary and structures',
                          ),

                          const SizedBox(height: 14),

                          _actionRow(
                            label: 'Vary',
                            color: const Color(0xFFFF5C5C),
                            description:
                                'Keep homework topics fresh week to week',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                PreviousHomework(
                  value.previousHomework ?? [],
                  value.commonViewModel.selectedClass?.studentClasses?.length ??
                      0,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
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
