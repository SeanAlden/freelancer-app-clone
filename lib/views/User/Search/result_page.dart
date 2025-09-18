import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/core.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/models/package.dart';
import 'package:clone_freelancer_mobile/views/User/Search/filter_dialog.dart';
import 'package:clone_freelancer_mobile/views/User/Search/search_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.keyword});
  final String keyword;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late Future futureResult;
  final box = GetStorage();
  final ServiceController serviceController = Get.put(ServiceController());

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    if (box.read('token') == null) {
      futureResult =
          serviceController.getResultNotLogged(keyword: widget.keyword);
    } else {
      futureResult = serviceController.getResult(keyword: widget.keyword);
    }
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
      if (box.read('token') == null) {
        setState(() {
          futureResult = serviceController.filterDataNotLogged(
            type: result.type,
            lowRange: result.lowRange,
            highRange: result.highRange,
            rating: result.rating,
            keyword: widget.keyword,
            position: result.position,
          );
        });
      } else {
        setState(() {
          futureResult = serviceController.filterData(
            type: result.type,
            lowRange: result.lowRange,
            highRange: result.highRange,
            rating: result.rating,
            keyword: widget.keyword,
            position: result.position,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appBarWidth = MediaQuery.of(context).size.width;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.keyword),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const Searchpage());
              },
              icon: const Icon(Icons.search)),
        ],
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
      body: FutureBuilder(
        future: futureResult,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No result found'));
          } else {
            var data = snapshot.data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var dataIndex = data[index];
                var price = dataIndex['lowestPrice'].toString();
                var rating = dataIndex['rating'].toString();
                var count = dataIndex['count'].toString();
                // MoneyFormatter fmf = MoneyFormatter(amount: double.parse(price))
                //     .copyWith(symbol: 'IDR');

                final NumberFormat currencyFormatter = NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'IDR ',
                  decimalDigits: 0,
                );

                String formattedPrice = currencyFormatter.format(
                  double.tryParse(price) ?? 0,
                );
                return Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: GestureDetector(
                    onTap: () async {
                      var list = await serviceController
                          .getServicePackage(dataIndex['service_id']);
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
                        DetailsPage(
                          serviceId: dataIndex['service_id'],
                          title: dataIndex['title'],
                          desc: dataIndex['description'],
                          packages: itemPackage,
                          rating: double.parse(dataIndex['rating']) ?? 0,
                          count: dataIndex['count'],
                          user: UserData(
                            userId: dataIndex['user_id'],
                            piclink: dataIndex['piclink'],
                            name: dataIndex['name'],
                          ),
                          fav: dataIndex['serviceFav'] == true ? true : false,
                          email: dataIndex['email'],
                          subCategory: dataIndex['subcategory_name'],
                          customOrder: dataIndex['custom_order'] == 'false'
                              ? false
                              : true,
                          type: dataIndex['type'],
                          location: dataIndex['location'],
                          isSeller: data[index]['isSeller'],
                        ),
                      );
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      dataIndex['servicePic'],
                                      fit: BoxFit.cover,
                                      width: 160,
                                      height: 100,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: box.read('token') == null
                                            ? IconButton(
                                                iconSize: 20,
                                                color: Colors.grey[500],
                                                onPressed: () {
                                                  Get.to(
                                                      () => const LoginPage());
                                                },
                                                icon: const Icon(
                                                    Icons.favorite_outline),
                                              )
                                            : dataIndex['serviceFav'] == true
                                                ? IconButton(
                                                    iconSize: 20,
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        serviceController
                                                            .deleteSavedService(
                                                                dataIndex[
                                                                    'service_id']);
                                                        dataIndex[
                                                                'serviceFav'] =
                                                            false;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.favorite),
                                                  )
                                                : IconButton(
                                                    iconSize: 20,
                                                    color: Colors.grey[500],
                                                    onPressed: () {
                                                      setState(() {
                                                        serviceController
                                                            .saveService(dataIndex[
                                                                'service_id']);
                                                        dataIndex[
                                                                'serviceFav'] =
                                                            true;
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.favorite_outline),
                                                  ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dataIndex['title'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          data[index]['rating'] == null
                                              ? Text(
                                                  "0",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: Colors.orange,
                                                      ),
                                                )
                                              : Text(
                                                  rating,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
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
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey[300],
                            height: 0,
                            indent: 0,
                            thickness: 1,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                right: 8, top: 8, bottom: 8),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                formattedPrice,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
