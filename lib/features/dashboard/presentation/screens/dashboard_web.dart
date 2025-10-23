import 'package:flutter/material.dart';
import '../dashboard_view_model.dart';

Widget dashboardWeb(DashboardViewModel dashboardVM, Widget body) =>
    Scaffold(body: SafeArea(child: body));
