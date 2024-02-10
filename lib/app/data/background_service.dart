import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:restaurant_app2/app/data/notification_helper.dart';
import 'package:restaurant_app2/app/modules/home/controllers/home_controller.dart';

// ignore: unnecessary_late
late Rx<ReceivePort> port = ReceivePort().obs;

class BackgroundService extends GetxService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static final Rx<SendPort?> _uiSendPort = Rx<SendPort?>(null);

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.value.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    final NotificationHelper notificationHelper = NotificationHelper();
    try {
      var result = await HomeController().fetchRestaurantList();
      await notificationHelper.showNotification(
          FlutterLocalNotificationsPlugin(), result);

      _uiSendPort.value ??= IsolateNameServer.lookupPortByName(_isolateName);
      _uiSendPort.value?.send(null);
    } catch (e) {
      debugPrint('Error in background service: $e');
    }
  }

  Future<void> someTask() async {
    debugPrint('Updated data from the background isolate');
  }
}
