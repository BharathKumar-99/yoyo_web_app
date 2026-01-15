import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/add_user/model/level.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/phrases/model/phrases_categories.dart';
import 'package:yoyo_web_app/features/phrases/presentation/phrases_view_model.dart';
import 'package:yoyo_web_app/features/phrases/presentation/widgets/phrase_table.dart';

class Phrases extends StatelessWidget {
  const Phrases({super.key});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );
    return SingleChildScrollView(
      child: Consumer<PhrasesViewModel>(
        builder: (context, viewModel, child) =>
            viewModel.commonViewModel.selectedSchool == null
            ? Center(child: Text('Please Select a School'))
            : Column(
                children: [
                  SizedBox(height: 30),
                  if (!viewModel.commonViewModel.isTeacher)
                    Row(
                      spacing: 30,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 20,
                            children: [
                              Row(
                                spacing: 20,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 60,
                                      child: TextField(
                                        controller: viewModel.addPhrase,
                                        style: TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          hintText: 'enter phrase here',
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 30,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Text('Category: '),
                                        viewModel.phraseCategories.isEmpty
                                            ? Text(
                                                'Please Add Categories',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.titleSmall,
                                              )
                                            : Expanded(
                                                child: DropdownButtonFormField<PhraseCategories?>(
                                                  initialValue: viewModel
                                                      .selectedPhraseCategories,
                                                  isExpanded: true,
                                                  items: [
                                                    ...viewModel.phraseCategories.map(
                                                      (e) =>
                                                          DropdownMenuItem<
                                                            PhraseCategories
                                                          >(
                                                            value: e,
                                                            child: Text(
                                                              e.name ?? '',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                    ),
                                                  ],
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 0,
                                                        ),
                                                    border: border,
                                                    enabledBorder: border,
                                                    focusedBorder: border
                                                        .copyWith(
                                                          borderSide:
                                                              const BorderSide(
                                                                color: Color(
                                                                  0xff9D5DE6,
                                                                ),
                                                                width: 2,
                                                              ),
                                                        ),
                                                  ),
                                                  onChanged: (val) {
                                                    viewModel
                                                        .selectPhraseCategories(
                                                          val,
                                                        );
                                                  },
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),

                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text('Language: '),
                                        viewModel.launguages.isEmpty
                                            ? Text(
                                                'Please Add Languages',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.titleSmall,
                                              )
                                            : Expanded(
                                                child: DropdownButtonFormField<Language?>(
                                                  initialValue: viewModel
                                                      .selectedLanguage,
                                                  isExpanded: true,
                                                  items: [
                                                    ...viewModel.launguages.map(
                                                      (e) =>
                                                          DropdownMenuItem<
                                                            Language
                                                          >(
                                                            value: e,
                                                            child: Text(
                                                              e.language ?? '',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                    ),
                                                  ],
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 0,
                                                        ),
                                                    border: border,
                                                    enabledBorder: border,
                                                    focusedBorder: border
                                                        .copyWith(
                                                          borderSide:
                                                              const BorderSide(
                                                                color: Color(
                                                                  0xff9D5DE6,
                                                                ),
                                                                width: 2,
                                                              ),
                                                        ),
                                                  ),
                                                  onChanged: (val) {
                                                    viewModel.selectLanguage(
                                                      val,
                                                    );
                                                  },
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text('Level: '),
                                        Expanded(
                                          child: DropdownButtonFormField<Level?>(
                                            initialValue:
                                                viewModel.selectedLevel,
                                            isExpanded: true,
                                            items: [
                                              ...viewModel.lvl.map(
                                                (e) => DropdownMenuItem<Level>(
                                                  value: e,
                                                  child: Text(
                                                    e.level ?? '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                            ],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 0,
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
                                            onChanged: (val) {
                                              viewModel.changeLvl(val);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 20,
                                children: [
                                  Text('Type:'),
                                  SizedBox(
                                    height: 60,
                                    width: 200,
                                    child: DropdownButtonFormField<String?>(
                                      initialValue:
                                          viewModel.selectedPhraseType,
                                      isExpanded: true,
                                      items: [
                                        ...viewModel.phraseTypes.map(
                                          (e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(
                                              e,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 0,
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
                                      onChanged: (val) {
                                        viewModel.selectType(val);
                                      },
                                    ),
                                  ),
                                  Text('Question : '),
                                  Expanded(
                                    child: SizedBox(
                                      height: 60,
                                      child: TextField(
                                        controller:
                                            viewModel.addQuestionsPhrase,
                                        style: TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          hintText:
                                              'enter Question here if there is one',
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: GestureDetector(
                            onTap: () => viewModel.addPhrases(),
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xffF78C59),
                                    Color(0xff9D5DE6),
                                    Color(0xff9D5DE6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  'Add',
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 30),
                  PhraseTable(phrase: viewModel.phrases, provider: viewModel),
                ],
              ),
      ),
    );
  }
}
