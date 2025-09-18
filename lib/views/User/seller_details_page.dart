// ignore_for_file: avoid_print

import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:clone_freelancer_mobile/controllers/user_controller.dart';
import 'package:clone_freelancer_mobile/views/seller/Portfolio/show_portfolio_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerDetailsPage extends StatefulWidget {
  const SellerDetailsPage({
    super.key,
    required this.sellerId,
  });
  final String sellerId;

  @override
  State<SellerDetailsPage> createState() => _SellerDetailsPageState();
}

class _SellerDetailsPageState extends State<SellerDetailsPage> {
  final UserController userController = Get.put(UserController());
  late Future futureDataSeller;

  @override
  void initState() {
    super.initState();
    fetchData(widget.sellerId);
  }

  void fetchData(String sellerId) async {
    print('Fetching data');
    setState(() {
      futureDataSeller = userController.fetchDataSeller(sellerId: sellerId);
    });
  }

  void showPortfolio(BuildContext context, int portfolioId) async {
    final result = await showDialog(
      context: context,
      builder: (context) => ShowPortfolioDialog(
        onClose: (result) {
          Navigator.pop(context, result);
        },
        portfolioId: portfolioId,
        user: 'client',
      ),
    );

    if (result != null) {
      fetchData(widget.sellerId);
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'seller_profile'.tr, // Judul AppBar
            style: TextStyle(
              color: Colors.white, // Ganti dengan warna yang diinginkan
              fontSize: 20, // Ukuran teks bisa disesuaikan
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: futureDataSeller,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final data = snapshot.data;
                print(data['portfolio']);
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            data['data']['piclink'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(data['data']['name']),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          Text(
                            data['data']['avg'].toString() ?? '0',
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
                            "(${data['data']['count']})",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                        ],
                      ),
                      TabBar(
                        labelColor: Colors.green,
                        indicatorColor: Color(0xff6571ff),
                        tabs: <Widget>[
                          Tab(
                            text: 'about'.tr,
                          ),
                          Tab(
                            text: 'service'.tr,
                          ),
                          Tab(
                            text: 'reviews'.tr,
                          ),
                          Tab(
                            text: 'portfolio'.tr,
                          ),
                        ],
                      ),
                      const Divider(),
                      ContentSizeTabBarView(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('user_information'.tr),
                              const SizedBox(
                                height: 8,
                              ),
                              ExpandableText(
                                data['data']['description'],
                                expandText: 'more',
                                maxLines: 4,
                                linkColor: const Color(0xff6571ff),
                                animation: true,
                                collapseOnTextTap: true,
                                expandOnTextTap: true,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text('languages'.tr),
                              const SizedBox(
                                height: 8,
                              ),
                              ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 16,
                                  );
                                },
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: data['languages'].length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.language),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data['languages'][index]
                                              ['language_name']),
                                          Text(
                                            data['languages'][index]
                                                ['proficiency_level'],
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text('skills'.tr),
                              const SizedBox(
                                height: 8,
                              ),
                              Wrap(
                                direction: Axis.horizontal,
                                spacing: 4,
                                runSpacing: -8,
                                children: List.generate(
                                  data['skills'].length,
                                  (index) {
                                    return Chip(
                                      label: Text(
                                        data['skills'][index]['skill_name'],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text('personal_url'.tr),
                              const SizedBox(
                                height: 8,
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data['personalUrl'].length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      _launchUrl(data['personalUrl'][index]
                                          ['personalUrl']);
                                    },
                                    child: Text(
                                      data['personalUrl'][index]['personalUrl'],
                                      style:
                                          const TextStyle(color: Colors.blue),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            // Bagian untuk mengatur item service di halaman Service
                            itemBuilder: (context, index) {
                              final dataIndex = data['services'][index];
                              // MoneyFormatter fmf = MoneyFormatter(
                              //         amount: double.parse(
                              //             dataIndex['lowestPrice']))
                              //     .copyWith(symbol: 'IDR');

                              final NumberFormat currencyFormatter =
                                  NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'IDR ',
                                decimalDigits: 0,
                              );

                              String formattedLowestPrice =
                                  currencyFormatter.format(
                                double.tryParse(
                                        dataIndex['lowestPrice'].toString()) ??
                                    0,
                              );

                              return Container(
                                height: 125,
                                decoration: BoxDecoration(
                                  color: const Color(0xff858AFF),
                                  border: Border.all(
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        dataIndex['serviceLink']['piclink'],
                                        fit: BoxFit.cover,
                                        height: 120,
                                        width: 120,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
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
                                                    Text(
                                                      dataIndex['avg']
                                                              .toString() ??
                                                          '0',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                    ),
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                                    Text(
                                                      "(${dataIndex['count']})",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                // dataIndex['serviceFav'] == true
                                                //     ? IconButton(
                                                //         color: Colors.red,
                                                //         onPressed: () {
                                                //           setState(() {
                                                //             serviceController
                                                //                 .deleteSavedService(
                                                //                     dataIndex[
                                                //                         'service_id']);
                                                //             dataIndex[
                                                //                     'serviceFav'] =
                                                //                 false;
                                                //           });
                                                //         },
                                                //         icon: const Icon(
                                                //             Icons.favorite),
                                                //       )
                                                //     : IconButton(
                                                //         color: Colors.white,
                                                //         onPressed: () {
                                                //           setState(() {
                                                //             serviceController
                                                //                 .saveService(
                                                //                     dataIndex[
                                                //                         'service_id']);
                                                //             dataIndex[
                                                //                     'serviceFav'] =
                                                //                 true;
                                                //           });
                                                //         },
                                                //         icon: const Icon(Icons
                                                //             .favorite_outline),
                                                //       ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16),
                                              child: Text(
                                                dataIndex['title'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.white),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16),
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: "From",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            " ${formattedLowestPrice}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                              color: Colors
                                                                      .lightGreenAccent[
                                                                  400],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
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
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 16,
                              );
                            },
                            itemCount: data['services'].length,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data['reviews'].length,
                            itemBuilder: (context, index) {
                              final dataReview = data['reviews'][index];
                              return Card(
                                margin: const EdgeInsets.only(top: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.network(
                                            dataReview['piclink'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(dataReview['name']),
                                                    Text(dataReview[
                                                        'updated_at']),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                    Text(
                                                      double.parse(dataReview[
                                                              'rating'])
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                            color:
                                                                Colors.orange,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(dataReview['comment']),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          MasonryGridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data['portfolio'].length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  showPortfolio(context,
                                      data['portfolio'][index]['portfolio_id']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xff858AFF),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                          child: Image.network(
                                            data['portfolio'][index]
                                                ['portfolioPic'][0]['piclink'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            data['portfolio'][index]['title'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
