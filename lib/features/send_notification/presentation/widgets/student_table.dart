import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/send_notification/presentation/send_notification_view_model.dart';

class NotificationStudentTable extends StatefulWidget {
  final List<UserModel> students;
  final SendNotificationViewModel provider;
  const NotificationStudentTable({
    super.key,
    required this.students,
    required this.provider,
  });

  @override
  State<NotificationStudentTable> createState() =>
      _NotificationStudentTableState();
}

class _NotificationStudentTableState extends State<NotificationStudentTable> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Divider(height: 1),

        ...widget.students.map((row) => _buildRow(row)),
      ],
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        spacing: 20,
        children: [
          GestureDetector(
            onTap: () {
              widget.provider.selectAllUser();
            },
            child: headerCell("Selected", ''),
          ),
          headerCell("Name", "name"),
          headerCell("UserName", "username"),
        ],
      ),
    );
  }

  Widget headerCell(String text, String key) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        fontSize: 13,
      ),
    );
  }

  // ---------------- ROW ----------------
  Widget _buildRow(UserModel row) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        spacing: 20,
        children: [
          Checkbox.adaptive(
            value: widget.provider.selectedUser.contains(row),
            onChanged: (v) {
              widget.provider.selectUser(row);
            },
          ),
          rowCell(row.firstName ?? 'N/A'),
          rowCell(row.username ?? 'N/A'),
        ],
      ),
    );
  }

  Widget rowCell(
    String text, {

    Color? color,
    double fontsize = 14,
    FontWeight font = FontWeight.normal,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontsize,
        color: color ?? Colors.black87,
        fontWeight: font,
      ),
    );
  }
}
