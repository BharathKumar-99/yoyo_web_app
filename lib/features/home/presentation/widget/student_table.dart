import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/features/home/model/student_model.dart';

import '../../../../config/router/route_names.dart';

class StudentTable extends StatefulWidget {
  final List<Student> students;
  const StudentTable({super.key, required this.students});

  @override
  State<StudentTable> createState() => _StudentTableState();
}

class _StudentTableState extends State<StudentTable> {
  String? _sortKey;
  bool _ascending = true;

  // ---------------- SORT LOGIC ----------------
  void _sortBy(String key) {
    setState(() {
      if (_sortKey == key) {
        _ascending = !_ascending; // toggle ASC ↔ DESC
      } else {
        _sortKey = key;
        _ascending = true;
      }

      widget.students.sort((a, b) {
        dynamic x;
        dynamic y;

        switch (key) {
          case "name":
            x = a.userModel?.firstName ?? "";
            y = b.userModel?.firstName ?? "";
            break;

          case "username":
            x = a.userModel?.username ?? "";
            y = b.userModel?.username ?? "";
            break;

          case "participated":
            x = a.score ?? 0;
            y = b.score ?? 0;
            break;

          case "level":
            x = a.level?.level ?? "";
            y = b.level?.level ?? "";
            break;

          case "phrases":
            x = a.userModel?.userResult?.length ?? 0;
            y = b.userModel?.userResult?.length ?? 0;
            break;

          case "vocab":
            x = a.vocab ?? 0;
            y = b.vocab ?? 0;
            break;

          case "avgScore":
            x = a.score ?? 0;
            y = b.score ?? 0;
            break;

          default:
            x = "";
            y = "";
        }

        int result = Comparable.compare(x, y);
        return _ascending ? result : -result;
      });
    });
  }

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
        onTap: () => _sortBy(key),
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
            if (_sortKey == key)
              Icon(
                _ascending ? Icons.arrow_upward : Icons.arrow_downward,
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
            (row.score ?? 0) > 0 ? "✔" : "✘",
            color: (row.score ?? 0) > 0 ? Colors.green : Colors.red,
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

  Widget rowCell(String text, {int flex = 1, Color? color}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: color ?? Colors.black87),
      ),
    );
  }
}
