// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/service_controller.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/models/package.dart';
import 'package:clone_freelancer_mobile/views/Auth/login.dart';
import 'package:clone_freelancer_mobile/views/User/Search/filter_dialog.dart';
import 'package:clone_freelancer_mobile/views/User/details_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_formatter/money_formatter.dart';

class DisplaySearchPage extends StatefulWidget {
  final int? subCategoryId;
  final String? subCategoryText;
  final String? searchText;

  const DisplaySearchPage(
      {super.key,
      required this.subCategoryId,
      required this.searchText,
      required this.subCategoryText});

  @override
  State<DisplaySearchPage> createState() => _DisplaySearchPageState();
}

class _DisplaySearchPageState extends State<DisplaySearchPage> {
  late Future futureDisplay;
  final ServiceController serviceController = Get.put(ServiceController());
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    if (widget.searchText == null) {
      if (box.read('token') == null) {
        futureDisplay = serviceController
            .getDisplayBySubCategoryIdNoAuth(widget.subCategoryId!);
      } else {
        futureDisplay = serviceController
            .getDisplayBySubCategoryIdAuth(widget.subCategoryId!);
      }
    } else {}
  }

  void openFilterDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => FilterDialog(
        onClose: (result) {
          Navigator.pop(context, result);
        },
      ),
    );
    if (result != null) {
      print('not null');
      if (box.read('token') == null) {
        setState(() {
          futureDisplay = serviceController.filterSubCategoryNotLogged(
            type: result.type,
            lowRange: result.lowRange,
            highRange: result.highRange,
            rating: result.rating,
            subCategoryId: widget.subCategoryId.toString(),
            position: result.position,
          );
        });
      } else {
        setState(() {
          futureDisplay = serviceController.filterSubCategory(
            type: result.type,
            lowRange: result.lowRange,
            highRange: result.highRange,
            rating: result.rating,
            subCategoryId: widget.subCategoryId.toString(),
            position: result.position,
          );
        });
      }
    } else {
      print('null');
    }
  }

  @override
  Widget build(BuildContext context) {
    var appBarWidth = MediaQuery.of(context).size.width;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.subCategoryText.toString(),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size(appBarWidth, appBarHeight - 8),
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color(0xff6571ff),
                      ),
                    ),
                    onPressed: () {
                      openFilterDialog(context);
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.filter_list_outlined,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: " Filter",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 16,
          bottom: 16,
          left: 8,
          right: 8,
        ),
        child: FutureBuilder(
          future: futureDisplay,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: widget.searchText == null
                    ? Text('No Matches for ${widget.subCategoryText}')
                    : Text('No Matches for ${widget.searchText}'),
              );
            } else {
              final data = snapshot.data;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: MediaQuery.of(context).size.height / 1400,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var price = data[index]['lowestPrice'].toString();
                  var rating = data[index]['rating'].toString();
                  var count = data[index]['count'].toString();
                  var serviceId = data[index]['service_id'];
                  print(data[index]['servicePic']);
                  MoneyFormatter fmf =
                      MoneyFormatter(amount: double.parse(price))
                          .copyWith(symbol: 'IDR');
                  return GestureDetector(
                    onTap: () async {
                      var list =
                          await serviceController.getServicePackage(serviceId);
                      List<Package> itemPackage = [];
                      for (var item in list) {
                        print(item);
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
                      print(data[index]);
                      Get.to(
                        () => DetailsPage(
                          serviceId: serviceId,
                          title: data[index]['title'],
                          desc: data[index]['description'],
                          user: UserData(
                            userId: data[index]['user_id'],
                            piclink: data[index]['piclink'],
                            name: data[index]['name'],
                          ),
                          packages: itemPackage,
                          rating: double.parse(data[index]['rating']) ?? 0,
                          count: data[index]['count'],
                          fav: data[index]['serviceFav'] == true ? true : false,
                          email: data[index]['email'] ?? '',
                          subCategory: data[index]['subcategory_name'],
                          customOrder: data[index]['custom_order'] == 'false'
                              ? false
                              : true,
                          type: data[index]['type'],
                          location: data[index]['location'],
                          isSeller: data[index]['isSeller'],
                        ),
                      )?.then(
                        (_) {
                          setState(() {
                            fetchData();
                          });
                        },
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Colors.grey[300],
                                      child: Image.network(
                                        data[index]['servicePic'],
                                        fit: BoxFit.contain,
                                        height: 150,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: Image.network(
                                                      data[index]['piclink'],
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  data[index]['name'],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelLarge
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            box.read('token') == null
                                                ? IconButton(
                                                    color: Colors.grey[500],
                                                    onPressed: () {
                                                      Get.to(() =>
                                                          const LoginPage());
                                                    },
                                                    icon: const Icon(
                                                        Icons.favorite_outline),
                                                  )
                                                : data[index]['serviceFav'] ==
                                                        true
                                                    ? IconButton(
                                                        color: Colors.red,
                                                        onPressed: () {
                                                          setState(() {
                                                            serviceController
                                                                .deleteSavedService(
                                                                    serviceId);
                                                            data[index][
                                                                    'serviceFav'] =
                                                                false;
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.favorite),
                                                      )
                                                    : IconButton(
                                                        color: Colors.grey[500],
                                                        onPressed: () {
                                                          setState(() {
                                                            serviceController
                                                                .saveService(
                                                                    serviceId);
                                                            data[index][
                                                                    'serviceFav'] =
                                                                true;
                                                          });
                                                        },
                                                        icon: const Icon(Icons
                                                            .favorite_outline),
                                                      ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 0,
                                        ),
                                        Text(data[index]['title'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "From",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: Colors.grey[600],
                                                    ),
                                              ),
                                              TextSpan(
                                                text:
                                                    " ${fmf.output.symbolOnLeft}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              color: Colors.orange,
                                              size: 15,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            data[index]['rating'] == null
                                                ? Text(
                                                    "0",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.orange,
                                                        ),
                                                  )
                                                : Text(
                                                    rating,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.orange,
                                                        ),
                                                  ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "($count)",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Colors.grey[600],
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
              );
            }
          },
        ),
      ),
    );
  }
}
