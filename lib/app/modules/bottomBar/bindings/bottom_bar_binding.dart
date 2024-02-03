import 'package:get/get.dart';
import 'package:restaurant_app2/app/modules/favorit/controllers/favorit_controller.dart';
import 'package:restaurant_app2/app/modules/home/controllers/home_controller.dart';
import 'package:restaurant_app2/app/modules/setting/controllers/setting_controller.dart';

import '../controllers/bottom_bar_controller.dart';

class BottomBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomBarController>(
      () => BottomBarController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<FavoritController>(
      () => FavoritController(),
    );
    Get.lazyPut<SettingController>(
      () => SettingController(),
    );
  }
}
