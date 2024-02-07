import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:restaurant_app2/app/modules/home/controllers/home_controller.dart';
import 'package:restaurant_app2/app/modules/home/views/home_view.dart';

Widget createHomeScreen() => GetMaterialApp(
      home: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) => const HomeView(),
      ),
    );
void main() {
  setUpAll(() {
    Get.testMode = true;
  });
  testWidgets('Testing semua', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(createHomeScreen());
    expect(find.byType(ListView), findsOneWidget);

    // Verify that AppBar title is displayed correctly.
    expect(find.text('Restaurant App'), findsOneWidget);

    // Verify that search TextField is displayed correctly.
    expect(find.byType(TextField), findsOneWidget);

    // Verify that CircularProgressIndicator is not shown initially.
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify that ListView is displayed.
    expect(find.byType(ListView), findsOneWidget);

    // Verify that all items in dataListRestaurant are displayed correctly.
    final HomeController controller = Get.find<HomeController>();
    final dataListRestaurant = controller.dataListRestaurant;
    for (var restaurant in dataListRestaurant) {
      expect(find.text(restaurant['name']), findsOneWidget);
      expect(find.text(restaurant['city']), findsOneWidget);
      expect(find.text(restaurant['rating'].toString()), findsOneWidget);
    }
  });
}
