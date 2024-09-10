// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:clone_freelancer_mobile/core.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/models/package.dart';
import 'package:clone_freelancer_mobile/views/seller/Service/add_service_page.dart';
import 'package:clone_freelancer_mobile/views/seller/Service/edit_service_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constant/const.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({super.key});

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  final box = GetStorage();
  late Future futureSellerService;
  final ServiceController serviceController = Get.put(ServiceController());
  final SellerController sellerController = Get.put(SellerController());

  @override
  void initState() {
    super.initState();
    fetchData();
    print(Get.currentRoute);
  }

  void fetchData() async {
    print('Fetching data');
    setState(() {
      futureSellerService = sellerController.fetchProduct();
    });
  }

  Future _refresh() async {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
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
            onRefresh: _refresh,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              box.read('pic').toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello,",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            box.read('token') != null
                                ? Text(
                                    box.read('user')['name'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  )
                                : Text(
                                    "Guest",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
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
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.to(() => const AddServicePage());
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add New Services"),
                    ),
                    // ElevatedButton.icon(
                    //   onPressed: () {},
                    //   icon: const Icon(Icons.filter_alt),
                    //   label: const Text("Filter"),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Your Services",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                FutureBuilder(
                  future: futureSellerService,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      final data = snapshot.data;
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          String linkAvatar = data[index]['picasset'];
                          linkAvatar =
                              url.replaceFirst('/api/', '') + linkAvatar;
                          var linkServicePic =
                              data[index]['servicePic']['picasset'];
                          linkServicePic =
                              url.replaceFirst('/api/', '') + linkServicePic;
                          return Dismissible(
                            key: Key(data[index]['service_id'].toString()),
                            onDismissed: (direction) async {
                              await sellerController
                                  .deleteService(
                                      serviceId: data[index]['service_id'])
                                  .then((_) {
                                fetchData();
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Service deleted'),
                                  ),
                                );
                              }
                            },
                            background: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: const Icon(Icons.delete),
                            ),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  var list =
                                      await serviceController.getServicePackage(
                                          data[index]['service_id']);
                                  List<Package> itemPackage = [];
                                  for (var item in list) {
                                    itemPackage.add(
                                      Package(
                                        id: item['package_id'],
                                        title: item['title'],
                                        desc: item['description'],
                                        price: int.parse(item['price']),
                                        deliveryDays: item['delivery_days'],
                                        revision: item['revision'],
                                      ),
                                    );
                                  }
                                  Get.to(
                                    () => DetailsPage(
                                      type: data[index]['type'],
                                      location: data[index]['location'],
                                      serviceId: data[index]['service_id'],
                                      title: data[index]['title'],
                                      desc: data[index]['description'],
                                      user: UserData(
                                        userId: data[index]['user_id'],
                                        piclink: linkAvatar,
                                        name: data[index]['name'],
                                      ),
                                      packages: itemPackage,
                                      rating:
                                          double.parse(data[index]['rating']),
                                      count: data[index]['count'],
                                      fav: data[index]['serviceFav'] == true
                                          ? true
                                          : false,
                                      email: data[index]['email'],
                                      subCategory: data[index]
                                          ['subcategory_name'],
                                      customOrder:
                                          data[index]['custom_order'] == 'false'
                                              ? false
                                              : true,
                                      isSeller: data[index]['isSeller'],
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 100,
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      data[index]['servicePic'] == null
                                          ? Image.asset(
                                              'assets/images/blank_image.png',
                                              fit: BoxFit.cover,
                                              height: 100,
                                              width: 100,
                                            )
                                          : Image.network(
                                              linkServicePic,
                                              fit: BoxFit.cover,
                                              height: 100,
                                              width: 100,
                                            ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              data[index]['title'],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                            Text(
                                              data[index]['type'],
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium
                                                  ?.copyWith(
                                                    color: Colors.grey[600],
                                                  ),
                                            ),
                                            Text(
                                              "${data[index]['IsApproved']}"
                                                  .capitalize!,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium
                                                  ?.copyWith(
                                                    color: data[index][
                                                                'IsApproved'] ==
                                                            'pending'
                                                        ? Colors.amber
                                                        : data[index][
                                                                    'IsApproved'] ==
                                                                'approved'
                                                            ? Colors.green
                                                            : Colors.red,
                                                  ),
                                            ),
                                          ],
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
                      return const Center(
                        child: Text('Service Empty'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
