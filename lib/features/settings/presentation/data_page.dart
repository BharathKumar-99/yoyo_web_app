import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school_view_model.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/widget/edit_school_widget.dart';
import 'package:yoyo_web_app/features/settings/presentation/settings_view_model.dart';

settingsMobile() =>
    Scaffold(appBar: CommonWidgets.homeAppBarMobile(), body: data());
settingsTablet() => Scaffold(appBar: CommonWidgets.homeAppBar(), body: data());
settingsDesktop() => Scaffold(appBar: CommonWidgets.homeAppBar(), body: data());

data() {
  return Consumer<EditSchoolViewModel>(
    builder: (context, viewmodel, s) {
      if (viewmodel.commonViewModel.selectedSchool == null) {
        return const Center(child: Text('Select a School'));
      }
      if (viewmodel.commonViewModel.selectedClass == null) {
        return const Center(child: Text('Select a Class'));
      }

      return DefaultTabController(
        length: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 29.0, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: Colors.deepPurple,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.deepPurple,
                  tabs: [
                    Tab(text: "Difficulty"),
                    Tab(text: "New Features"),
                    Tab(text: "Homework"),
                    Tab(text: "Security"),
                    Tab(text: "AI Prompt"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Difficulty Box
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(29.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EditSchoolWidget.getSlack(viewmodel),
                          EditSchoolWidget.passThreshold(viewmodel),
                          EditSchoolWidget.lowerThreshold(viewmodel),
                        ],
                      ),
                    ),
                  ),

                  // New Features
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(29.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EditSchoolWidget.streak(viewmodel),
                          EditSchoolWidget.matery(viewmodel),
                          EditSchoolWidget.warmup(viewmodel),
                        ],
                      ),
                    ),
                  ),

                  // Homework Config Widget
                  const _HomeworkConfigWidget(),

                  // Security Config Widget
                  const _SecurityConfigWidget(),

                  // AI Prompt Widget
                  const _AIPromptWidget(),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _AIPromptWidget extends StatelessWidget {
  const _AIPromptWidget();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CommonViewModel, SettingsViewModel>(
      create: (context) =>
          SettingsViewModel(commonViewModel: context.read<CommonViewModel>()),
      update: (context, commonViewModel, previous) => previous!,
      child: Consumer<SettingsViewModel>(
        builder: (context, provider, w) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(29.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Text('Phrase Prompt'),
                  TextField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    maxLines: 6,
                    controller: provider.phrasePromptController,
                    onChanged: (value) {
                      provider.checkPhrasePromptChange();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      hintText: 'Enter Phrase Prompt',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !provider.isPhrasePromptChanged
                          ? Colors.grey
                          : Colors.deepPurple,
                    ),
                    onPressed: () {
                      if (!provider.isPhrasePromptChanged) {
                        return;
                      } else {
                        provider.updateAiPrompt();
                      }
                    },
                    child: const Text("Save"),
                  ),

                  Text('Set Homework (Selected)'),
                  TextField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    maxLines: 6,
                    controller: provider.setHomeworkPromptController,
                    onChanged: (value) {
                      provider.checkSetHomeworkPromptChange();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      hintText: 'Enter Set Homework Prompt',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !provider.isSetHomeworkPromptChanged
                          ? Colors.grey
                          : Colors.deepPurple,
                    ),
                    onPressed: () {
                      if (!provider.isSetHomeworkPromptChanged) {
                        return;
                      } else {
                        provider.updateAiPrompt();
                      }
                    },
                    child: const Text("Save"),
                  ),

                  Text('Set Homework (Prompted)'),
                  TextField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    maxLines: 6,
                    onChanged: (value) {
                      provider.checkAutoHomeworkPromptChange();
                    },
                    controller: provider.autoHomeworkPromptController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      hintText: 'Enter Homework Prompt Based on Prompt',
                    ),
                  ),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !provider.isAutoHomeworkPromptChanged
                          ? Colors.grey
                          : Colors.deepPurple,
                    ),
                    onPressed: () {
                      if (!provider.isAutoHomeworkPromptChanged) {
                        return;
                      } else {
                        provider.updateAiPrompt();
                      }
                    },
                    child: const Text("Save"),
                  ),
                  const SizedBox(height: 16),
                  Text('Homework Prompt Based on Attached Document'),
                  TextField(
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    maxLines: 6,
                    onChanged: (value) {
                      provider.checkDocHomeworkPromptChange();
                    },
                    controller: provider.docHomeworkPromptController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      hintText:
                          'Enter Homework Prompt Based on Attached Document',
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !provider.isDocHomeworkPromptChanged
                          ? Colors.grey
                          : Colors.deepPurple,
                    ),
                    onPressed: () {
                      if (!provider.isDocHomeworkPromptChanged) {
                        return;
                      } else {
                        provider.updateAiPrompt();
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SecurityConfigWidget extends StatelessWidget {
  const _SecurityConfigWidget();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CommonViewModel, SettingsViewModel>(
      create: (context) =>
          SettingsViewModel(commonViewModel: context.read<CommonViewModel>()),
      update: (context, commonViewModel, previous) => previous!,
      child: Consumer<SettingsViewModel>(
        builder: (context, provider, w) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(29.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Activation Code Through Teacher Only'),
                      Switch.adaptive(
                        value:
                            provider
                                .commonViewModel
                                .selectedClass
                                ?.activationCodeThroughTeacher ??
                            false,
                        onChanged: (v) {
                          provider.setActivationCodeThroughTeacher(v);
                        },
                      ),
                    ],
                  ),
                  if (provider.commonViewModel.isAdmin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Allow Teachers to set categories'),
                        Switch.adaptive(
                          value:
                              provider
                                  .commonViewModel
                                  .selectedClass
                                  ?.allowTeachersToSetCategories ??
                              false,
                          onChanged: (v) {
                            provider.setAllowTeachersToSetCategories(v);
                          },
                        ),
                      ],
                    ),

                  if (provider.commonViewModel.isAdmin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Allow Teachers to set Phrases'),
                        Switch.adaptive(
                          value:
                              provider
                                  .commonViewModel
                                  .selectedClass
                                  ?.allowTeachersToSetPhrases ??
                              false,
                          onChanged: (v) {
                            provider.setAllowTeachersToSetPhrases(v);
                          },
                        ),
                      ],
                    ),
                  if (provider.commonViewModel.isAdmin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Allow Teachers to set Bulk Phrases'),
                        Switch.adaptive(
                          value:
                              provider
                                  .commonViewModel
                                  .selectedClass
                                  ?.allowTeachersToSetBulkPhrases ??
                              false,
                          onChanged: (v) {
                            provider.setAllowTeachersToSetBulkPhrases(v);
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HomeworkConfigWidget extends StatelessWidget {
  const _HomeworkConfigWidget();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CommonViewModel, SettingsViewModel>(
      create: (context) =>
          SettingsViewModel(commonViewModel: context.read<CommonViewModel>()),
      update: (context, commonViewModel, previous) => previous!,
      child: Consumer<SettingsViewModel>(
        builder: (context, provider, w) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(29.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manual Cadance',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    width: 300,
                    value: provider.selectedManualCadance,
                    items: provider.manualCadance,
                    onChanged: provider.setManualCadance,
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Auto Cadance',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildDropdown(
                        width: 180,
                        value: provider.selectedAutoCadance,
                        items: provider.autoCadance,
                        onChanged: provider.setAutoCadance,
                      ),
                      const SizedBox(width: 15),
                      _buildDropdown(
                        width: 100,
                        value: provider.selectedAutoCadanceTime,
                        items: provider.autoCandanceTime,
                        onChanged: provider.setAutoCadanceTime,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Homework Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    width: 200,
                    value: provider.selectedNotification,
                    items: provider.notification,
                    onChanged: provider.setNotification,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown({
    required double width,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Container(
      width: width,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFC0A9EA),
        ), // Light purple border
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: Colors.black54,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            );
          }).toList(),
          onChanged: (val) => onChanged(val!),
        ),
      ),
    );
  }
}
