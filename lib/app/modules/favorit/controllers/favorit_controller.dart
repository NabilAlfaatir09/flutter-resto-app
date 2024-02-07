// ignore_for_file: prefer_final_fields
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:get/get.dart';
import 'package:restaurant_app2/app/data/background_service.dart';
import 'package:restaurant_app2/app/data/date_time.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritController extends GetxController {
  RxBool _isScheduled = false.obs;

  bool get isScheduled => _isScheduled.value;

  @override
  void onInit() {
    super.onInit();
    loadIsScheduled();
  }

  Future<void> loadIsScheduled() async {
    final prefs = await SharedPreferences.getInstance();
    final getIsScheduled = prefs.getBool('isScheduled') ?? false;

    _isScheduled.value = getIsScheduled;
  }

  Future<bool> scheduledRestaurant(bool value) async {
    _isScheduled.value = value;
    if (_isScheduled.value) {
      Get.snackbar('', 'Restaurant Notification Activated');
      update();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      Get.snackbar('', 'Restaurant Notification Canceled');
      update();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
