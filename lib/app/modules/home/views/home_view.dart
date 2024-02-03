import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app2/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'package:lottie/lottie.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant App'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: const Icon(Icons.menu),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: (value) => controller.searchRestaurant(value),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Cari Restaurant....',
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      prefixIconColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Obx(
                  () => (controller.connectionType.value == 0)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                      : (controller.isLoading.value)
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
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var restaurantList =
                                    controller.dataListRestaurant[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.DETAIL,
                                        arguments: restaurantList["id"]);
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
                                              controller.smallImage(
                                                restaurantList["pictureId"],
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
                                                  restaurantList["name"],
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
                                                      restaurantList["city"],
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
                                                      restaurantList["rating"]
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
                                                  top: 5, right: 10),
                                              alignment: Alignment.topRight,
                                              child: const Icon(
                                                Icons.favorite_border_outlined,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: controller.dataListRestaurant.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
