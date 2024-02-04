import 'package:get/get.dart';
import 'package:restaurant_app2/app/modules/home/controllers/home_controller.dart';

import '../controllers/detail_controller.dart';

class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(
      () => DetailController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
