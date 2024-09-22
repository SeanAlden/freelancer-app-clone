// ignore_for_file: avoid_print

// impo
import 'dart:convert';

import 'package:clone_freelancer_mobile/views/User/category_page.dart';
import 'package:clone_freelancer_mobile/views/User/profile_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:clone_freelancer_mobile/controllers/service_controller.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/models/package.dart';
import 'package:clone_freelancer_mobile/views/User/details_page.dart';
import 'package:clone_freelancer_mobile/views/User/display_search_page.dart';
import 'package:clone_freelancer_mobile/views/User/navigation_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_formatter/money_formatter.dart';

import 'package:http/http.dart' as http;
import 'package:clone_freelancer_mobile/models/news.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = GetStorage();
  final ServiceController serviceController = Get.put(ServiceController());
  final SellerController sellerController = Get.put(SellerController());
  NavigationController navigationController = Get.find<NavigationController>();

  late Future futurePopularServices;
  late Future futureRecommendedServices;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    print('Fetching data');
    setState(() {
      futurePopularServices = serviceController.getPopularService();
      if (box.read('token') != null) {
        futureRecommendedServices = serviceController.getRecommendation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.purple,
        title: const Center(
          // mengatur title untuk Home
          child: Text(
            "Home",
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
            padding:
                const EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 16),
            child: RefreshIndicator(
              onRefresh: fetchData,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          box.read('pic') != null
                              ? GestureDetector(
                                  onTap: () {
                                    // Gambar profil yang berisi ketika di klik akan navigasi ke halaman ProfilePage
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage()),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        box.read('pic'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )

                              // SizedBox(
                              //     width: 50,
                              //     height: 50,
                              //     child: ClipRRect(
                              //       borderRadius: BorderRadius.circular(100),
                              //       child: Image.network(
                              //         box.read('pic'),
                              //         fit: BoxFit.cover,
                              //       ),
                              //     ),
                              //   )

                              // : SizedBox(
                              //     width: 50,
                              //     height: 50,
                              //     child: ClipRRect(
                              //       borderRadius: BorderRadius.circular(100),
                              //       child: Image.asset(
                              //         'assets/images/blank_image.png',
                              //         fit: BoxFit.cover,
                              //       ),
                              //     ),
                              //   ),
                              : SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigasi ke ProfilePage ketika gambar kosong/blank di klik
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(
                                        'assets/images/blank_image.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            width: 16,
                          ),
                          // Pada bagian ini, ketika setiap elemen di klik (seperti gambar profile, dan nama user) maka akan mengarahkan user ke profile page
                          Column(
                            // bagian column untuk mengatur bagian atas
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()),
                                  );
                                },
                                child: Text(
                                  "Hello,",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ),
                              box.read('token') != null
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage()),
                                        );
                                      },
                                      child: Text(
                                        box.read('user')['name'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage()),
                                        );
                                      },
                                      child: Text(
                                        "Guest",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                            ],
                          ),

                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       "Hello,",
                          //       style: Theme.of(context)
                          //           .textTheme
                          //           .titleSmall
                          //           ?.copyWith(color: Colors.grey[600]),
                          //     ),
                          //     box.read('token') != null
                          //         ? Text(
                          //             box.read('user')['name'],
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .titleLarge
                          //                 ?.copyWith(
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //           )
                          //         : Text(
                          //             "Guest",
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .titleLarge
                          //                 ?.copyWith(
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //           ),
                          //   ],
                          // ),
                        ],
                      ),
                      Row(
                        children: [
                          // Melakukan comment pada bagian source code ini untuk menghilangkan tombol search pada
                          // bagian atas yang membingungkan

                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.notifications_outlined),
                          // ),
                          // IconButton(
                          //   onPressed: () {
                          //     navigationController.selectedIndex.value = 2;
                          //   },
                          //   icon: const Icon(Icons.search_outlined),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // bagian title untuk kolom kategori layanan
                      Text(
                        "Service Categories",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            // TextSpan(
                            //   text: "See All",
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .titleSmall
                            //       ?.copyWith(
                            //         color: const Color(0xff6571ff),
                            //       ),
                            //   recognizer: TapGestureRecognizer()
                            //     ..onTap = () {
                            //       setState(() {
                            //         navigationController.selectedIndex.value =
                            //             2;
                            //       });
                            //     },
                            // ),

                            // Merubah implementasi ketika tombol "See All" ditekan, maka akan melakukan navigasi ke halaman category page
                            TextSpan(
                              text: "See All",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: const Color(0xff6571ff),
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // ketika ditekan, akan menuju ke halaman "CategoryPage"
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryPage(), // Halaman tujuan
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 160,
                    child: FutureBuilder(
                      future: futurePopularServices,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final data = snapshot.data;
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                // menuju ke halaman kategori tujuan berdasarkan id dan nama yang di klik
                                onTap: () {
                                  Get.to(
                                    () => DisplaySearchPage(
                                      subCategoryId: data[index]
                                          ['subcategory_id'],
                                      subCategoryText: data[index]
                                          ['subcategory_name'],
                                      searchText: null,
                                    ),
                                  )?.then((_) {
                                    fetchData();
                                  });
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: SizedBox(
                                      width: 150,
                                      child: Column(
                                        // menampilkan tampilan service categories
                                        children: [
                                          // gambar kategori yang dipakai
                                          Image.network(
                                            "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
                                            fit: BoxFit.cover,
                                          ),
                                          Expanded(
                                            child: Container(
                                              // nama kategori
                                              padding: const EdgeInsets.all(4),
                                              alignment: Alignment.center,
                                              child: Text(
                                                data[index]['subcategory_name'],
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          // menampilkan progress indicator untuk implementasi loading
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    // space
                    height: 32,
                  ),
                  box.read('token') != null
                      ? FutureBuilder(
                          future: futureRecommendedServices,
                          builder: (context, snapshot) {
                            // jika error, tampilkan pesan error
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                              // jika ada data, maka tampilkan
                            } else if (snapshot.hasData) {
                              final data = snapshot.data;
                              return data.length > 0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // title untuk kolom "Services"
                                        Text(
                                          "Services",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        SizedBox(
                                          height: 300,
                                          // menampilkan tampilan scroll untuk services
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: data.length,
                                            itemBuilder: (context, index) {
                                              var price = data[index]
                                                      ['lowestPrice']
                                                  .toString();
                                              var linkServicePic = data[index]
                                                  ['servicePic']['picasset'];
                                              linkServicePic = url.replaceFirst(
                                                      '/api/', '') +
                                                  linkServicePic;
                                              var serviceId =
                                                  data[index]['service_id'];
                                              String linkAvatar =
                                                  data[index]['picasset'];
                                              linkAvatar = url.replaceFirst(
                                                      '/api/', '') +
                                                  linkAvatar;
                                              MoneyFormatter fmf =
                                                  MoneyFormatter(
                                                          amount: double.parse(
                                                              price))
                                                      .copyWith(symbol: 'IDR');
                                              return GestureDetector(
                                                onTap: () async {
                                                  var list =
                                                      await serviceController
                                                          .getServicePackage(
                                                              serviceId);
                                                  List<Package> itemPackage =
                                                      [];
                                                  for (var item in list) {
                                                    itemPackage.add(
                                                      Package(
                                                        id: item['package_id'],
                                                        title: item['title'],
                                                        desc:
                                                            item['description'],
                                                        price: int.parse(
                                                            item['price']),
                                                        deliveryDays: item[
                                                            'delivery_days'],
                                                        revision:
                                                            item['revision'],
                                                      ),
                                                    );
                                                  }
                                                  // menuju ke halaman detail, dan mengisi elemen pada halaman detail
                                                  Get.to(
                                                    () => DetailsPage(
                                                      type: data[index]['type'],
                                                      location: data[index]
                                                          ['location'],
                                                      serviceId: serviceId,
                                                      title: data[index]
                                                          ['title'],
                                                      desc: data[index]
                                                          ['description'],
                                                      user: UserData(
                                                        userId: data[index]
                                                            ['user_id'],
                                                        piclink: linkAvatar,
                                                        name: data[index]
                                                            ['name'],
                                                      ),
                                                      packages: itemPackage,
                                                      rating: double.parse(
                                                          data[index]
                                                              ['rating']),
                                                      count: data[index]
                                                          ['count'],
                                                      fav: data[index][
                                                                  'serviceFav'] ==
                                                              true
                                                          ? true
                                                          : false,
                                                      email: data[index]
                                                          ['email'],
                                                      subCategory: data[index]
                                                          ['subcategory_name'],
                                                      customOrder: data[index][
                                                                  'custom_order'] ==
                                                              'false'
                                                          ? false
                                                          : true,
                                                      isSeller: data[index]
                                                          ['isSeller'],
                                                    ),
                                                  )?.then((_) {
                                                    fetchData();
                                                  });
                                                },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    // Bagian untuk mengatur border pada gambar services
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                  ),
                                                  child: ClipRRect(
                                                    // Bagian untuk mengatur bentuk gambar services
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    child: SizedBox(
                                                      width: 260,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Mengatur tampilan pada services
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    // tampilan gambar services
                                                                    Container(
                                                                  color: Colors
                                                                          .grey[
                                                                      300],
                                                                  child: Image
                                                                      .network(
                                                                    linkServicePic,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    height: 150,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Expanded(
                                                              // bagian bawah gambar services
                                                              child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 8,
                                                                        right:
                                                                            8),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        // berisi akun freelancer, judul jasa/layanan, dan rating serta harga service
                                                                        Row(
                                                                          children: [
                                                                            // gambar dan nama profil
                                                                            SizedBox(
                                                                              width: 30,
                                                                              height: 30,
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(100),
                                                                                child: Image.network(
                                                                                  linkAvatar,
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 8,
                                                                            ),
                                                                            Text(
                                                                              data[index]['name'],
                                                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        // gambar hati/love untuk menambahkan service favorit
                                                                        data[index]['serviceFav'] ==
                                                                                true
                                                                            ? IconButton(
                                                                                // kalau telah ditandai favorit
                                                                                color: Colors.red,
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    serviceController.deleteSavedService(serviceId);
                                                                                    data[index]['serviceFav'] = false;
                                                                                  });
                                                                                },
                                                                                icon: const Icon(Icons.favorite),
                                                                              )
                                                                            : IconButton(
                                                                                // kalau belum ditandai favorit
                                                                                color: Colors.grey[500],
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    serviceController.saveService(serviceId);
                                                                                    data[index]['serviceFav'] = true;
                                                                                  });
                                                                                },
                                                                                icon: const Icon(Icons.favorite_outline),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 0,
                                                                    ),
                                                                    Text(
                                                                        // menampilkan judul layanan/service
                                                                        data[index]
                                                                            [
                                                                            'title'],
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleSmall),
                                                                    const SizedBox(
                                                                      height:
                                                                          16,
                                                                    ),
                                                                    Row(
                                                                      // Baris untuk menampilkan rating berupa star dan total rate
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            const Icon(
                                                                              // icon star
                                                                              Icons.star,
                                                                              color: Colors.orange,
                                                                              size: 15,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 4,
                                                                            ),
                                                                            // jumlah rating
                                                                            data[index]['rating'] == null
                                                                                ? Text(
                                                                                    // kalau tidak punya rating
                                                                                    "0",
                                                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                                          color: Colors.orange,
                                                                                        ),
                                                                                  )
                                                                                : Text(
                                                                                    // kalau ada rating
                                                                                    data[index]['rating'].toString(),
                                                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                                                          color: Colors.orange,
                                                                                        ),
                                                                                  ),
                                                                            const SizedBox(
                                                                              width: 4,
                                                                            ),
                                                                            Text(
                                                                              // index barang
                                                                              "(${data[index]['count'].toString()})",
                                                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                                    color: Colors.grey[600],
                                                                                  ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        RichText(
                                                                          // menampilkan harga services
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          text:
                                                                              TextSpan(
                                                                            children: [
                                                                              TextSpan(
                                                                                text: "From",
                                                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                                                      color: Colors.grey[600],
                                                                                    ),
                                                                              ),
                                                                              TextSpan(
                                                                                text: " ${fmf.output.symbolOnLeft}",
                                                                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 32,
                                        ),
                                        // Menambahkan kolom dengan title "News" untuk implementasi tampilan berita mengenai freelancer
                                        // Text(
                                        //   "News",
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .headlineSmall,
                                        // ),
                                        NewsWidget()
                                      ],
                                    )
                                  : Container();
                            } else {
                              // animasi loading
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        )
                      : Container(),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            )

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Recently viewed",
            //       style: Theme.of(context).textTheme.headlineSmall,
            //     ),
            //     RichText(
            //       text: TextSpan(
            //         children: [
            //           TextSpan(
            //             text: "See All",
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .titleSmall
            //                 ?.copyWith(
            //                   color: const Color(0xff6571ff),
            //                 ),
            //             recognizer: TapGestureRecognizer()..onTap = () {},
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            // SizedBox(
            //   height: 320,
            //   child: FutureBuilder(
            //     future: getRecommendation(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasError) {
            //         return Text('Error: ${snapshot.error}');
            //       } else if (snapshot.hasData) {
            //         final data = snapshot.data;
            //         return ListView.builder(
            //           shrinkWrap: true,
            //           scrollDirection: Axis.horizontal,
            //           itemCount: data.length,
            //           itemBuilder: (context, index) {
            //             return Card(
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(5.0),
            //               ),
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.circular(5.0),
            //                 child: SizedBox(
            //                   width: 250,
            //                   child: Column(
            //                     crossAxisAlignment:
            //                         CrossAxisAlignment.start,
            //                     children: [
            //                       Image.network(
            //                         "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
            //                         fit: BoxFit.cover,
            //                       ),
            //                       Expanded(
            //                           child: Column(
            //                         mainAxisAlignment:
            //                             MainAxisAlignment.center,
            //                         children: [
            //                           Container(
            //                             padding: const EdgeInsets.all(8),
            //                             child: Column(
            //                               children: [
            //                                 Row(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment
            //                                           .spaceBetween,
            //                                   children: [
            //                                     Row(
            //                                       children: [
            //                                         SizedBox(
            //                                           width: 30,
            //                                           height: 30,
            //                                           child: ClipRRect(
            //                                             borderRadius:
            //                                                 BorderRadius
            //                                                     .circular(
            //                                                         100),
            //                                             child:
            //                                                 Image.network(
            //                                               "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
            //                                               fit: BoxFit.cover,
            //                                             ),
            //                                           ),
            //                                         ),
            //                                         const SizedBox(
            //                                           width: 8,
            //                                         ),
            //                                         Text(
            //                                           "Store Name",
            //                                           style:
            //                                               Theme.of(context)
            //                                                   .textTheme
            //                                                   .labelLarge
            //                                                   ?.copyWith(
            //                                                     fontWeight:
            //                                                         FontWeight
            //                                                             .bold,
            //                                                   ),
            //                                         ),
            //                                       ],
            //                                     ),
            //                                     IconButton(
            //                                       color: Colors.grey[500],
            //                                       onPressed: () {},
            //                                       icon: const Icon(Icons
            //                                           .favorite_outline),
            //                                     ),
            //                                   ],
            //                                 ),
            //                                 const SizedBox(
            //                                   height: 0,
            //                                 ),
            //                                 Text(lorem,
            //                                     maxLines: 2,
            //                                     overflow:
            //                                         TextOverflow.ellipsis,
            //                                     style: Theme.of(context)
            //                                         .textTheme
            //                                         .titleSmall),
            //                                 const SizedBox(
            //                                   height: 16,
            //                                 ),
            //                                 Row(
            //                                   mainAxisAlignment:
            //                                       MainAxisAlignment
            //                                           .spaceBetween,
            //                                   children: [
            //                                     Row(
            //                                       children: [
            //                                         const Icon(
            //                                           Icons.star,
            //                                           color: Colors.orange,
            //                                           size: 15,
            //                                         ),
            //                                         const SizedBox(
            //                                           width: 4,
            //                                         ),
            //                                         Text(
            //                                           "4.9",
            //                                           style:
            //                                               Theme.of(context)
            //                                                   .textTheme
            //                                                   .bodyMedium
            //                                                   ?.copyWith(
            //                                                     color: Colors
            //                                                         .orange,
            //                                                   ),
            //                                         ),
            //                                         const SizedBox(
            //                                           width: 4,
            //                                         ),
            //                                         Text(
            //                                           "(121)",
            //                                           style: Theme.of(
            //                                                   context)
            //                                               .textTheme
            //                                               .bodySmall
            //                                               ?.copyWith(
            //                                                 color: Colors
            //                                                     .grey[600],
            //                                               ),
            //                                         ),
            //                                       ],
            //                                     ),
            //                                     RichText(
            //                                       textAlign:
            //                                           TextAlign.center,
            //                                       text: TextSpan(
            //                                         children: [
            //                                           TextSpan(
            //                                             text: "From",
            //                                             style: Theme.of(
            //                                                     context)
            //                                                 .textTheme
            //                                                 .bodySmall
            //                                                 ?.copyWith(
            //                                                   color: Colors
            //                                                           .grey[
            //                                                       600],
            //                                                 ),
            //                                           ),
            //                                           TextSpan(
            //                                             text: " Rp224.000",
            //                                             style: Theme.of(
            //                                                     context)
            //                                                 .textTheme
            //                                                 .titleSmall
            //                                                 ?.copyWith(
            //                                                   fontWeight:
            //                                                       FontWeight
            //                                                           .bold,
            //                                                 ),
            //                                           ),
            //                                         ],
            //                                       ),
            //                                     ),
            //                                   ],
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                         ],
            //                       )),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             );
            //           },
            //         );
            //       } else {
            //         return Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }
            //     },
            //   ),
            // ),

            ),
      ),
    );
  }
}

// class NewsWidget extends StatefulWidget {
//   @override
//   _NewsWidgetState createState() => _NewsWidgetState();
// }

// class _NewsWidgetState extends State<NewsWidget> {
//   late Future<List<NewsArticle>> futureNews;

//   @override
//   void initState() {
//     super.initState();
//     futureNews = fetchNews();
//   }

//   Future<List<NewsArticle>> fetchNews() async {
//     final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=freelancer&apiKey=16f57f8d0e444696863da47a233e651b'));

//     if (response.statusCode == 200) {
//       final List<dynamic> jsonData = json.decode(response.body)['articles'];
//       return jsonData.map((article) => NewsArticle.fromJson(article)).toList();
//     } else {
//       throw Exception('Failed to load news');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "News",
//           style: Theme.of(context).textTheme.headlineSmall,
//         ),
//         FutureBuilder<List<NewsArticle>>(
//           future: futureNews,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text("Error: ${snapshot.error}"));
//             } else {
//               final newsArticles = snapshot.data!;
//               return Container(
//                 height: 120, // Adjust height as needed
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: newsArticles.length,
//                   itemBuilder: (context, index) {
//                     final article = newsArticles[index];
//                     return GestureDetector(
//                       // onTap: () {
//                       //   Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //       builder: (context) => NewsDetailPage(url: article.url),
//                       //     ),
//                       //   );
//                       // },
//                       child: Container(
//                         width: 100, // Adjust width as needed
//                         margin: EdgeInsets.all(8),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Image.network(article.imageUrl, fit: BoxFit.cover),
//                             SizedBox(height: 8),
//                             Text(article.title, maxLines: 1, overflow: TextOverflow.ellipsis),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }

class NewsWidget extends StatefulWidget {
  @override
  _NewsWidgetState createState() => _NewsWidgetState();
}

class _NewsWidgetState extends State<NewsWidget> {
  late Future<List<NewsArticle>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

    Future<List<NewsArticle>> fetchNews() async {
      final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=freelancer&apiKey=16f57f8d0e444696863da47a233e651b'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body)['articles'];
        return jsonData.map((article) => NewsArticle.fromJson(article)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "News",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        FutureBuilder<List<NewsArticle>>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              final newsArticles = snapshot.data!;
              return Container(
                height: 200, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: newsArticles.length,
                  itemBuilder: (context, index) {
                    final article = newsArticles[index];
                    return GestureDetector(
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => NewsDetailPage(url: article.url),
                      //     ),
                      //   );
                      // },
                      child: Container(
                        width: 150, // Adjust width as needed
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                article.imageUrl,
                                fit: BoxFit.cover,
                                width: 150, // Ensure the image fits the container
                                height: 200,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              right: 10,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                color: Colors.black54, // Semi-transparent background
                                child: Text(
                                  article.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}


// class NewsDetailPage extends StatelessWidget {
//   final String url;

//   const NewsDetailPage({Key? key, required this.url}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("News Detail")),
//       body: WebView(
//         initialUrl: url,
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }




