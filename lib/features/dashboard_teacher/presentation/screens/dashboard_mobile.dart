import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';

import '../teacher_view_model.dart';
import '../widgets/widgets.dart';

Widget dashboardMobile(TeacherViewModel dashboardVM, Widget body) => Scaffold(
  bottomNavigationBar: TeacherWidget.bottomNavBar(dashboardVM),
  appBar: AppBar(
    flexibleSpace: Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(ImageConstants.logoBW),
          Icon(Icons.settings_outlined, color: Colors.white),
        ],
      ),
    ),
  ),
  body: body,
);
