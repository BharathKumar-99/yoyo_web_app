import 'package:flutter/material.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/dashboard_view_model.dart';

class DashboardWidget {
  static List<Map> get getNavigationElements => [
    {'icon': Icons.grid_view_outlined, 'label': 'Dashboard', 'index': 0},
    {'icon': Icons.star_outline_rounded, 'label': 'Phrases', 'index': 1},
    {'icon': Icons.person_outline_rounded, 'label': 'Users', 'index': 2},
  ];

  static drawer(DashboardViewModel dashboardViewModel) => Container(
    padding: EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xff9D5DE6), Color(0xffF78C59)]),
    ),
    child: NavigationDrawer(
      backgroundColor: Colors.transparent,
      header: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 5),
          child: Image.asset(ImageConstants.logoBW, height: 60, width: 60),
        ),
      ),
      selectedIndex: dashboardViewModel.selectedIndex,
      onDestinationSelected: dashboardViewModel.changeIndex,
      indicatorColor: Colors.white,
      tilePadding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 5),
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.settings_outlined, color: Colors.white),
          Text(
            'Settings',
            style: AppTextStyles.textTheme.bodyMedium!.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
      children: getNavigationElements
          .map(
            (val) => NavigationDrawerDestination(
              icon: Icon(
                val['icon'],
                color: val['index'] == dashboardViewModel.selectedIndex
                    ? Colors.black
                    : Colors.white,
              ),
              label: Text(
                val['label'],
                style: AppTextStyles.textTheme.bodyMedium!.copyWith(
                  color: val['index'] == dashboardViewModel.selectedIndex
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          )
          .toList(),
    ),
  );

  static tabDrawer(DashboardViewModel dashboardViewModel) => Container(
    padding: EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xff9D5DE6), Color(0xffF78C59)]),
    ),
    child: NavigationRail(
      backgroundColor: Colors.transparent,
      trailingAtBottom: true,
      leading: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 5),
          child: Image.asset(ImageConstants.logoBW, height: 60, width: 60),
        ),
      ),
      selectedIndex: dashboardViewModel.selectedIndex,
      onDestinationSelected: dashboardViewModel.changeIndex,
      indicatorColor: Colors.white,
      trailing: Icon(Icons.settings_outlined, color: Colors.white),
      destinations: getNavigationElements
          .map(
            (val) => NavigationRailDestination(
              icon: Icon(
                val['icon'],
                color: val['index'] == dashboardViewModel.selectedIndex
                    ? Colors.black
                    : Colors.white,
              ),
              label: Text(
                val['label'],
                style: AppTextStyles.textTheme.bodyMedium!.copyWith(
                  color: val['index'] == dashboardViewModel.selectedIndex
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          )
          .toList(),
    ),
  );

  static bottomNavBar(DashboardViewModel dashboardViewModel) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xff9D5DE6), Color(0xffF78C59)]),
    ),
    child: NavigationBar(
      onDestinationSelected: dashboardViewModel.changeIndex,

      selectedIndex: dashboardViewModel.selectedIndex,
      backgroundColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: getNavigationElements
          .map(
            (val) => NavigationDestination(
              icon: Icon(
                val['icon'],
                color: val['index'] == dashboardViewModel.selectedIndex
                    ? Colors.black
                    : Colors.white,
              ),
              label: val['label'],
            ),
          )
          .toList(),
    ),
  );
}
