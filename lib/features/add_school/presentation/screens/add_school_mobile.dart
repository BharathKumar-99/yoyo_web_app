import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_school/presentation/add_school_view_model.dart';

import '../../../common/widgets.dart';
import '../widgets/widgets.dart';

addSchoolMobile(AddSchoolViewModel vm) => Scaffold(
  appBar: CommonWidgets.homeAppBarMobile(),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        AddSchoolWidgets.addSchoolHeader(),
        AddSchoolWidgets.schoolNameTextfiled(vm),
        AddSchoolWidgets.schoolTelephoneTextfiled(vm),
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
