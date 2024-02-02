import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:restaurant_app2/app/modules/home/controllers/home_controller.dart';

class DetailController extends GetxController {
  final String baseUrl = "https://restaurant-api.dicoding.dev";
  var dataDetailRestaurant = [].obs;
  var isLoading = true.obs;
  var connectionType = 0.obs;
  late StreamSubscription streamSubscription;
  final Connectivity connectivity = Connectivity();

  Future<void> fetchDetailRestaurant(String id) async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/detail/$id"),
      );
      if (response.statusCode == 200) {
        var convertDataToJson = jsonDecode(response.body);
        dataDetailRestaurant.value = [convertDataToJson["restaurant"]];
        isLoading.value = false;
      } else {
        throw Exception("Failed to load detail data Restaurant");
      }
    } on SocketException {
      throw "Jaringan tidak ada. Cek Koneksi Kamu";
    } on FormatException {
      throw "Error";
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getConnectivityType() async {
    late ConnectivityResult connectivityResult;
    try {
      connectivityResult = await (connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return updateState(connectivityResult);
  }

  updateState(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType.value = 1;
        if (dataDetailRestaurant.isEmpty) {
          await fetchDetailRestaurant(Get.arguments);
        }
        break;
      case ConnectivityResult.mobile:
        connectionType.value = 2;
        if (dataDetailRestaurant.isEmpty) {
          await fetchDetailRestaurant(Get.arguments);
        }
        break;
      case ConnectivityResult.none:
        connectionType.value = 0;
        break;
      default:
        Get.snackbar("Error", "Failed to get connection type");
        break;
    }
  }

  mediumImage(pictureId) {
    String urlImage = '$baseUrl${HomeController.mediumImageUrl}$pictureId';
    return urlImage;
  }

  largeImage(pictureId) {
    String urlImage = '$baseUrl${HomeController.largeImageUrl}$pictureId';
    return urlImage;
  }

  @override
  void onInit() async {
    await getConnectivityType();
    streamSubscription = connectivity.onConnectivityChanged.listen(updateState);
    if (connectionType.value != 0) {
      await fetchDetailRestaurant(Get.arguments);
    }
    super.onInit();
  }

  @override
  void onClose() {
    streamSubscription.cancel();
  }
}
