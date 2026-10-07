import 'dart:async';
import 'package:get/get.dart';
import 'package:home_launcher_four/routes/app_routes.dart';
import 'package:home_launcher_four/services/screen_analytics_service.dart';

class LetsStartController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    ScreenAnalyticsService().logScreenVisit('lets_start_screen');
  }
}
