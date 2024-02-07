import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ListView(
            children: [
              ListTile(
                title: const Text(
                  'Restaurant Notification',
                ),
                trailing: Obx(
                  () => Switch.adaptive(
                    value: controller.isScheduled,
                    onChanged: (value) async {
                      controller.scheduledRestaurant(value);
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('isScheduled', value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
