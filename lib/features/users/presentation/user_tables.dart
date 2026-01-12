import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/router/route_names.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import '../../home/model/user_model.dart';

class UserTable extends StatelessWidget {
  final List<UserModel> teacher;

  const UserTable({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Divider(height: 1),

        ...teacher.map((row) => _buildRow(row)),
      ],
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          headerCell("Avatar", "avatar", flex: 1),
          headerCell("Name", "name", flex: 1),
          headerCell("School", "school", flex: 1),
          headerCell("Job Title", "job", flex: 1),
          headerCell("User Name", "username", flex: 1),
          headerCell(" ", " ", flex: 1),
        ],
      ),
    );
  }

  String extractCaps(String text) {
    final matches = RegExp(r'(^[A-Za-z])|-(\s*[A-Za-z])').allMatches(text);

    // Extract the actual letters, remove '-', trim spaces
    final letters = matches.map((m) {
      return (m.group(1) ?? m.group(2))!
          .replaceAll('-', '')
          .trim()
          .toUpperCase();
    }).join();

    return letters;
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
  Widget _buildRow(UserModel row) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // NAME
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      extractCaps(row.username ?? ''),
                      style: AppTextStyles.textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(),
              ],
            ),
          ),

          rowCell(row.firstName ?? 'N/A', flex: 1),

          rowCell((row.schools?.schoolName ?? '')),
          rowCell((row.teacher?.first.jobTitle ?? '')),
          rowCell((row.username ?? ''), flex: 1),

          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () =>
                  NavigationHelper.go(RouteNames.editUsers, extra: row.userId),
              child: Chip(label: Text('View/Edit')),
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
