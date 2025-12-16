import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/phrases/presentation/phrases_view_model.dart';
import '../../../common/widgets.dart';
import '../widgets/phrase_table.dart';
import '../widgets/phrase_widget.dart';

Widget phrasesMobile(PhrasesViewModel viewModel) => Padding(
  padding: const EdgeInsets.all(29.0),
  child: Scaffold(
    appBar: CommonWidgets.homeAppBarMobile(),
    body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhraseWidgets.getPhraseFilters(viewModel, isMobile: true),
            PhraseWidgets.getPhraseHeading(
              viewModel.filteredPhraseModel.length,
              viewModel.commonViewModel?.teacher?.teacher?.isEmpty ?? true,
            ),
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.sizeOf(ctx!).width * 3,
                child: PhraseTable(
                  phrase: viewModel.filteredPhraseModel,
                  provider: viewModel,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
