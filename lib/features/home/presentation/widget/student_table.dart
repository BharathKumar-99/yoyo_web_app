import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/home/model/student_model.dart';
import 'package:yoyo_web_app/features/home/presentation/home_view_model.dart';

import '../../../../config/router/route_names.dart';

class StudentTable extends StatefulWidget {
  final List<Student> students;
  final HomeViewModel provider;
  const StudentTable({
    super.key,
    required this.students,
    required this.provider,
  });

  @override
  State<StudentTable> createState() => _StudentTableState();
}

class _StudentTableState extends State<StudentTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Divider(height: 1),

        ...widget.students
            .where((val) => val.userModel?.isTester != true)
            .map((row) => _buildRow(row)),
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
          headerCell("UserName", "username", flex: 2),
          headerCell("Participated", "participated"),
          headerCell("Level", "level"),
          headerCell("Phrases", "phrases"),
          headerCell("Vocab", "vocab"),
          headerCell("Av. Score", "avgScore"),
        ],
      ),
    );
  }

  Widget headerCell(String text, String key, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => widget.provider.sortBy(key),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 13,
              ),
            ),

            // SORT ARROW
            if (widget.provider.sortKey == key)
              Icon(
                widget.provider.ascending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                size: 14,
              ),
          ],
        ),
      ),
    );
  }

  // ---------------- ROW ----------------
  Widget _buildRow(Student row) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // NAME
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () =>
                  NavigationHelper.go(RouteNames.editUsers, extra: row.userId),
              child: Text(
                row.userModel?.firstName ?? 'N/A',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ),

          rowCell(row.userModel?.username ?? 'N/A', flex: 2),

          // PARTICIPATED
          rowCell(
            (row.userModel?.userResult?.length ?? 0) > 0 ? "✓" : "✗",
            fontsize: 20,
            font: FontWeight.bold,
            color: (row.userModel?.userResult?.length ?? 0) > 0
                ? Colors.green
                : Colors.red,
          ),

          // LEVEL (first 2 chars)
          rowCell(
            (row.level?.level?.length ?? 0) >= 2
                ? row.level!.level!.substring(0, 2)
                : row.level?.level ?? 'N/A',
          ),

          rowCell(row.userModel?.userResult?.length.toString() ?? "0"),
          rowCell(row.vocab?.toString() ?? "0"),
          rowCell((row.score ?? 0) > 0 ? '${row.score} %' : 'N/A'),
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
        style: TextStyle(
          fontSize: fontsize,
          color: color ?? Colors.black87,
          fontWeight: font,
        ),
      ),
    );
  }
}
