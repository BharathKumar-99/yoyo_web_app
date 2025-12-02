import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/add_school/presentation/widgets/widgets.dart';
import 'package:yoyo_web_app/features/common/widgets.dart';
import '../add_school_view_model.dart';

addSchoolWebsite(AddSchoolViewModel vm) => Padding(
  padding: const EdgeInsets.all(26.0),
  child: Scaffold(
    appBar: CommonWidgets.homeAppBar(),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          AddSchoolWidgets.addSchoolHeader(),
          Row(
            spacing: 20,
            children: [
              Expanded(
                child: Column(
                  spacing: 20,
                  children: [
                    AddSchoolWidgets.schoolNameTextfiled(vm),
                    AddSchoolWidgets.schoolTelephoneTextfiled(vm),
                  ],
                ),
              ),
              Expanded(child: AddSchoolWidgets.schoolAddressTextfiled(vm)),
            ],
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(child: AddSchoolWidgets.selectLanguageList(vm)),
              Expanded(
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AddSchoolWidgets.schoolprincipleTextfiled(vm),
                    AddSchoolWidgets.schoolStudentCountTextfiled(vm),
                    AddSchoolWidgets.imageSelector(vm),
                    AddSchoolWidgets.addSchoolBtn(vm),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ),
);
