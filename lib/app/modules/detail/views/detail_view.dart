import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List detailRestaurant = controller.dataDetailRestaurant;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Restaurant'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Obx(
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
                : ListView(
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                controller.mediumImage(
                                  detailRestaurant[0]["pictureId"],
                                ),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 5, right: 10),
                                alignment: Alignment.topRight,
                                child: const Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Nama Restaurant : ${detailRestaurant[0]["name"]}",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Deskripsi : ${detailRestaurant[0]["description"]}",
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Lokasi Restaurant : ${detailRestaurant[0]["city"]}",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Alamat Restaurant : ${detailRestaurant[0]["address"]}",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Kategori Restaurant : ${detailRestaurant[0]["categories"][0]["name"]}",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Menu Makanan :",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  detailRestaurant[0]["menus"]["foods"].length,
                              itemBuilder: (context, index) {
                                final menuMakanan = detailRestaurant[0]["menus"]
                                    ["foods"][index]["name"];
                                return Card(
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      menuMakanan,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Menu Minuman :",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            padding: const EdgeInsets.only(
                              left: 10,
                            ),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  detailRestaurant[0]["menus"]["drinks"].length,
                              itemBuilder: (context, index) {
                                final menuMakanan = detailRestaurant[0]["menus"]
                                    ["drinks"][index]["name"];
                                return Card(
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      menuMakanan,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}
