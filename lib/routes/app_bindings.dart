// lib/routes/app_bindings.dart
import 'package:get/get.dart';

import '../features/game/controller/game_controller.dart';
import '../features/home/controller/home_controller.dart';
import '../features/reports/controller/reports_controller.dart';
import '../features/subscription/controller/subscription_controller.dart';
import '../features/timeline/controller/timeline_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<ReportsController>(() => ReportsController(), fenix: true);
    Get.lazyPut<TimelineController>(() => TimelineController(), fenix: true);
    // GameController registered here (was previously in CoachView.initState)
    // fenix: true ensures it revives after being auto-disposed
    Get.lazyPut<GameController>(() => GameController(), fenix: true);
    Get.put<SubscriptionController>(SubscriptionController(), permanent: true);
  }
}
