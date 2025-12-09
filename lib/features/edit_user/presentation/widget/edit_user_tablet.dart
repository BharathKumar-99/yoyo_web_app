import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import 'package:yoyo_web_app/features/edit_user/presentation/edit_user_view_model.dart';

import 'widget.dart';

editUserTablet(EditUserViewModel value) {
  return Scaffold(
    appBar: CommonWidgets.homeAppBar(),
    body: SingleChildScrollView(
      child: Column(
        children: [
          EditUserWidgets().userDetails(value),
          EditUserWidgets().userMetrics(value),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: UserResultTable(result: value.userResult),
          ),
        ],
      ),
    ),
  );
}
