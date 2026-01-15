import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/home/model/language_model.dart';
import 'package:yoyo_web_app/features/phrases/model/phrases_categories.dart';
import 'package:yoyo_web_app/features/phrases/presentation/phrases_view_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xff9D5DE6), width: 1.5),
    );

    return Consumer<PhrasesViewModel>(
      builder: (context, viewModel, wi) {
        return viewModel.commonViewModel.selectedSchool == null
            ? Center(child: Text('Please Select a School'))
            : viewModel.launguages.isEmpty
            ? Container()
            : Column(
                children: [
                  SizedBox(height: 30),
                  if (!viewModel.commonViewModel.isTeacher)
                    Row(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 382,
                          height: 60,
                          child: TextField(
                            controller: viewModel.addCategoryController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'type category name here',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: IntrinsicWidth(
                            child: DropdownButtonFormField<Language?>(
                              initialValue: viewModel.launguages.first,
                              items: [
                                ...viewModel.launguages.map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.language ?? ''),
                                  ),
                                ),
                              ],
                              onChanged: (val) => viewModel.selectLanguage(val),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
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
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: GestureDetector(
                            onTap: () => viewModel.addCategory(),
                            child: Container(
                              height: 50,
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
                  viewModel.phraseCategories.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('No Categories Found'),
                          ),
                        )
                      : ListView.builder(
                          itemCount: viewModel.phraseCategories.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            PhraseCategories category =
                                viewModel.phraseCategories[index];
                            return Row(
                              spacing: 20,
                              children: [
                                SizedBox(
                                  width: 62,
                                  height: 50,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Switch.adaptive(
                                      activeThumbColor: Colors.green,
                                      value: category.active ?? false,
                                      onChanged: (v) {
                                        viewModel.toggleCategoryActive(
                                          category,
                                          v,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Text(
                                  category.name ?? '',
                                  style: Theme.of(context).textTheme.titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 24,
                                      ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '(${viewModel.phrases.where((val) => val.categories == category.id).length} phrases)',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                          ),
                                    ),
                                    if ((!viewModel
                                            .commonViewModel
                                            .isTeacher) &&
                                        viewModel.phrases
                                            .where(
                                              (val) =>
                                                  val.categories == category.id,
                                            )
                                            .isEmpty)
                                      TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          'delete',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 24,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                ],
              );
      },
    );
  }
}
