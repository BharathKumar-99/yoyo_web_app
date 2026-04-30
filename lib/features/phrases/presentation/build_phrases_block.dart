import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/constants/constants.dart';
import '../../login/presentation/widgets/loader.dart';
import '../model/phrases_categories.dart';
import 'phrases_view_model.dart';
import 'widgets/phrase_table.dart';

class PhrasesBlocksScreen extends StatelessWidget {
  const PhrasesBlocksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );
    return Consumer<PhrasesViewModel>(
      builder: (context, viewModel, child) =>
          viewModel.commonViewModel.selectedSchool == null
          ? Center(child: Text('Please Select a School'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  viewModel.isloading
                      ? YoyoWaiting()
                      : Column(
                          children: [
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
                                                  ...viewModel.phraseCategories
                                                      .map(
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
                                  flex: 2,
                                  child: Row(
                                    spacing: 12,
                                    children: [
                                      Text('No. of Phrases'),
                                      TextField(
                                        controller:
                                            viewModel.promptCountController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          constraints: BoxConstraints(
                                            maxWidth: 120,
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
                                      Text('/ 500 (Monthly limit)'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 30,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 20,
                                    children: [
                                      TextField(
                                        maxLines: 6,
                                        controller:
                                            viewModel.buildPromptController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          hintText:
                                              'E.g. Create a revision batch of speaking phrases for this class that revisits key vocabulary and structures they have already learned. Focus on recall, confidence, and accuracy, with a mix of straightforward phrases and some slightly more challenging ones. Include useful retrieval from recent and older topics, and keep the phrases natural and appropriate for their level',
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: viewModel.pickFile,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
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
                                                viewModel.fileName ??
                                                    'UPLOAD Docs:: Text book, course materials',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color:
                                                      viewModel.fileName == null
                                                      ? Colors.grey
                                                      : Colors.black,
                                                ),
                                              ),

                                              // Remove button
                                              if (viewModel.fileName != null)
                                                GestureDetector(
                                                  onTap: viewModel.removeFile,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.purple,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: const Text(
                                                      'X',
                                                      style: TextStyle(
                                                        color: Colors.purple,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: viewModel.useUploads,
                                            onChanged: (v) {
                                              viewModel.setUseUploads(v!);
                                            },
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Tick if you want YoYo to use the content on the uploads exactly as it is (e.g. list of phrases)',
                                              maxLines: 3,
                                            ),
                                          ),
                                        ],
                                      ),

                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xffF78C59),
                                              Color(0xff9D5DE6),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(200, 56),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () =>
                                              viewModel.saveconfig(context),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0,
                                            ),
                                            child: Text(
                                              'Build',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        'We already know:: Language, Class, Year, Level, Previous work and results.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                          height: 1.4,
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      _actionRow(
                                        label: 'Recall',
                                        color: const Color(0xFFFF8A3D),
                                        description:
                                            'e.g.: Bring back previously learned  vocab',
                                      ),

                                      const SizedBox(height: 14),

                                      _actionRow(
                                        label: 'Strengthen',
                                        color: const Color(0xFF7B61FF),
                                        description:
                                            'e.g. Reinforce weak spots, common errors',
                                      ),

                                      const SizedBox(height: 14),

                                      _actionRow(
                                        label: 'Vary',
                                        color: const Color(0xFFFF5C5C),
                                        description:
                                            'e.g. Keep revision practice fresh by changing the mix of topics',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  const SizedBox(height: 20),
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffF78C59), Color(0xff9D5DE6)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PhraseTable(phrase: viewModel.phrases, provider: viewModel),
                ],
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
