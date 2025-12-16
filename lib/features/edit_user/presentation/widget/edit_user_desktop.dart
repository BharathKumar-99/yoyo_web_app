import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/edit_user/presentation/edit_user_view_model.dart';
import 'package:yoyo_web_app/features/edit_user/presentation/widget/widget.dart';

editUserDesktop(EditUserViewModel value) {
  return Padding(
    padding: const EdgeInsets.all(29.0),
    child: Scaffold(
      appBar: CommonWidgets.homeAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: EditUserWidgets().userDetails(value)),
                if (value.user.student?.isNotEmpty ?? true)
                  Expanded(child: EditUserWidgets().userMetrics(value)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: UserResultTable(result: value.userResult),
            ),
          ],
        ),
      ),
    ),
  );
}
