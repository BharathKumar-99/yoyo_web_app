import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/home/model/phrases_model.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

import '../phrases_view_model.dart';

Widget getDisabledPhrase(PhraseModel row,PhrasesViewModel provider)=> GestureDetector(
  onTap: () {
    final disabledSchoolIds = row.phraseDisabledSchools
        .map((e) => e.remoteConfig?.school?.id)
        .whereType<int>()
        .toSet();

    final availableSchools = provider.homedata
        .where((s) => !disabledSchoolIds.contains(s.id))
        .toList();

    final Set<School> selectedSchools = {};

    showDialog(
      context: ctx!,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Disable Phrase for Schools'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Already disabled
                    if (row.phraseDisabledSchools.isNotEmpty) ...[
                      const Text(
                        'Already Disabled',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: row.phraseDisabledSchools.map((e) {
                          return Chip(
                            label: Text(
                              e.remoteConfig?.school?.schoolName ?? '',
                              style: AppTextStyles.textTheme.bodySmall!
                                  .copyWith(fontSize: 10),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    /// 🔹 Select schools
                    const Text(
                      'Select Schools',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),

                    DropdownButtonFormField<School>(
                      hint: const Text('Choose a school'),
                      items: availableSchools.map((school) {
                        return DropdownMenuItem(
                          value: school,
                          child: Text(
                            school.schoolName ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (school) {
                        if (school == null) return;
                        setState(() {
                          selectedSchools.add(school);
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// 🔹 Selected schools
                    Wrap(
                      spacing: 6,
                      children: selectedSchools.map((school) {
                        return Chip(
                          label: Text(school.schoolName ?? ''),
                          onDeleted: () {
                            setState(() {
                              selectedSchools.remove(school);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// 🔹 Actions
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedSchools.isEmpty
                      ? null
                      : () async {
                          final ids =
                              selectedSchools.map((e) => e.id!).toList();

                          await provider.disablePhrase(
                            row.id!,
                            ids,
                          );

                          Navigator.pop(context);
                        },
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  },
  child: const Chip(
    label: Text('Disable'),
    avatar: Icon(Icons.disabled_by_default),
  ),
);
