// lib/routes/app_bindings.dart
import 'package:get/get.dart';

import '../features/home/controller/home_controller.dart';
import '../features/reports/controller/reports_controller.dart';
import '../features/subscription/controller/subscription_controller.dart';
import '../features/timeline/controller/timeline_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<ReportsController>(() => ReportsController(), fenix: true);
    // TimelineController registered here so it's available when the
    // Expenses tab first renders inside PageView
    Get.lazyPut<TimelineController>(() => TimelineController(), fenix: true);
    Get.put<SubscriptionController>(SubscriptionController(), permanent: true);
  }
}
