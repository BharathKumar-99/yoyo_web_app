import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/model/phrases_model.dart';
import 'package:yoyo_web_app/features/phrases/presentation/phrases_view_model.dart';
import '../../../../config/constants/constants.dart';

class PhraseTable extends StatelessWidget {
  final List<PhraseModel> phrase;
  final PhrasesViewModel provider;
  const PhraseTable({super.key, required this.phrase, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Divider(height: 1),

        ...phrase.map((row) => _buildRow(row)),
      ],
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          headerCell("Name", "name", flex: 2),
          headerCell("Translation", "translation", flex: 2),
          headerCell("Language", "language", flex: 1),
          headerCell("Recording", "recording", flex: 1),
          headerCell("Categories", "categories", flex: 2),
          headerCell("Vocab", "vocab", flex: 1),
          headerCell("Learned", "learned", flex: 1),
          headerCell("Sounds", "sounds", flex: 1),
          if (!provider.commonViewModel.isTeacher)
            headerCell("Active", "active", flex: 2),
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
  Widget _buildRow(PhraseModel row) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // NAME
          Expanded(
            flex: 2,
            child: Text(
              textAlign: TextAlign.left,
              row.phrase ?? 'N/A',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          row.translation == null
              ? rowLoader(flex: 2)
              : rowCell(row.translation ?? 'N/A', flex: 2),
          rowCell((row.languageData?.language ?? '')),
          row.recording == null
              ? rowLoader()
              : Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => provider.playPhrase(
                          row.recording ?? '',
                          row.id ?? 0,
                        ),
                        child: Icon(
                          (provider.player.playing &&
                                  provider.currentPlayingPhraseId == row.id)
                              ? Icons.pause_rounded
                              : Icons.play_arrow_outlined,
                        ),
                      ),

                      Image.asset(ImageConstants.wave, height: 40, width: 50),
                    ],
                  ),
                ),
          rowCell(row.phraseCategories?.name ?? "N/A", flex: 2),
          row.vocab == null
              ? rowLoader()
              : rowCell(row.vocab?.toString() ?? "0"),
          rowCell(
            row.userResult
                    ?.where((v) => v.type == 'Learned')
                    .length
                    .toString() ??
                "0",
          ),
          (row.sounds == null || row.sounds == 0)
              ? rowLoader()
              : rowCell((row.sounds.toString())),
          if (!provider.commonViewModel.isTeacher)
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topLeft,
                child: Switch.adaptive(
                  value: row.phraseDisabledSchools
                      .where(
                        (e) =>
                            e.remoteConfig?.school?.id ==
                            provider.commonViewModel.teacher?.schools?.id,
                      )
                      .isEmpty,
                  onChanged: (v) {
                    provider.disablePhrase(row.id ?? 0, [
                      provider.commonViewModel.teacher?.schools?.id ?? 0,
                    ]);
                  },
                ),
              ),
            ),
        ],
      ),
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
    );
  }

  Widget rowLoader({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 20,
          width: 20,
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}
