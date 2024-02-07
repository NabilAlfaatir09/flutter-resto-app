import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:restaurant_app2/app/modules/home/controllers/home_controller.dart';
import 'package:restaurant_app2/app/routes/app_pages.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  final homeC = Get.put(HomeController());
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {}
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    var channelId = "1";
    var channelName = "Restaurant_1";
    var channelDescription = "Recommendation restaurant for you";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true),
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    var shuffledRestaurants = List.from(homeC.dataList)..shuffle();

    if (shuffledRestaurants.isNotEmpty) {
      var randomRestaurant = shuffledRestaurants.first;
      var header = "<b> ${randomRestaurant.name} </b>";
      var body = "Recommendation Restaurant For You";

      await flutterLocalNotificationsPlugin.show(
        0,
        header,
        body,
        platformChannelSpecifics,
        payload: json.encode(randomRestaurant.toJson()),
      );
    }
  }

  void configureSelectNotificationSubject(
    BuildContext context,
  ) {
    selectNotificationSubject.stream.listen(
      (String payload) {
        var convertDataToJson = jsonDecode(payload);
        homeC.dataList.value = convertDataToJson["restaurant"];
        var data = homeC.dataList;
        var restaurant = data;
        Navigator.pushNamed(
          context,
          Routes.DETAIL,
          arguments: {
            "id": restaurant[0]['id'],
            "data": restaurant,
          },
        );
      },
    );
  }
}
