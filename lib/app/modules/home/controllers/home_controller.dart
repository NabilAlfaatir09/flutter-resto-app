import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;

class HomeController extends GetxController {
  static const baseUrl = "https://restaurant-api.dicoding.dev";
  static const smallImageUrl = '/images/small/';
  static const mediumImageUrl = '/images/medium/';
  static const largeImageUrl = '/images/large/';
  var dataListRestaurant = [].obs;
  var isLoading = true.obs;
  //0 = No Internet, 1 = WIFI Connected ,2 = Mobile Data Connected.
  var connectionType = 0.obs;
  late StreamSubscription streamSubscription;
  final Connectivity connectivity = Connectivity();
  TextEditingController searchController = TextEditingController();

  Future<void> fetchRestaurantList() async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/list"),
      );
      if (response.statusCode == 200) {
        var convertDataToJson = jsonDecode(response.body);
        dataListRestaurant.value = convertDataToJson["restaurants"];
        isLoading.value = false;
      } else {
        throw Exception("Failed to load list data Restaurant");
      }
    } on SocketException {
      throw "Jaringan tidak ada. Cek Koneksi Kamu";
    } on FormatException {
      throw "Error";
    } catch (_) {
      rethrow;
    }
  }

  Future<void> searchRestaurant(String search) async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/search?q=$search"),
      );
      if (response.statusCode == 200) {
        var convertDataToJson = jsonDecode(response.body);
        dataListRestaurant.value = convertDataToJson["restaurants"];
      } else {
        throw Exception("Failed to search list data Restaurant");
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
        if (dataListRestaurant.isEmpty) {
          await fetchRestaurantList();
        }
        break;
      case ConnectivityResult.mobile:
        connectionType.value = 2;
        if (dataListRestaurant.isEmpty) {
          await fetchRestaurantList();
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

  smallImage(pictureId) {
    String urlImage = '$baseUrl$smallImageUrl$pictureId';
    return urlImage;
  }

  @override
  void onInit() async {
    await getConnectivityType();
    streamSubscription = connectivity.onConnectivityChanged.listen(updateState);
    if (connectionType.value != 0) {
      await fetchRestaurantList();
    }
    super.onInit();
  }

  @override
  void onClose() {
    streamSubscription.cancel();
  }
}
