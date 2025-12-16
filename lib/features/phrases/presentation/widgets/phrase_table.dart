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
          headerCell("Name", "name", flex: 3),
          headerCell("Translation", "translation", flex: 2),
          headerCell("Language", "language", flex: 1),
          headerCell("Recording", "recording", flex: 1),
          headerCell("Categories", "categories", flex: 2),
          headerCell("Vocab", "vocab", flex: 1),
          headerCell("Sounds", "sounds", flex: 1),
          headerCell(" ", " ", flex: 1),
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
            flex: 3,
            child: Text(
              row.phrase ?? 'N/A',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),

          rowCell(row.translation ?? 'N/A', flex: 2),

          // PARTICIPATED
          rowCell((row.languageData?.language ?? '')),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () =>
                      provider.playPhrase(row.recording ?? '', row.id ?? 0),
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

          // LEVEL (first 2 chars)
          rowCell(row.phraseCategories?.name ?? "N/A", flex: 2),
          rowCell(row.vocab?.toString() ?? "0"),
          rowCell((row.sounds.toString())),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () => provider.removePhrase(row.id, row.recording),
              child: CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.close, color: Colors.white),
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
}
