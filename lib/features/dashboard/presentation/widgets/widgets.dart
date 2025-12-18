import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/dashboard/presentation/dashboard_view_model.dart';

class DashboardWidget {
  static List<Map> get getNavigationElements => [
    {'icon': Icons.grid_view_outlined, 'label': 'Dashboard', 'index': 0},
    {'icon': Icons.star_outline_rounded, 'label': 'Phrases', 'index': 1},
    {'icon': Icons.person_outline_rounded, 'label': 'Users', 'index': 2},
    {'icon': Icons.notifications_active, 'label': 'Notifications', 'index': 3},
  ];

  static drawer(
    DashboardViewModel dashboardViewModel, {
    bool isWeb = false,
  }) => Consumer<CommonViewModel>(
    builder: (context, commonViewModel, w) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
          ),
        ),
        child: NavigationDrawer(
          backgroundColor: Colors.transparent,
          header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Image.asset(
                  ImageConstants.logoBW,
                  height: 60,
                  width: 60,
                ),
              ),
              GestureDetector(
                onTap: () => dashboardViewModel.changeDrawer(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
          selectedIndex: dashboardViewModel.isSettingsOpen
              ? null
              : dashboardViewModel.selectedIndex,
          onDestinationSelected: dashboardViewModel.changeIndex,
          indicatorColor: Colors.white,
          tilePadding: EdgeInsetsGeometry.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          footer: GestureDetector(
            onTap: () {
              dashboardViewModel.openSettings();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
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
            ),
          ),
          children: getNavigationElements
              .map(
                (val) => NavigationDrawerDestination(
                  icon: Icon(
                    val['icon'],
                    color: val['index'] == 3 && commonViewModel.hasNotification
                        ? Colors.red
                        : dashboardViewModel.isSettingsOpen
                        ? Colors.white
                        : val['index'] == dashboardViewModel.selectedIndex
                        ? Colors.black
                        : Colors.white,
                  ),
                  label: Row(
                    spacing: 5,
                    children: [
                      Text(
                        val['label'],
                        style: AppTextStyles.textTheme.bodyMedium!.copyWith(
                          color: dashboardViewModel.isSettingsOpen
                              ? Colors.white
                              : val['index'] == dashboardViewModel.selectedIndex
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      if (val['index'] == 3 && commonViewModel.hasNotification)
                        CircleAvatar(radius: 5, backgroundColor: Colors.red),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      );
    },
  );

  static tabDrawer(
    DashboardViewModel dashboardViewModel, {
    bool web = false,
  }) => Container(
    padding: EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xff9D5DE6), Color(0xffF78C59)]),
    ),
    child: NavigationRail(
      backgroundColor: Colors.transparent,
      trailingAtBottom: true,
      leading: Column(
        children: [
          if (web)
            GestureDetector(
              onTap: () => dashboardViewModel.changeDrawer(),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
              ),
            ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 5),
            child: Image.asset(ImageConstants.logoBW, height: 60, width: 60),
          ),
        ],
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
