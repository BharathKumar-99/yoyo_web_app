import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yoyo_web_app/features/home/model/phrases_model.dart';
import 'package:yoyo_web_app/features/home/model/user_result_model.dart';
import 'package:yoyo_web_app/features/homework/model/homework_model.dart';

class PreviousHomeworkTable extends StatefulWidget {
  final List<HomeworkModel>? homework;
  final int studentLength;
  const PreviousHomeworkTable({
    super.key,
    required this.homework,
    required this.studentLength,
  });

  @override
  State<PreviousHomeworkTable> createState() => _PreviousHomeworkTableState();
}

class _PreviousHomeworkTableState extends State<PreviousHomeworkTable> {
  @override
  Widget build(BuildContext context) {
    List<HomeworkModel> homeworkList = widget.homework ?? [];
    return Column(
      spacing: 5,
      children: [_buildHeader(), ...homeworkList.map((row) => _buildRow(row))],
    );
  }

  /// ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          headerCell('Title', flex: 1),
          headerCell('Set Date', flex: 1),
          headerCell('Due Date', flex: 1),
          headerCell('No. Phrases', flex: 1),
          headerCell('Participaion', flex: 1),
          headerCell('Completed', flex: 1),
          headerCell('Avg. Score', flex: 1),
        ],
      ),
    );
  }

  Widget headerCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontSize: 20,
        ),
      ),
    );
  }

  String formatToDayMonth(String? dateString) {
    if (dateString == null) return '';

    final date = DateTime.tryParse(dateString);
    if (date == null) return '';

    return DateFormat('dd-MM-yy').format(date);
  }

  /// ---------------- ROW ----------------
  Widget _buildRow(HomeworkModel row) {
    int participation = 0;
    int completed = 0;
    int completedCount = 0;
    int avgScore = 0;

    Set<String> uniqueUserIds = {};
    List<int> scores = [];

    for (PhraseModel element in row.phrases ?? []) {
      if ((element.userResult?.length ?? 0) == widget.studentLength) {
        completedCount++;
      }

      for (UserResult res in element.userResult ?? []) {
        if (res.userId != null) {
          uniqueUserIds.add(res.userId!);

          if (res.scoreSubmitted == true) {
            scores.add(res.score ?? 0);
          }
        }
      }
    }

    participation = widget.studentLength == 0
        ? 0
        : ((uniqueUserIds.length / widget.studentLength) * 100)
              .clamp(0, 100)
              .round();

    avgScore = scores.isEmpty
        ? 0
        : (scores.reduce((a, b) => a + b) / scores.length).round();

    completed = widget.studentLength == 0
        ? 0
        : ((completedCount / widget.studentLength) * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          rowCell(row.title ?? 'N/A', flex: 1),
          rowCell(formatToDayMonth(row.setDate?.toIso8601String()), flex: 1),
          rowCell(formatToDayMonth(row.dueDate?.toIso8601String()), flex: 1),

          rowCell('${row.phrases?.length ?? 0}', flex: 1),
          rowCell('$participation%', flex: 1),
          rowCell('$completed%', flex: 1),
          rowCell('$avgScore%', flex: 1),
        ],
      ),
    );
  }

  Widget rowCell(
    String text, {
    int flex = 1,
    Color? color,
    double fontsize = 16,
    FontWeight font = FontWeight.w400,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontsize,
          color: color ?? Colors.black87,
          fontWeight: font,
        ),
      ),
    );
  }
}
