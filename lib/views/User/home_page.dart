// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:clone_freelancer_mobile/views/User/category_page.dart';
import 'package:clone_freelancer_mobile/views/User/profile_page.dart';
import 'package:clone_freelancer_mobile/views/faq/faq_page.dart';
import 'package:clone_freelancer_mobile/views/news/news_list.dart';
import 'package:clone_freelancer_mobile/views/notes/notes_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:clone_freelancer_mobile/controllers/service_controller.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/models/package.dart';
import 'package:clone_freelancer_mobile/views/User/details_page.dart';
import 'package:clone_freelancer_mobile/views/User/display_search_page.dart';
import 'package:get/get.dart';
import 'package:clone_freelancer_mobile/views/User/navigation_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:clone_freelancer_mobile/models/news.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.purple,
          title: Center(
            // mengatur title untuk Home
            child: Text(
              'home'.tr,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
              // child: SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(
                  top: 32, bottom: 16, left: 16, right: 16),
              child: RefreshIndicator(
                onRefresh: fetchData,
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              box.read('pic') != null
                                  ? GestureDetector(
                                      onTap: () {
                                        // Gambar profil yang berisi ketika di klik akan navigasi ke halaman ProfilePage
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage()),
                                        );
                                      },
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
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
                                          borderRadius:
                                              BorderRadius.circular(100),
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
                                            builder: (context) =>
                                                ProfilePage()),
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
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis
                                                .horizontal, // Mengaktifkan scroll horizontal
                                            child: Column(
                                              children: [
                                                if (isPortrait) // Implementasi hanya untuk mode portrait
                                                  Text(
                                                    // Memeriksa apakah panjang teks lebih dari 9 karakter
                                                    box
                                                                .read('user')[
                                                                    'name']
                                                                .length >
                                                            9
                                                        ? '${box.read('user')['name'].substring(0, 9)}...' // Memotong teks dan menambahkan "..."
                                                        : box.read('user')[
                                                            'name'], // Menampilkan teks jika kurang dari atau sama dengan 9 karakter
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    overflow: TextOverflow
                                                        .ellipsis, // Menggunakan ellipsis untuk memotong teks
                                                  )
                                                else
                                                  Text(
                                                    box.read('user')[
                                                        'name'], // Tampilkan nama secara penuh pada mode landscape
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                // Text(
                                                //   box
                                                //               .read('user')[
                                                //                   'name']
                                                //               .length >
                                                //           15
                                                //       ? '${box.read('user')['name'].substring(0, 15)}...'
                                                //       : box
                                                //           .read('user')['name'],
                                                //   style: Theme.of(context)
                                                //       .textTheme
                                                //       .titleLarge
                                                //       ?.copyWith(
                                                //         fontWeight:
                                                //             FontWeight.bold,
                                                //       ),
                                                // ),
                                              ],
                                            ),
                                            // child: Column(
                                            //   children: [
                                            //     Text(
                                            //       box.read('user')['name'],
                                            //       style: Theme.of(context)
                                            //           .textTheme
                                            //           .titleLarge
                                            //           ?.copyWith(
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //           ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ),
                                        )

                                      // GestureDetector(
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 ProfilePage()),
                                      //       );
                                      //     },
                                      //     child: Text(
                                      //       box.read('user')['name'],
                                      //       style: Theme.of(context)
                                      //           .textTheme
                                      //           .titleLarge
                                      //           ?.copyWith(
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //       overflow: TextOverflow.ellipsis,
                                      //       maxLines: 1,
                                      //     ),
                                      //   )
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
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                // Membuat tombol dengan simbol gambar untuk menuju ke halaman Frequently Ask Question (FAQ)
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FaqPage()),
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.question_answer_outlined),
                                ),
                                // Membuat tombol dengan gambar notes untuk menuju ke halaman notes
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NotesPage()),
                                    );
                                  },
                                  icon: const Icon(Icons.notes),
                                )
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
                          'service_categories'.tr,
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
                                text: 'see_all'.tr,
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
                                                padding:
                                                    const EdgeInsets.all(4),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  data[index]
                                                      ['subcategory_name'],
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
                                            'services'.tr,  
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
                                                linkServicePic =
                                                    url.replaceFirst(
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
                                                            amount:
                                                                double.parse(
                                                                    price))
                                                        .copyWith(
                                                            symbol: 'IDR');
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
                                                          id: item[
                                                              'package_id'],
                                                          title: item['title'],
                                                          desc: item[
                                                              'description'],
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
                                                        type: data[index]
                                                            ['type'],
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
                                                            [
                                                            'subcategory_name'],
                                                        customOrder: data[index]
                                                                    [
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
                                                    shape:
                                                        RoundedRectangleBorder(
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
                                                                      height:
                                                                          150,
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
                                                                          left:
                                                                              8,
                                                                          right:
                                                                              8),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
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
                                                                              // Mengecek orientasi perangkat
                                                                              Text(
                                                                                MediaQuery.of(context).orientation == Orientation.portrait
                                                                                    // Jika orientasi potret dan panjang nama lebih dari 15 karakter, potong nama
                                                                                    ? (data[index]['name'].length > 15
                                                                                        ? '${data[index]['name'].substring(0, 15)}...' // Memotong karakter ke-16 dan menambahkan "..."
                                                                                        : data[index]['name']) // Tampilkan nama jika kurang dari atau sama dengan 15 karakter
                                                                                    : data[index]['name'], // Tampilkan nama lengkap di mode landscape
                                                                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          // Row(
                                                                          //   children: [
                                                                          //     // gambar dan nama profil
                                                                          //     SizedBox(
                                                                          //       width: 30,
                                                                          //       height: 30,
                                                                          //       child: ClipRRect(
                                                                          //         borderRadius: BorderRadius.circular(100),
                                                                          //         child: Image.network(
                                                                          //           linkAvatar,
                                                                          //           fit: BoxFit.cover,
                                                                          //         ),
                                                                          //       ),
                                                                          //     ),
                                                                          //     const SizedBox(
                                                                          //       width: 8,
                                                                          //     ),
                                                                          //     Text(
                                                                          //       data[index]['name'],
                                                                          //       style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                                          //             fontWeight: FontWeight.bold,
                                                                          //           ),
                                                                          //     ),
                                                                          //   ],
                                                                          // ),
                                                                          // gambar hati/love untuk menambahkan service favorit
                                                                          data[index]['serviceFav'] == true
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
                                                                        height:
                                                                            0,
                                                                      ),
                                                                      Text(
                                                                          // menampilkan judul layanan/service
                                                                          data[index]
                                                                              [
                                                                              'title'],
                                                                          maxLines:
                                                                              2,
                                                                          overflow: TextOverflow
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
                                                                            MainAxisAlignment.spaceBetween,
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
          // ),
        ));
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
//     final response = await http.get(Uri.parse(
//         'https://newsapi.org/v2/everything?q=freelancer&apiKey=16f57f8d0e444696863da47a233e651b'));

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
//                 height: 200, // Adjust height as needed
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: newsArticles.length,
//                   itemBuilder: (context, index) {
//                     final article = newsArticles[index];
//                     return GestureDetector(
//                       onTap: () {
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (context) => NewsDetailPage(url: article.url),
//                         //   ),
//                         // );
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => NewsDetailPage(
//                               title: article.title,
//                               imageUrl: article.imageUrl,
//                               description: article.description ??
//                                   'No description available.',
//                               publishedAt: article.publishedAt,
//                               url: article.url,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         width: 300, // Adjust width as needed
//                         margin: EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.network(
//                                 article.imageUrl,
//                                 fit: BoxFit.cover,
//                                 width:
//                                     300, // Ensure the image fits the container
//                                 height: 200,
//                               ),
//                             ),
//                             Positioned(
//                               top: 1,
//                               bottom: 1,
//                               left: 130,
//                               right: 1,
//                               child: Container(
//                                 padding: EdgeInsets.all(4),
//                                 color: Colors
//                                     .black54, // Semi-transparent background
//                                 child: Text(
//                                   article.title,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                   maxLines: 8,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ),
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
//     final response = await http.get(Uri.parse(
//         'https://newsapi.org/v2/everything?q=freelancer&apiKey=16f57f8d0e444696863da47a233e651b'));

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
//                 height: 250, // Adjust height as needed
//                 child: PageView.builder(
//                   controller: PageController(viewportFraction: 0.99),
//                   itemCount: newsArticles.length,
//                   itemBuilder: (context, index) {
//                     final article = newsArticles[index];
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => NewsDetailPage(
//                               title: article.title,
//                               imageUrl: article.imageUrl,
//                               description: article.description ??
//                                   'No description available.',
//                               publishedAt: article.publishedAt,
//                               url: article.url,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 23),
//                         child: Container(
//                           margin: EdgeInsets.symmetric(vertical: 20),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black,
//                                 blurRadius: 3,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                           child: Stack(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(15),
//                                 child: Image.network(
//                                   article.imageUrl,
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                   height: 250,
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 0,
//                                 left: 0,
//                                 right: 0,
//                                 bottom: 0,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [
//                                         Colors.black.withOpacity(0.0),
//                                         Colors.transparent
//                                       ],
//                                       begin: Alignment.bottomCenter,
//                                       end: Alignment.topCenter,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 0,
//                                 bottom: 0,
//                                 left: 100,
//                                 right: 0,
//                                 child:
//                                     // Container(
//                                     //   padding: EdgeInsets.all(4),
//                                     //   color: Colors
//                                     //       .black54, // Semi-transparent background
//                                     //   child: Text(
//                                     //     article.title,
//                                     //     style: TextStyle(
//                                     //       color: Colors.white,
//                                     //       fontWeight: FontWeight.bold,
//                                     //       fontSize: 16,
//                                     //     ),
//                                     //     maxLines: 8,
//                                     //     overflow: TextOverflow.ellipsis,
//                                     //   ),
//                                     // ),
//                                     Container(
//                                   padding: EdgeInsets.all(4),
//                                   decoration: BoxDecoration(
//                                     color: Colors
//                                         .black54, // Semi-transparent background
//                                     borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(15),
//                                       bottomRight: Radius.circular(15),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     article.title,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                     maxLines: 8,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
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

// class NewsDetailPage extends StatelessWidget {
//   final String title;
//   final String imageUrl;
//   final String description;
//   final String publishedAt;
//   final String url;

//   NewsDetailPage({
//     required this.title,
//     required this.imageUrl,
//     required this.description,
//     required this.publishedAt,
//     required this.url,
//   });

//   // Function to launch the URL in the browser
//   Future<void> _launchURL() async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('News Detail'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display the news image
//             Image.network(imageUrl, fit: BoxFit.cover),

//             SizedBox(height: 16.0),

//             // Display the news title
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             SizedBox(height: 8.0),

//             // Display the published date
//             Text(
//               'Published on: $publishedAt',
//               style: TextStyle(color: Colors.grey[600]),
//             ),

//             SizedBox(height: 16.0),

//             // Display the news description
//             Text(
//               description,
//               style: TextStyle(fontSize: 16.0),
//             ),

//             SizedBox(height: 24.0),

//             // Button to open the full article in the browser
//             Center(
//               child: ElevatedButton(
//                 onPressed: _launchURL, // Call the _launchURL function on press
//                 child: Text('Read Full Article'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FaqPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Helpdesk'),
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blueAccent, Colors.lightBlueAccent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'FAQ'),
//               Tab(text: 'Contact'),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             FAQListView(),
//             ContactListView(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FAQListView extends StatefulWidget {
//   const FAQListView({super.key});

//   @override
//   _FAQListViewState createState() => _FAQListViewState();
// }

// class _FAQListViewState extends State<FAQListView> {
//   final List<Map<String, String>> faqData = [
//     {
//       'question': 'Bagaimana cara untuk mengakses seller mode?',
//       'answer': 'Menuju ke halaman profil, setelah itu menekan tombol seller mode. Jika sudah menekan tombol seller mode, lalu isikan data diri dengan mengikuti perintah pada tiap bagian.'
//     },
//     {
//       'question': 'Bagaimana cara untuk melakukan posting untuk layanan atau jasa pada aplikasi ini?',
//       'answer': 'Setelah mengubah mode akun menjadi seller mode, Anda dapat melakukan posting jasa / layanan dengan menekan tombol "Add New Services".'
//     },
//     {
//       'question': 'Jika telah melakukan pembelian pada suatu barang/jasa, namun belum melakukan pembayaran, apakah pembelian tersebut bisa otomatis di cancel secara realtime?',
//       'answer': 'Iya, pembelian tersebut akan secara otomatis dibatalkan secara langsung jika pembayaran tidak dilakukan atau terlambat dilakukan.'
//     },
//     {
//       'question': 'Apakah dapat melakukan refund dana jika sudah terlanjur melakukan pembayaran, namun melebihi deadline yang ditentukan sehingga pembelian tidak berhasil?',
//       'answer': 'Fitur tersebut sedang dalam proses pengerjaan.'
//     },
//     {
//       'question': 'Bagaimana cara untuk melihat detail dari setiap list berita?',
//       'answer': 'Dengan menekan gambar berita yang dituju, maka Anda akan menuju pada halaman detail, dan Anda dapat membuka halaman web/url dengan menekan tombol "Read Full Article".'
//     },
//   ];

//   String searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, String>> filteredFaq = faqData.where((faq) {
//       return faq['question']!.toLowerCase().contains(searchQuery.toLowerCase());
//     }).toList();

//     return Column(
//       children: [
//         // Search Bar
//         Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: TextField(
//             decoration: InputDecoration(
//               hintText: 'Search FAQ',
//               prefixIcon: Icon(Icons.search, color: Colors.grey),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 searchQuery = value;
//               });
//             },
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: filteredFaq.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 child: Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: ExpansionTile(
//                     title: Text(
//                       filteredFaq[index]['question'] ?? '',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Text(
//                           filteredFaq[index]['answer'] ?? '',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ),
//                     ],
//                     leading: Icon(
//                       Icons.question_answer,
//                       color: Colors.blueAccent,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ContactListView extends StatefulWidget {
//   const ContactListView({super.key});

//   @override
//   State<ContactListView> createState() => _ContactListViewState();
// }

// class _ContactListViewState extends State<ContactListView> {
//   final List<Map<String, dynamic>> contactData = [
//     {
//       'type': 'WhatsApp',
//       'info': '+1234567890 (Freelancer Support)',
//       'icon': 'assets/icons/whatsapp.png',
//     },
//     {
//       'type': 'Email',
//       'info': 'support@freelancer.com',
//       'icon': 'assets/icons/email.png',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: contactData.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//           child: Card(
//             elevation: 5,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: ListTile(
//               // leading: Icon(
//               //   // contactData[index]['icon'] as IconData,
//               //   contactData[index]['icon'] as IconData?,
//               //   color: Colors.blueAccent,
//               //   size: 30,
//               // ),
//               leading: Image.asset(
//                 contactData[index]['icon']!,
//                 width: 24, // Set ukuran ikon sesuai kebutuhan
//                 height: 24,
//               ),
//               title: Text(
//                 contactData[index]['type'] ?? '',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//               ),
//               subtitle: Text(
//                 contactData[index]['info'] ?? '',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[700],
//                 ),
//               ),
//               trailing: Icon(
//                 Icons.arrow_forward_ios,
//                 color: Colors.grey[400],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
