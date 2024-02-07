import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_app2/app/modules/home/controllers/home_controller.dart';
import 'package:restaurant_app2/app/routes/app_pages.dart';

import '../controllers/favorit_controller.dart';

class FavoritView extends GetView<FavoritController> {
  const FavoritView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var homeC = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Favorite Restaurant'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 35,
          ),
          SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Obx(
              () => (homeC.connectionType.value == 0)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Lottie.asset(
                            "assets/nointernet.json",
                            width: 300,
                            height: 300,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "no internet.....",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    )
                  : (homeC.isLoading.value)
                      ? Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.grey,
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "loading.....",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : (homeC.favoriteRestaurants.isEmpty)
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                Lottie.asset("assets/datanotfound.json"),
                                const Center(
                                  child: Text(
                                    "Belum ada favorite, tambahkan favorite restaurant",
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var favoriteRestaurant =
                                    homeC.favoriteRestaurants[index];
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.DETAIL,
                                      arguments: {
                                        "id": favoriteRestaurant['id'],
                                        "data": favoriteRestaurant,
                                      },
                                    );
                                  },
                                  child: Card(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                            ),
                                            child: Image.network(
                                              homeC.smallImage(
                                                favoriteRestaurant["pictureId"],
                                              ),
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return const CircularProgressIndicator();
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  favoriteRestaurant["name"],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.place,
                                                      color: Colors.red,
                                                    ),
                                                    Text(
                                                      favoriteRestaurant[
                                                          "city"],
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    Text(
                                                      favoriteRestaurant[
                                                              "rating"]
                                                          .toString(),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                top: 5,
                                                right: 10,
                                              ),
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  bool isFavorite = homeC
                                                      .favoriteRestaurants
                                                      .any(
                                                    (restaurant) =>
                                                        restaurant["id"] ==
                                                        favoriteRestaurant[
                                                            "id"],
                                                  );
                                                  if (isFavorite) {
                                                    homeC.removeFromFavorites(
                                                      favoriteRestaurant["id"],
                                                    );
                                                  } else {
                                                    homeC.addToFavorites(
                                                      homeC.dataListRestaurant[
                                                          index],
                                                    );
                                                  }
                                                },
                                                child: Obx(
                                                  () => Icon(
                                                    homeC.favoriteRestaurants
                                                            .any(
                                                      (restaurant) =>
                                                          restaurant["id"] ==
                                                          favoriteRestaurant[
                                                              "id"],
                                                    )
                                                        ? Icons.favorite
                                                        : Icons
                                                            .favorite_border_outlined,
                                                    color: Colors.red,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemCount: homeC.favoriteRestaurants.length,
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
