import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/widgets/widgets.dart';
import '../dashboard_view_model.dart';

Widget dashboardMobile(DashboardViewModel dashboardVM, Widget body) {
  return Consumer<CommonViewModel>(
    builder: (context, commonViewModel, w) {
      return Scaffold(
        bottomNavigationBar: DashboardWidget.bottomNavBar(dashboardVM),
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
                Image.asset(IconConstants.logoLogin),
                GestureDetector(
                  onTap: () {
                    dashboardVM.openSettings();
                  },
                  child: Icon(Icons.settings_outlined, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        body: body,
      );
    },
  );
}
