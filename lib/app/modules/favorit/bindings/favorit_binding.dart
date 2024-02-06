import 'package:get/get.dart';
import 'package:restaurant_app2/app/modules/home/controllers/home_controller.dart';

import '../controllers/favorit_controller.dart';

class FavoritBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritController>(
      () => FavoritController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
