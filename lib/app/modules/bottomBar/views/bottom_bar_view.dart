import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:restaurant_app2/app/modules/favorit/views/favorit_view.dart';
import 'package:restaurant_app2/app/modules/home/views/home_view.dart';
import 'package:restaurant_app2/app/modules/setting/views/setting_view.dart';

import '../controllers/bottom_bar_controller.dart';

class BottomBarView extends GetView<BottomBarController> {
  const BottomBarView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            HomeView(),
            FavoritView(),
            SettingView(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.blue,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              label: "Favorite",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Colors.grey,
              ),
              label: "Setting",
            ),
          ],
          currentIndex: controller.currentIndex.value,
          backgroundColor: Colors.black,
          selectedItemColor: (controller.currentIndex.value == 0)
              ? Colors.blue
              : (controller.currentIndex.value == 1)
                  ? Colors.red
                  : (controller.currentIndex.value == 2)
                      ? Colors.grey
                      : Colors.black,
          unselectedItemColor: Colors.white,
          selectedIconTheme: const IconThemeData(size: 35),
          selectedFontSize: 15,
          onTap: (value) => controller.changeIndex(value),
        ),
      ),
    );
  }
}
