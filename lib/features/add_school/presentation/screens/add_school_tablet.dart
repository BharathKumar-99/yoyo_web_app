import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_school/presentation/widgets/widgets.dart';

import '../../../common/widgets.dart';
import '../add_school_view_model.dart';

addSchoolTablet(AddSchoolViewModel vm) => Scaffold(
  appBar: CommonWidgets.homeAppBar(),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        AddSchoolWidgets.addSchoolHeader(),
        AddSchoolWidgets.schoolNameTextfiled(vm),
        AddSchoolWidgets.schoolAddressTextfiled(vm),
        AddSchoolWidgets.selectLanguageList(vm),
        AddSchoolWidgets.schoolprincipleTextfiled(vm),
        AddSchoolWidgets.schoolStudentCountTextfiled(vm),
        AddSchoolWidgets.imageSelector(vm),
        AddSchoolWidgets.addSchoolBtn(vm),
      ],
    ),
  ),
);
