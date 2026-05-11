import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/edit_school/model/remote_config.dart';
import 'package:yoyo_web_app/features/edit_school/presentation/edit_school_view_model.dart';
import 'package:yoyo_web_app/features/home/model/classes_model.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/home/model/student_classes.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';

class EditSchoolWidget {
  static editSchool() =>
      Text('View / Edit School', style: AppTextStyles.textTheme.headlineLarge);
  static editSchoolStat() =>
      Text('Statistics', style: AppTextStyles.textTheme.headlineLarge);

  static editSchoolSettings() => Text(
    'Edit School Settings',
    style: AppTextStyles.textTheme.headlineLarge,
  );

  static editSchoolstats(EditSchoolViewModel viewmodel) {
    int activeStudents = 0;
    int attempts = 0;
    int learned = 0;
    List<int> totalScore = [];

    List<UserModel> users = [];
    for (Classes element
        in viewmodel.commonViewModel.selectedSchool?.classes ?? []) {
      for (StudentClassesModel stdClass in element.studentClasses ?? []) {
        if (stdClass.user?.isTester != true) {
          users.add(stdClass.user!);
        }
      }
    }

    for (var element in users) {
      if (element.userResult?.isNotEmpty ?? false) {
        activeStudents += 1;
      }
      for (UserResult res in element.userResult ?? []) {
        attempts += res.attempt ?? 0;
        learned += res.type == 'Learned' ? 1 : 0;
        if (res.scoreSubmitted == true) totalScore.add(res.score ?? 0);
      }
    }

    int avg = totalScore.isEmpty
        ? 0
        : totalScore.fold(0, (pre, v) => pre + v) ~/ totalScore.length;

    int participation = users.isEmpty
        ? 0
        : ((activeStudents / users.length) * 100).round();

    return Row(
      children: [
        Expanded(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('No Students', style: Theme.of(ctx!).textTheme.titleSmall),
              Text(
                users.length.toString(),
                style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Students',
                style: Theme.of(ctx!).textTheme.titleSmall,
              ),
              Text(
                activeStudents.toString(),
                style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Participation Percentage',
                style: Theme.of(ctx!).textTheme.titleSmall,
              ),
              Text(
                participation.toString(),
                style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Attempts',
                style: Theme.of(ctx!).textTheme.titleSmall,
              ),
              Text(
                attempts.toString(),
                style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Learned', style: Theme.of(ctx!).textTheme.titleSmall),
              Text(
                learned.toString(),
                style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Avg Score', style: Theme.of(ctx!).textTheme.titleSmall),
              Text(
                avg.toString(),
                style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static editSchoolStatsMobile(EditSchoolViewModel viewmodel) {
    int activeStudents = 0;
    int attempts = 0;
    int learned = 0;
    List<int> totalScore = [];

    List<UserModel> users = [];
    for (Classes element
        in viewmodel.commonViewModel.selectedSchool?.classes ?? []) {
      for (StudentClassesModel stdClass in element.studentClasses ?? []) {
        if (stdClass.user?.isTester != true) {
          users.add(stdClass.user!);
        }
      }
    }

    for (var element in users) {
      if (element.userResult?.isNotEmpty ?? false) {
        activeStudents += 1;
      }
      for (UserResult res in element.userResult ?? []) {
        attempts += res.attempt ?? 0;
        learned += res.type == 'Learned' ? 1 : 0;
        if (res.scoreSubmitted == true) totalScore.add(res.score ?? 0);
      }
    }

    int avg = totalScore.isEmpty
        ? 0
        : totalScore.fold(0, (pre, v) => pre + v) ~/ totalScore.length;

    int participation = users.isEmpty
        ? 0
        : ((activeStudents / users.length) * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No Students',
                    style: Theme.of(ctx!).textTheme.titleSmall,
                  ),
                  Text(
                    users.length.toString(),
                    style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Students',
                    style: Theme.of(ctx!).textTheme.titleSmall,
                  ),
                  Text(
                    activeStudents.toString(),
                    style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Participation Percentage',
                    style: Theme.of(ctx!).textTheme.titleSmall,
                  ),
                  Text(
                    participation.toString(),
                    style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Attempts',
                    style: Theme.of(ctx!).textTheme.titleSmall,
                  ),
                  Text(
                    attempts.toString(),
                    style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Learned',
                    style: Theme.of(ctx!).textTheme.titleSmall,
                  ),
                  Text(
                    learned.toString(),
                    style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 15,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Avg Score', style: Theme.of(ctx!).textTheme.titleSmall),
                  Text(
                    avg.toString(),
                    style: Theme.of(ctx!).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static classText(EditSchoolViewModel vm) => Text(
    'Classes(${vm.commonViewModel.selectedSchool?.classes?.length ?? 0})',
    style: AppTextStyles.textTheme.headlineLarge,
  );

  static addClassBtn(EditSchoolViewModel viewModel) => GestureDetector(
    onTap: () => viewModel.toggleAddClass(),

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
            'Add Class',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );

  static Widget addWidget(EditSchoolViewModel value) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );

    return (value.addClass)
        ? Row(
            spacing: 30,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  spacing: 20,
                  children: [
                    Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextField(
                                controller: value.className,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff9D5DE6),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff9D5DE6),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //drop down to select a year from year 3 to year 14
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Year',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff9D5DE6),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xff9D5DE6),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                items: List.generate(12, (index) => index + 3)
                                    .map((year) {
                                      return DropdownMenuItem<String>(
                                        value: year.toString(),
                                        child: Text('Year $year'),
                                      );
                                    })
                                    .toList(),
                                onChanged: (val) {
                                  value.selectedYear = val;
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Language',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              DropdownButtonFormField<Language?>(
                                initialValue: value.selectedLanguage,
                                isExpanded: true,
                                selectedItemBuilder: (context) {
                                  final widgets = <Widget>[];

                                  widgets.addAll(
                                    value.languages.map(
                                      (e) => Text(
                                        e.language ?? '',
                                        style: AppTextStyles
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                  return widgets;
                                },

                                items: [
                                  ...value.languages.map(
                                    (e) => DropdownMenuItem<Language?>(
                                      value: e,
                                      child: Text(
                                        e.language ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],

                                onChanged: (val) => value.selectLang(val),

                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  border: border,
                                  enabledBorder: border,
                                  focusedBorder: border.copyWith(
                                    borderSide: const BorderSide(
                                      color: Color(0xff9D5DE6),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: GestureDetector(
                        onTap: () async => value.addClasses(),
                        child: Container(
                          height: 56,
                          width: 100,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
                            ),
                          ),
                          child: Center(
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
                ),
              ),
            ],
          )
        : SizedBox.shrink();
  }

  static streak(EditSchoolViewModel viewmodel) => ListTile(
    title: Text("Streak", style: AppTextStyles.textTheme.titleLarge),
    trailing: Switch.adaptive(
      value: viewmodel.apiCred?.streak ?? false,
      onChanged: (val) {
        viewmodel.updateStreakEnabled(val, viewmodel.apiCred?.schoolId ?? 0);
      },
    ),
  );
  static matery(EditSchoolViewModel viewmodel) => ListTile(
    title: Text("Master", style: AppTextStyles.textTheme.titleLarge),
    trailing: Switch.adaptive(
      value: viewmodel.apiCred?.mastery ?? false,
      onChanged: (val) {
        viewmodel.updateMasterEnabled(val, viewmodel.apiCred?.schoolId ?? 0);
      },
    ),
  );
  static warmup(EditSchoolViewModel viewmodel) => ListTile(
    title: Text("Warm up", style: AppTextStyles.textTheme.titleLarge),
    trailing: Switch.adaptive(
      value: viewmodel.apiCred?.warmup ?? false,
      onChanged: (val) {
        viewmodel.updateWarmupEnabled(val, viewmodel.apiCred?.schoolId ?? 0);
      },
    ),
  );

  static passThreshold(EditSchoolViewModel viewmodel) => ListTile(
    title: Text("Pass Threshold", style: AppTextStyles.textTheme.titleLarge),
    subtitle: SizedBox(
      width: 80,
      child: TextField(controller: viewmodel.passThreshold),
    ),
    trailing: ElevatedButton(
      onPressed: () => viewmodel.updatePass(),
      child: Text('Update'),
    ),
  );

  static lowerThreshold(EditSchoolViewModel viewmodel) => ListTile(
    title: Text("Lower Threshold", style: AppTextStyles.textTheme.titleLarge),
    subtitle: SizedBox(
      width: 80,
      child: TextField(controller: viewmodel.lowerThreshold),
    ),
    trailing: ElevatedButton(
      onPressed: () => viewmodel.updateLow(),
      child: Text('Update'),
    ),
  );

  static getSlack(EditSchoolViewModel provider) => provider.apiCred == null
      ? Container()
      : Column(
          children: [
            if (provider.commonViewModel.selectedSchool?.classes
                    ?.where((v) => v.language?.language == 'French')
                    .isNotEmpty ??
                false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("French", style: AppTextStyles.textTheme.titleLarge),
                  Slider(
                    value: provider.apiCred?.slack.fr.toDouble() ?? 0,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: provider.apiCred?.slack.fr
                        .toDouble()
                        .toStringAsFixed(0),
                    onChanged: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.fr = value;
                      provider.updateSlackLocal(slack!);
                    },
                    onChangeEnd: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.fr = value;
                      provider.updateSlack(slack!);
                    },
                  ),
                ],
              ),
            if (provider.commonViewModel.selectedSchool?.classes
                    ?.where((v) => v.language?.language == 'Russian')
                    .isNotEmpty ??
                false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Russian", style: AppTextStyles.textTheme.titleLarge),
                  Slider(
                    value: provider.apiCred?.slack.ru.toDouble() ?? 0,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: provider.apiCred?.slack.ru
                        .toDouble()
                        .toStringAsFixed(0),
                    onChanged: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.ru = value;
                      provider.updateSlackLocal(slack!);
                    },
                    onChangeEnd: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.ru = value;
                      provider.updateSlack(slack!);
                    },
                  ),
                ],
              ),
            if (provider.commonViewModel.selectedSchool?.classes
                    ?.where((v) => v.language?.language == 'Spanish')
                    .isNotEmpty ??
                false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Spanish", style: AppTextStyles.textTheme.titleLarge),
                  Slider(
                    value: provider.apiCred?.slack.sp.toDouble() ?? 0,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: provider.apiCred?.slack.sp
                        .toDouble()
                        .toStringAsFixed(0),
                    onChanged: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.sp = value;
                      provider.updateSlackLocal(slack!);
                    },
                    onChangeEnd: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.sp = value;
                      provider.updateSlack(slack!);
                    },
                  ),
                ],
              ),
            if (provider.commonViewModel.selectedSchool?.classes
                    ?.where((v) => v.language?.language == 'German')
                    .isNotEmpty ??
                false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("German", style: AppTextStyles.textTheme.titleLarge),
                  Slider(
                    value: provider.apiCred?.slack.de.toDouble() ?? 0,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: provider.apiCred?.slack.de
                        .toDouble()
                        .toStringAsFixed(0),
                    onChanged: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.de = value;
                      provider.updateSlackLocal(slack!);
                    },
                    onChangeEnd: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.de = value;
                      provider.updateSlack(slack!);
                    },
                  ),
                ],
              ),
            if (provider.commonViewModel.selectedSchool?.classes
                    ?.where((v) => v.language?.language == 'Korean')
                    .isNotEmpty ??
                false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Korean", style: AppTextStyles.textTheme.titleLarge),
                  Slider(
                    value: provider.apiCred?.slack.kr.toDouble() ?? 0,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: provider.apiCred?.slack.kr
                        .toDouble()
                        .toStringAsFixed(0),
                    onChanged: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.kr = value;
                      provider.updateSlackLocal(slack!);
                    },
                    onChangeEnd: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.kr = value;
                      provider.updateSlack(slack!);
                    },
                  ),
                ],
              ),
            if (provider.commonViewModel.selectedSchool?.classes
                    ?.where((v) => v.language?.language == 'Mandarin')
                    .isNotEmpty ??
                false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mandarin", style: AppTextStyles.textTheme.titleLarge),
                  Slider(
                    value: provider.apiCred?.slack.promaxCn.toDouble() ?? 0,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: provider.apiCred?.slack.promaxCn
                        .toDouble()
                        .toStringAsFixed(0),
                    onChanged: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.promaxCn = value;
                      provider.updateSlackLocal(slack!);
                    },
                    onChangeEnd: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.promaxCn = value;
                      provider.updateSlack(slack!);
                    },
                  ),
                ],
              ),
            if (provider.commonViewModel.selectedSchool?.classes
                    ?.where((v) => v.language?.language == 'Japanese')
                    .isNotEmpty ??
                false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Japanese", style: AppTextStyles.textTheme.titleLarge),
                  Slider(
                    value: provider.apiCred?.slack.jp.toDouble() ?? 0,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: provider.apiCred?.slack.jp
                        .toDouble()
                        .toStringAsFixed(0),
                    onChanged: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.jp = value;
                      provider.updateSlackLocal(slack!);
                    },
                    onChangeEnd: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.jp = value;
                      provider.updateSlack(slack!);
                    },
                  ),
                ],
              ),
            if (provider.commonViewModel.selectedSchool?.classes
                    ?.where((v) => v.language?.language == 'English')
                    .isNotEmpty ??
                false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("English", style: AppTextStyles.textTheme.titleLarge),
                  Slider(
                    value: provider.apiCred?.slack.promax.toDouble() ?? 0,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: provider.apiCred?.slack.promax
                        .toDouble()
                        .toStringAsFixed(0),
                    onChanged: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.promax = value;
                      provider.updateSlackLocal(slack!);
                    },
                    onChangeEnd: (value) {
                      LanguageSlack? slack = provider.apiCred?.slack;
                      slack?.promax = value;
                      provider.updateSlack(slack!);
                    },
                  ),
                ],
              ),
          ],
        );

  static editSchoolFirstRow(EditSchoolViewModel viewModel) => Row(
    spacing: 20,
    children: [
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            TextField(
              controller: viewModel.schoolName,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff9D5DE6)),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff9D5DE6)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            TextField(
              controller: viewModel.schoolPrinciple,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff9D5DE6)),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff9D5DE6)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  static editSchoolSecondRow(EditSchoolViewModel viewModel) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Address',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      TextField(
        controller: viewModel.schoolAdrs,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff9D5DE6)),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff9D5DE6)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ],
  );

  static editSchoolthirdRow(EditSchoolViewModel viewModel) => Row(
    spacing: 20,
    children: [
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            TextField(
              controller: viewModel.schoolEmail,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff9D5DE6)),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff9D5DE6)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phone No.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            TextField(
              controller: viewModel.schoolTelephone,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff9D5DE6)),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff9D5DE6)),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  static updateSchoolDataBtn(EditSchoolViewModel viewModel) => Row(
    children: [
      Expanded(
        flex: 2,
        child: ElevatedButton(
          onPressed: () => viewModel.updateSchool(),
          child: Text('Update'),
        ),
      ),
      Expanded(flex: 2, child: Container()),
    ],
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
        ],
      ),
    );
  }

  static Widget _buildImagePreview(EditSchoolViewModel viewModel) {
    if (viewModel.selectedImageBytes != null) {
      return Image.memory(viewModel.selectedImageBytes!, fit: BoxFit.fill);
    }

    if (viewModel.commonViewModel.selectedSchool?.image != null &&
        (viewModel.commonViewModel.selectedSchool?.image?.isNotEmpty ??
            false)) {
      return Image.network(
        viewModel.commonViewModel.selectedSchool!.image!,
        fit: BoxFit.contain,
      );
    }

    return const Center(child: Icon(Icons.image, size: 50, color: Colors.grey));
  }
}

class ClassTable extends StatelessWidget {
  final List<Classes> classes;
  const ClassTable({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Divider(height: 1),

        ...classes.map((row) => _buildRow(row)),
      ],
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          headerCell("Name", "", flex: 3),
          headerCell("Teacher", "", flex: 1),
          headerCell("No.Students", "", flex: 1),
          headerCell("Year", "", flex: 1),
          headerCell("Language", "", flex: 1),
          headerCell("participation", "", flex: 1),
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
  Widget _buildRow(Classes row) {
    int activeStudent = 0;
    UserModel? userModel;
    List<UserModel> users = [];

    for (StudentClassesModel stdClass in row.studentClasses ?? []) {
      if (stdClass.user?.isTester != true) {
        users.add(stdClass.user!);
      }
      if (stdClass.user?.teacher != null) {
        userModel = stdClass.user!;
      }
    }

    for (var element in users) {
      if (element.userResult?.isNotEmpty ?? false) {
        activeStudent += 1;
      }
    }
    int participated = users.isEmpty
        ? 0
        : ((activeStudent / users.length) * 100).round();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              spacing: 5,
              children: [
                Text(
                  row.className ?? '',
                  style: Theme.of(ctx!).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<EditSchoolViewModel>(
                      builder: (context, pro, w) {
                        return TextButton(
                          onPressed: () =>
                              pro.confirmDeleteClass(context, row.id ?? 0),
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
          rowCell('${userModel?.firstName} ${userModel?.surName}', flex: 1),
          rowCell('${users.length}', flex: 1),
          rowCell('Year ${row.year}', flex: 1),
          rowCell('${row.language?.language}', flex: 1),
          rowCell('$participated', flex: 1),
          Consumer<EditSchoolViewModel>(
            builder: (context, pro, w) {
              return Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      _showClassPopup(context, row);
                    },
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

  void _showClassPopup(BuildContext context, Classes classModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClassViewEditPopup(classModel: classModel),
        );
      },
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

class ClassViewEditPopup extends StatefulWidget {
  final Classes classModel;

  const ClassViewEditPopup({super.key, required this.classModel});

  @override
  State<ClassViewEditPopup> createState() => _ClassViewEditPopupState();
}

class _ClassViewEditPopupState extends State<ClassViewEditPopup> {
  late TextEditingController nameController;
  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.classModel.className);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Class Details",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Class Name
          _buildField("Class Name", nameController),

          const SizedBox(height: 16),

          /// Teacher
          _buildReadOnlyField(
            "Language",
            '${widget.classModel.language?.language} ${widget.classModel.language?.levelData?.level}',
          ),

          const SizedBox(height: 16),

          /// Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 12),
              Consumer<EditSchoolViewModel>(
                builder: (context, viewmodel, s) {
                  return ElevatedButton(
                    onPressed: () {
                      viewmodel.updateClass(
                        nameController.text.toString(),
                        widget.classModel.id ?? 0,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value),
        ),
      ],
    );
  }
}
