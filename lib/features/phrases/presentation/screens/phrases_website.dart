import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/phrases/presentation/widgets/phrase_widget.dart';
import '../../../common/widgets.dart';
import '../phrases_view_model.dart';
import '../widgets/phrase_table.dart';

Widget phrasesWebsite(PhrasesViewModel viewModel) => Padding(
  padding: const EdgeInsets.all(29.0),
  child: Scaffold(
    appBar: CommonWidgets.homeAppBar(),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhraseWidgets.getPhraseFilters(viewModel),
            PhraseWidgets.getPhraseHeading(
              viewModel.filteredPhraseModel.length,
              viewModel.commonViewModel?.teacher?.teacher?.isEmpty ?? true,viewModel
            ),
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
                ),
              ),
            ),
            PhraseTable(
              phrase: viewModel.filteredPhraseModel,
              provider: viewModel,
            ),
          ],
        ),
      ),
    ),
  ),
);
