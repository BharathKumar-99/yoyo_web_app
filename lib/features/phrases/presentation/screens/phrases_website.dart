import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/phrases/presentation/widgets/phrase_widget.dart';
import '../../../common/widgets.dart';
import '../phrases_view_model.dart';

Widget phrasesWebsite(PhrasesViewModel viewModel) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
  body: SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PhraseWidgets.getPhraseFilters(viewModel),
          PhraseWidgets.getPhraseHeading(viewModel.filteredPhraseModel.length),
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
              ),
            ),
          ),
          PhraseWidgets.addPhraseTable(viewModel),
        ],
      ),
    ),
  ),
);
