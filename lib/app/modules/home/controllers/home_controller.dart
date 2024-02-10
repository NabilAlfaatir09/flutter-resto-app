import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import '../../../data/databese_helper.dart';

class HomeController extends GetxController {
  static const baseUrl = "https://restaurant-api.dicoding.dev";
  static const smallImageUrl = '/images/small/';
  static const mediumImageUrl = '/images/medium/';
  static const largeImageUrl = '/images/large/';
  var dataListRestaurant = [].obs;
  var isLoading = true.obs;
  //0 = No Internet, 1 = WIFI Connected ,2 = Mobile Data Connected.
  var connectionType = 0.obs;
  RxList<Map<String, dynamic>> favoriteRestaurants =
      <Map<String, dynamic>>[].obs;
  late StreamSubscription streamSubscription;
  final Connectivity connectivity = Connectivity();
  TextEditingController searchController = TextEditingController();

  Future<List<dynamic>> fetchRestaurantList() async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/list"),
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        var convertDataToJson = jsonDecode(response.body);
        return dataListRestaurant.value = convertDataToJson["restaurants"];
      } else {
        throw Exception("Failed to load list data Restaurant");
      }
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

  // ignore: prefer_final_fields
  DatabaseHelper _databaseHelper = DatabaseHelper();

  void addToFavorites(Map<String, dynamic> restaurant) async {
    await _databaseHelper.insertFavoriteRestaurant(restaurant);
    getFavoriteRestaurants();
  }

  void removeFromFavorites(String id) async {
    await _databaseHelper.deleteFavoriteRestaurant(id);
    getFavoriteRestaurants();
  }

  void getFavoriteRestaurants() async {
    var favorites = await _databaseHelper.getFavoriteRestaurants();
    favoriteRestaurants.value = favorites;
    isLoading.value = false;
  }

  @override
  void onInit() async {
    streamSubscription = connectivity.onConnectivityChanged.listen(updateState);
    await getConnectivityType();
    if (connectionType.value != 0) {
      await fetchRestaurantList();
      getFavoriteRestaurants();
    }

    super.onInit();
  }

  @override
  void onClose() {
    streamSubscription.cancel();
    super.onClose();
  }
}
