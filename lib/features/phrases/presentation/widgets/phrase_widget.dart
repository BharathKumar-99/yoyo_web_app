import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/phrases/model/phrases_categories.dart';
import 'package:yoyo_web_app/features/phrases/presentation/phrases_view_model.dart';

class PhraseWidgets {
  static Widget getPhraseHeading(
    int count,
    bool showAddPhrase,
    PhrasesViewModel provider,
  ) => Row(
    spacing: 20,
    children: [
      Text(
        provider.selectedPhraseCategories != null
            ? '${provider.selectedPhraseCategories?.name}($count)'
            : 'Phrases($count)',
        style: AppTextStyles.textTheme.headlineLarge,
      ),
      if (provider.selectedPhraseCategories != null)
        Switch(
          value: provider.selectedPhraseCategories?.active ?? false,
          onChanged: (val) {
            provider.disableCategories(val);
          },
        ),
      if (showAddPhrase)
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
            SizedBox(
              width: double.infinity,
              child: buildDropdown(
                "Categories",
                viewModel.selectedPhraseCategories,
                viewModel.phraseCategories,
                viewModel,
              ),
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
            Expanded(
              child: buildDropdown(
                "Categories",
                viewModel.selectedPhraseCategories,
                viewModel.phraseCategories,
                viewModel,
              ),
            ),
          ],
        );

  static Widget buildDropdown(
    String label,
    PhraseCategories? selectedItem,
    List<PhraseCategories> items,
    PhrasesViewModel viewModel,
  ) {
    DropdownMenuItem<T?> allItem<T>() =>
        DropdownMenuItem<T>(value: null, child: Text("All"));
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phrase Categories',
            style: AppTextStyles.textTheme.headlineMedium!.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<PhraseCategories?>(
            initialValue: selectedItem,
            items: [
              allItem<PhraseCategories>(),
              ...items.map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name ?? '', overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
            onChanged: (val) => viewModel.selectPhraseCategories(val),
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
    );
  }
}
