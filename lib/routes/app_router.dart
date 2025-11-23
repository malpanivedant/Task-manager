import 'package:auto_route/auto_route.dart';
import 'package:bt_assessment/features/task_manager/model/task_model.dart';
import 'package:flutter/material.dart';
import '../features/splash_screen/splash_screen.dart';
import '../features/task_manager/view/home_screen/home_screen.dart';
import '../features/task_manager/view/report_screen/report_screen.dart';
import '../features/task_manager/view/add_task_screen/add_task_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: HomeRoute.page, path: '/home'),
        AutoRoute(page: AddTaskRoute.page, path: '/addtask'),
        AutoRoute(page: ReportRoute.page, path: '/report'),
      ];
}
