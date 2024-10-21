// ignore_for_file: avoid_print

import 'dart:io';

import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:clone_freelancer_mobile/controllers/service_controller.dart';
import 'package:clone_freelancer_mobile/controllers/user_controller.dart';
import 'package:clone_freelancer_mobile/views/seller/Portfolio/add_portfolio_dialog.dart';
import 'package:clone_freelancer_mobile/views/seller/Profile/edit_seller_profile_dialog.dart';
import 'package:clone_freelancer_mobile/views/seller/Portfolio/show_portfolio_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerProfilePage extends StatefulWidget {
  const SellerProfilePage({super.key});

  @override
  State<SellerProfilePage> createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  final UserController userController = Get.put(UserController());
  final SellerController sellerController = Get.put(SellerController());
  final ServiceController serviceController = Get.put(ServiceController());
  late Future futureHeader;
  late Future futureAbout;
  late Future futureServices;
  late Future futurePortfolio;
  late Future futureReviews;
  File? profileImage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    print('Fetching data');
    setState(() {
      futureHeader = sellerController.fetchHeader();
      futureAbout = sellerController.fetchAbout();
      futureServices = sellerController.fetchServices();
      futurePortfolio = sellerController.fetchPortfolio();
      futureReviews = sellerController.fetchAllReviews();
    });
  }

  void editSellerProfile(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => EditSellerProfileDialog(
        futureAbout: futureAbout,
        onClose: (result) {
          Navigator.pop(context, result);
        },
      ),
    );

    if (result != null) {
      fetchData();
    }
  }

  void addPortfolio(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddPortfolioDialog(
        onClose: (result) {
          Navigator.pop(context, result);
        },
      ),
    );

    if (result != null) {
      fetchData();
    }
  }

  void showPortfolio(BuildContext context, int portfolioId) async {
    final result = await showDialog(
      context: context,
      builder: (context) => ShowPortfolioDialog(
        onClose: (result) {
          Navigator.pop(context, result);
        },
        portfolioId: portfolioId,
        user: 'freelancer',
      ),
    );

    if (result != null) {
      fetchData();
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      File imageTemp = File(image.path);
      profileImage = imageTemp;
      setState(() {
        userController
            .changeProfilePicture(profileImage!.path)
            .then((value) => fetchData());
      });
    } on PlatformException catch (e) {
      Get.snackbar(
        "Error",
        'Failed to pick image: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File imageTemp = File(image.path);
      profileImage = imageTemp;
      setState(() {
        userController
            .changeProfilePicture(profileImage!.path)
            .then((value) => fetchData());
      });
    } on PlatformException catch (e) {
      Get.snackbar(
        "Error",
        'Failed to pick image: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();
              pickImageCamera();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Gallery'),
            onPressed: () {
              Navigator.of(context).pop();
              pickImageGallery();
            },
          ),
        ],
      ),
    );
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
          title: const Text(
            'Seller Profile', // Judul AppBar
            style: TextStyle(
              color: Colors.white, // Ganti dengan warna yang diinginkan
              fontSize: 20, // Ukuran teks bisa disesuaikan
            ),
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Edit Seller Profile"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Add Portfolio"),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  editSellerProfile(context);
                } else if (value == 1) {
                  addPortfolio(context);
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FutureBuilder(
                  future: futureHeader,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final data = snapshot.data;
                      return Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      data['user']['piclink'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      showOptions();
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: const Color(0xff858AFF)),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(data['user']['name']),
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
                                  data['avg'].toString() ?? '0',
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
                                  "(${data['count']})",
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
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                const TabBar(
                  labelColor: Colors.green,
                  indicatorColor: Color(0xff6571ff),
                  tabs: <Widget>[
                    Tab(
                      text: 'About',
                    ),
                    Tab(
                      text: 'Service',
                    ),
                    Tab(
                      text: 'Reviews',
                    ),
                    Tab(
                      text: 'Portfolio',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                ContentSizeTabBarView(
                  children: [
                    FutureBuilder(
                      future: futureAbout,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final data = snapshot.data;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("User Information"),
                              const SizedBox(
                                height: 8,
                              ),
                              ExpandableText(
                                data['freelancer']['description'],
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
                              const Text('Languages'),
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
                              const Text('Skills'),
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
                              const Text('Personal Url'),
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
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    FutureBuilder(
                      future: futureServices,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final data = snapshot.data;
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final dataIndex = data['services'][index];
                              MoneyFormatter fmf = MoneyFormatter(
                                      amount: double.parse(
                                          dataIndex['lowestPrice']))
                                  .copyWith(symbol: 'IDR');
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
                                                            " ${fmf.output.symbolOnLeft}",
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
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    FutureBuilder(
                      future: futureReviews,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          final data = snapshot.data;
                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return Card(
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
                                                data[index]['piclink'],
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(data[index]
                                                            ['name']),
                                                        Text(data[index]
                                                            ['updated_at']),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                                          double.parse(data[
                                                                      index]
                                                                  ['rating'])
                                                              .toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                    color: Colors
                                                                        .orange,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(data[index]['comment']),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    FutureBuilder(
                      future: futurePortfolio,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          if (snapshot.data == null || snapshot.data.isEmpty) {
                            return const Center(child: Text('No data'));
                          } else {
                            final data = snapshot.data;
                            return MasonryGridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    showPortfolio(
                                        context, data[index]['portfolio_id']);
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
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                            child: Image.network(
                                              data[index]['portfolioPic'][0]
                                                  ['piclink'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              data[index]['title'],
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
                            );
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
