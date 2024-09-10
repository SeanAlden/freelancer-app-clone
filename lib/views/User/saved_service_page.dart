import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:clone_freelancer_mobile/controllers/service_controller.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/models/package.dart';
import 'package:clone_freelancer_mobile/views/User/details_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:money_formatter/money_formatter.dart';

class SavedServicesPage extends StatefulWidget {
  const SavedServicesPage({super.key});

  @override
  State<SavedServicesPage> createState() => _SavedServicesPageState();
}

class _SavedServicesPageState extends State<SavedServicesPage> {
  final ServiceController serviceController = Get.put(ServiceController());
  final box = GetStorage();
  late Future futureAllSavedServices;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    setState(() {
      futureAllSavedServices = serviceController.getAllSavedService();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Saved Services",
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 4,
          right: 4,
        ),
        child: FutureBuilder(
          future: futureAllSavedServices,
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
              return const Center(
                child: Text('No Saved Service Available'),
              );
            } else {
              final data = snapshot.data;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: MediaQuery.of(context).size.height / 1400,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var price = data[index]['lowestPrice'].toString();
                  var rating = data[index]['rating'].toString();
                  var count = data[index]['count'].toString();
                  var linkServicePic = data[index]['servicePic']['picasset'];
                  linkServicePic =
                      url.replaceFirst('/api/', '') + linkServicePic;
                  var serviceId = data[index]['service_id'];
                  String linkAvatar = data[index]['picasset'];
                  linkAvatar = url.replaceFirst('/api/', '') + linkAvatar;

                  MoneyFormatter fmf =
                      MoneyFormatter(amount: double.parse(price))
                          .copyWith(symbol: 'IDR');
                  return GestureDetector(
                    onTap: () async {
                      var list =
                          await serviceController.getServicePackage(serviceId);
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
                          serviceId: serviceId,
                          title: data[index]['title'],
                          desc: data[index]['description'],
                          user: UserData(
                            userId: data[index]['user_id'],
                            piclink: linkAvatar,
                            name: data[index]['name'],
                          ),
                          packages: itemPackage,
                          rating: double.parse(data[index]['rating']),
                          count: data[index]['count'],
                          fav: true,
                          email: data[index]['email'],
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
                          fetchData();
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
                                        linkServicePic,
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
                                            IconButton(
                                              color: Colors.red,
                                              onPressed: () async {
                                                await serviceController
                                                    .deleteSavedService(
                                                        serviceId);

                                                fetchData();
                                              },
                                              icon: const Icon(Icons.favorite),
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
                                            // data[index]['rating'] == null
                                            //     ?
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
