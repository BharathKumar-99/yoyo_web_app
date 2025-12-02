import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/home/model/phrases_model.dart';
import 'package:yoyo_web_app/features/phrases/presentation/phrases_view_model.dart';

class PhraseWidgets {
  static addPhraseTable(
    PhrasesViewModel viewModel, {
    bool isTablet = false,
    bool isMobile = false,
  }) => Table(
    columnWidths: isTablet || isMobile
        ? const {
            0: FlexColumnWidth(0.6),
            1: FlexColumnWidth(0.6),
            2: FlexColumnWidth(0.3),
            3: FlexColumnWidth(0.3),
            4: FlexColumnWidth(0.3),
            5: FlexColumnWidth(0.3),
            6: FlexColumnWidth(0.3),
          }
        : const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(0.3),
            3: FlexColumnWidth(0.3),
            4: FlexColumnWidth(0.3),
            5: FlexColumnWidth(0.3),
            6: FlexColumnWidth(0.3),
          },
    children: [getPhraseHeader(viewModel), ...getPhraseData(viewModel)],
  );

  static getPhraseHeader(PhrasesViewModel viewModel) =>
      TableRow(children: getPhraseCellHeader());

  static TableRow getPhraseEmpty() => TableRow(children: getPhraseCellEmpty());

  static List<TableRow> getPhraseData(PhrasesViewModel viewModel) => viewModel
      .filteredPhraseModel
      .map(
        (val) => TableRow(
          children: getPhrasesRow(val, viewModel),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey)),
          ),
        ),
      )
      .toList();

  static List<TableCell> getPhraseCellHeader() => [
    getPhrasesCell("Name"),
    getPhrasesCell("Translation"),
    getPhrasesCell("Language"),
    getPhrasesCell("Recording"),
    getPhrasesCell("Vocab"),
    getPhrasesCell("Sounds"),
    getPhrasesCell(""),
  ];

  static List<TableCell> getPhraseCellEmpty() => [
    getPhrasesCell(""),
    getPhrasesCell(""),
    getPhrasesCell(""),
    getPhrasesCell(""),
    getPhrasesCell(""),
    getPhrasesCell(""),
    getPhrasesCell(""),
  ];

  static List<TableCell> getPhrasesRow(
    PhraseModel model,
    PhrasesViewModel viewmodel,
  ) => [
    getPhrasesCell(model.phrase ?? ''),
    getPhrasesCell(model.translation ?? '', isHeader: true),
    getPhrasesCell(model.languageData?.language ?? ''),
    TableCell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () =>
                viewmodel.playPhrase(model.recording ?? '', model.id ?? 0),
            child: Icon(
              (viewmodel.player.playing &&
                      viewmodel.currentPlayingPhraseId == model.id)
                  ? Icons.pause_rounded
                  : Icons.play_arrow_outlined,
            ),
          ),

          Image.asset(ImageConstants.wave, height: 40, width: 50),
        ],
      ),
    ),
    getPhrasesCell('${model.vocab ?? 0}'),
    getPhrasesCell('${model.sounds ?? 0}'),
    TableCell(
      child: GestureDetector(
        onTap: () => viewmodel.removePhrase(model.id, model.recording),
        child: CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.close, color: Colors.white),
        ),
      ),
    ),
  ];

  static TableCell getPhrasesCell(
    String data, {
    bool isHeader = false,
    bool bgColor = false,
  }) => TableCell(
    child: Container(
      padding: EdgeInsetsDirectional.symmetric(vertical: 10, horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isHeader ? Colors.blueGrey.shade100 : Colors.transparent,
      ),
      child: Text(
        data,
        style: AppTextStyles.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: Color(0xff898A8D),
        ),
      ),
    ),
  );

  static Widget getPhraseHeading(int count) => Row(
    spacing: 20,
    children: [
      Text('Phrases($count)', style: AppTextStyles.textTheme.headlineLarge),
      GestureDetector(
        onTap: () => ctx!.go(RouteNames.addPhrase),
        child: Chip(
          label: Text(
            'Add',
            style: AppTextStyles.textTheme.headlineMedium!.copyWith(
              color: Colors.white,
            ),
          ),
          avatar: Icon(Icons.add, color: Colors.white),
          color: WidgetStatePropertyAll(Colors.green),
        ),
      ),
    ],
  );

  static Widget getPhraseFilters(
    PhrasesViewModel viewModel, {
    bool isMobile = false,
  }) => isMobile
      ? Column(
          spacing: 20,
          children: [
            SizedBox(
              width: double.infinity,
              child: CommonWidgets.buildDropdown("Languaage", [
                "All",
                ...viewModel.launguages.map((val) => val.language ?? ''),
              ], (val) => viewModel.changeLanguage(val)),
            ),
            SizedBox(
              width: double.infinity,
              child: CommonWidgets.buildDropdown("Level", [
                "All",
                ...viewModel.lvl.map((val) => val.level ?? ''),
              ], (val) => viewModel.changeLvl(val)),
            ),
          ],
        )
      : Row(
          spacing: 20,
          children: [
            Expanded(
              child: CommonWidgets.buildDropdown("Languaage", [
                "All",
                ...viewModel.launguages.map((val) => val.language ?? ''),
              ], (val) => viewModel.changeLanguage(val)),
            ),
            Expanded(
              child: CommonWidgets.buildDropdown("Level", [
                "All",
                ...viewModel.lvl.map((val) => val.level ?? ''),
              ], (val) => viewModel.changeLvl(val)),
            ),
            if (!isMobile) Expanded(child: Container()),
          ],
        );
}
