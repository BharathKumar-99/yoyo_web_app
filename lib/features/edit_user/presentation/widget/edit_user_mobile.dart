import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/edit_user/presentation/edit_user_view_model.dart';

import 'widget.dart';

editUserMobile(EditUserViewModel value) {
  return Padding(
    padding: const EdgeInsets.all(29.0),
    child: Scaffold(
      appBar: CommonWidgets.homeAppBarMobile(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            EditUserWidgets().userDetails(value),
            if (value.user.student?.isNotEmpty ?? true)
              EditUserWidgets().userMetrics(value),
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
