// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:clone_freelancer_mobile/views/User/payment_screen.dart';
import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:clone_freelancer_mobile/core.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/models/package.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
// import 'package:path/path.dart';
// import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({
    super.key,
    required this.serviceId,
    required this.title,
    required this.desc,
    required this.packages,
    required this.rating,
    required this.count,
    required this.user,
    required this.fav,
    required this.email,
    required this.subCategory,
    required this.customOrder,
    required this.type,
    required this.location,
    required this.isSeller,
  });
  final int serviceId;
  final String title;
  final String desc;
  final UserData user;
  final List<Package> packages;
  final double rating;
  final int count;
  final bool fav;
  final String email;
  final String subCategory;
  final bool customOrder;
  final String type;
  final String location;
  final bool isSeller;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  int _current = 0;
  final box = GetStorage();
  ModeController modeController = Get.find<ModeController>();
  NavigationController navigationController = Get.find<NavigationController>();

  late TabController _tabController;
  late Future futureReview;

  final _selectedColor = const Color(0xff1a73e8);
  final _unselectedColor = const Color(0xff5f6368);
  final ServiceController serviceController = Get.put(ServiceController());
  final ChatController chatController = Get.put(ChatController());
  final UserController userController = Get.put(UserController());
  List<String> imageList = [];
  final List<Tab> _tabs = [];
  bool fav = true;
  MidtransSDK? _midtrans;
  TextEditingController customOrderDetailsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: widget.packages.length);
    for (var item in widget.packages) {
      // MoneyFormatter fmf =
      //     MoneyFormatter(amount: double.parse(item.price.toString()))
      //         .copyWith(symbol: 'IDR');

      final NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'IDR ',
        decimalDigits: 0,
      );

      String formattedPrice = currencyFormatter.format(
        double.tryParse(item.price.toString()) ?? 0,
      );
      _tabs.add(
        Tab(
          text: formattedPrice,
        ),
      );
    }

    serviceController.getServiceImage(widget.serviceId).then((data) {
      setState(() {
        imageList = data;
      });
    });
    fav = widget.fav;
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      futureReview =
          userController.getReview(serviceId: widget.serviceId.toString());
    });
  }

  void openDialogOnSite(
    BuildContext context,
  ) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Before ordering On-Site Service: ',
            style: textTheme.titleMedium!),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(alertMessage, style: textTheme.titleSmall!),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            child: const Text('OK'),
            onPressed: () async {
              Navigator.of(context).pop();
              DateTime? dateTime = await showOmniDateTimePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 90),
                ),
                barrierDismissible: false,
                title: Text(
                  'Date Picker',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
              if (dateTime != null) {
                if (await Permission.location.isPermanentlyDenied) {
                  openAppSettings();
                } else {
                  await Permission.location.request();
                  var position =
                      await GeolocatorPlatform.instance.getCurrentPosition(
                    locationSettings: const LocationSettings(
                      accuracy: LocationAccuracy.high,
                    ),
                  );
                  print('${position.latitude}  ${position.longitude}');
                  var result = await Get.to(
                    () => MapPickerLocation(
                      position: LatLng(
                        position.latitude,
                        position.longitude,
                      ),
                    ),
                  );
                  if (result != null) {
                    showPaymentOptions(
                      dateTime,
                      LatLng(
                        result['lat'],
                        result['lng'],
                      ),
                      result['address'],
                    );
                    print(result['address']);
                  }
                }
              }
            },
            // Navigator.of(context).pop()
          ),
        ],
      ),
    );
  }

  Future<void> createTransactionAndPay() async {
    final response = await http.post(
      Uri.parse('${url}create-transaction'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      },
      body: jsonEncode({
        'name': box.read('user')['name'],
        'email': box.read('user')['email'],
        'phone': '08123456789',
        'quantity': 1, // FIXED
        'gross_amount': widget.packages[_tabController.index].price,
        'freelancer_id': widget.user.userId,
        'package_id': widget.packages[_tabController.index].id,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final snapToken = data['snapToken'];

      final paymentUrl =
          'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentWebViewScreen(paymentUrl: paymentUrl),
        ),
      );
    } else {
      // ⚠️ HANDLE ERROR HTML / NON JSON
      try {
        final err = jsonDecode(response.body);
        Get.snackbar(
          'Payment Error',
          err['error'] ?? 'Unknown error',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } catch (_) {
        Get.snackbar(
          'Payment Error',
          'Server error, please try again',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  // Future initSDK() async {
  //   _midtrans = await MidtransSDK.init(
  //     config: MidtransConfig(
  //       clientKey: "SB-Mid-client-wYeSigdies_2dI1d",
  //       colorTheme: ColorTheme(
  //         colorPrimary: Theme.of(context).colorScheme.secondary,
  //         colorPrimaryDark: Theme.of(context).colorScheme.secondary,
  //         colorSecondary: Theme.of(context).colorScheme.secondary,
  //       ),
  //       merchantBaseUrl: url,
  //     ),
  //   );
  //   _midtrans?.setUIKitCustomSetting(
  //     skipCustomerDetailsPages: true,
  //   );
  //   _midtrans!.setTransactionFinishedCallback((result) {
  //     print(result.toJson());
  //   });
  // }

  // Future getToken({
  //   required int packageId,
  //   required String packageName,
  //   required String serviceName,
  //   required int price,
  //   required String merchantName,
  //   required String subCategoryName,
  //   required DateTime? dateTemp,
  //   required LatLng? latlng,
  //   required String? loc,
  // }) async {
  //   try {
  //     var data = {
  //       'name': box.read('user')['name'],
  //       'email': box.read('user')['email'],
  //       'package_id': packageId.toString(),
  //       'price': price.toString(),
  //       'service_name': serviceName,
  //       'package_name': packageName,
  //       'sub_category': subCategoryName,
  //       'merchant_name': merchantName,
  //       'seller_id': widget.user.userId.toString(),
  //       if (dateTemp != null) 'onsite_date': dateTemp.toIso8601String(),
  //       if (latlng != null) 'lat': latlng.latitude.toString(),
  //       if (latlng != null) 'lng': latlng.longitude.toString(),
  //       if (loc != null) 'loc': loc,
  //     };

  //     var response = await http.post(
  //       Uri.parse('${url}midtrans/payment'),
  //       headers: {
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer ${box.read('token')}',
  //       },
  //       body: data,
  //     );

  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body)['data'];
  //       await initSDK();
  //       await _midtrans?.startPaymentUiFlow(
  //         token: data,
  //       );
  //     } else {
  //       Get.snackbar(
  //         "Error",
  //         json.decode(response.body)['message'],
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future payWithBalance({
    required int itemId,
    required int price,
    required DateTime? dateTemp,
    required LatLng? latlng,
    required String? loc,
  }) async {
    try {
      var data = {
        'type': 'package',
        'itemId': itemId.toString(),
        'freelancer_id': widget.user.userId.toString(),
        // 'price': price.toString(),
        'price': price,
        if (dateTemp != null) 'onsite_date': dateTemp.toIso8601String(),
        if (latlng != null) 'lat': latlng.latitude.toString(),
        if (latlng != null) 'lng': latlng.longitude.toString(),
        if (loc != null) 'loc': loc,
      };

      var response = await http.post(
        Uri.parse('${url}balance/payment'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<void> _createTransaction(
  //     // {
  //     // // required int packageId,
  //     // // required String packageName,
  //     // // required String serviceName,
  //     // // required int price,
  //     // // required String merchantName,
  //     // // required String subCategoryName,
  //     // // required DateTime? dateTemp,
  //     // // required LatLng? latlng,
  //     // // required String? loc,
  //     // }
  //     ) async {
  //   // final amount = _amountController.text;
  //   // final quantity = _quantityController.text;

  //   final response = await http.post(
  //     Uri.parse('${url}create-transaction'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       // 'name': 'Sean',
  //       // 'email': 'sean.alden@example.com',
  //       // 'phone': '08123456789',
  //       // 'quantity': int.parse(quantity),
  //       // 'gross_amount': int.parse(amount),
  //       'name': box.read('user')['name'],
  //       'email': box.read('user')['email'],
  //       'package_id': widget.packages[_tabController.index].id!,
  //       'package_name': widget.packages[_tabController.index].title,
  //       'service_name': widget.title,
  //       'price': widget.packages[_tabController.index].price,
  //       'merchant_name': widget.user.name,
  //       'sub_category': widget.subCategory,
  //       // 'package_id': packageId.toString(),
  //       // 'price': price.toString(),
  //       // 'service_name': serviceName,
  //       // 'package_name': packageName,
  //       // 'sub_category': subCategoryName,
  //       // 'merchant_name': merchantName,
  //       // 'seller_id': widget.user.userId.toString(),
  //       // if (dateTemp != null) 'onsite_date': dateTemp.toIso8601String(),
  //       // if (latlng != null) 'lat': latlng.latitude.toString(),
  //       // if (latlng != null) 'lng': latlng.longitude.toString(),
  //       // if (loc != null) 'loc': loc,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final snapToken = data['snapToken'];
  //     final paymentUrl =
  //         'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';

  //     // Navigate to the new screen with the payment URL
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PaymentWebViewScreen(paymentUrl: paymentUrl),
  //       ),
  //     );
  //   } else {
  //     print('Error: ${response.body}');
  //   }
  // }

  Future showPaymentOptions(
      DateTime? dateTemp, LatLng? latlng, String? location) async {
    final data = await userController.getBalance();
    int balance = data['balance'];
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Balance : ${balance.toString()}'),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (balance < widget.packages[_tabController.index].price) {
                Get.snackbar(
                  "Error",
                  'Balance not enough',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                await payWithBalance(
                  itemId: widget.packages[_tabController.index].id!,
                  price: widget.packages[_tabController.index].price,
                  dateTemp: dateTemp,
                  latlng: latlng,
                  loc: location,
                ).then((value) => setState(() {
                      isLoading = false;
                    }));
                Navigator.of(context).pop();
              }
              setState(() {
                isLoading = false;
              });
            },
          ),
          CupertinoActionSheetAction(
              child: const Text('Payment Gateway'),
              onPressed: () async {
                //     setState(() {
                //       isLoading = true;
                //     });
                //     await getToken(
                //       packageId: widget.packages[_tabController.index].id!,
                //       packageName: widget.packages[_tabController.index].title,
                //       serviceName: widget.title,
                //       price: widget.packages[_tabController.index].price,
                //       merchantName: widget.user.name,
                //       subCategoryName: widget.subCategory,
                //       dateTemp: dateTemp,
                //       latlng: latlng,
                //       loc: location,
                //     ).then((value) => setState(() {
                //           isLoading = false;
                //         }));
                //     Navigator.of(context).pop();
                //   },

                Navigator.of(context).pop(); // tutup action sheet
                await createTransactionAndPay();

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => PaymentScreen(
                //       name: box.read('user')['name'],
                //       email: box.read('user')['email'],
                //       packageName: widget.packages[_tabController.index].title,
                //       serviceName: widget.title,
                //       price: widget.packages[_tabController.index].price,
                //       merchantName: widget.user.name,
                //       subCategory: widget.subCategory,
                //     ),
                //   ),
                // );

                // Navigator.push(
                //   // context,
                //   // MaterialPageRoute(builder: (context) => PaymentScreen()),
                // );

                // _createTransaction(
                //   // packageId: widget.packages[_tabController.index].id!,
                //   // packageName: widget.packages[_tabController.index].title,
                //   // serviceName: widget.title,
                //   // price: widget.packages[_tabController.index].price,
                //   // merchantName: widget.user.name,
                //   // subCategoryName: widget.subCategory,
                //   // dateTemp: dateTemp,
                //   // latlng: latlng,
                //   // loc: location,
                // );
              }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _midtrans?.removeTransactionFinishedCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              // Bagian container untuk Scroll gambar service
              child: Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800] // Warna teks untuk mode gelap
                    : Colors.grey[100], // Warna teks untuk mode terang
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                            viewportFraction: 1,
                            enableInfiniteScroll: true,
                            aspectRatio: 4 / 3,
                          ),
                          items: imageList.map((imageUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            height: 55,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -16,
                          child: AnimatedSmoothIndicator(
                            activeIndex: _current,
                            count: imageList.length,
                            effect: const WormEffect(
                              dotWidth: 8,
                              dotHeight: 8,
                              dotColor: Colors.grey,
                              activeDotColor: Color(
                                0xff6571ff,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: fav == true
                                ? IconButton(
                                    color: Colors.red,
                                    onPressed: () {
                                      setState(() {
                                        serviceController.deleteSavedService(
                                            widget.serviceId);
                                        fav = false;
                                      });
                                    },
                                    icon: const Icon(Icons.favorite),
                                  )
                                : IconButton(
                                    color: Colors.grey[500],
                                    onPressed: () {
                                      setState(() {
                                        serviceController
                                            .saveService(widget.serviceId);
                                        fav = true;
                                      });
                                    },
                                    icon: const Icon(Icons.favorite_outline),
                                  ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          top: 8,
                          child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if ((Get.previousRoute == '/' ||
                                Get.previousRoute == '/NavigationPage') &&
                            modeController.mode.value == true)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: IconButton(
                              onPressed: () {
                                Get.to(
                                  () => EditServicePage(
                                    serviceId: widget.serviceId,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    // Container untuk mengatur background pada detail service
                    Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black // Warna teks untuk mode gelap
                          : Colors.white, // Warna teks untuk mode terang
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 16,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              widget.type,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                            ),
                            if (widget.location.isNotEmpty)
                              Text(
                                widget.location,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            const SizedBox(
                              height: 8,
                            ),
                            ExpandableText(
                              widget.desc,
                              expandText: 'more',
                              maxLines: 4,
                              linkColor: const Color(0xff6571ff),
                              animation: true,
                              collapseOnTextTap: true,
                              expandOnTextTap: true,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // Container untuk mengatur background pada bagian penjelasan kategori service
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 8,
                        bottom: 16,
                      ),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black // Warna teks untuk mode gelap
                          : Colors.white, // Warna teks untuk mode terang
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            tabs: _tabs,
                            labelColor: _selectedColor,
                            indicatorColor: _selectedColor,
                            unselectedLabelColor: _unselectedColor,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 16),
                            child: ContentSizeTabBarView(
                              controller: _tabController,
                              children: List.generate(
                                widget.packages.length,
                                (index) => ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    Text(
                                      widget.packages[index].title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.calendar_month_outlined,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " Delivery Days",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(color: Colors.grey),
                                          ),
                                          TextSpan(
                                            text:
                                                " ${widget.packages[index].deliveryDays}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.auto_fix_high_outlined,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " Revisions",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(color: Colors.grey),
                                          ),
                                          TextSpan(
                                            text:
                                                " ${widget.packages[index].revision.toString()}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ExpandableText(
                                      widget.packages[index].desc,
                                      expandText: 'more',
                                      maxLines: 4,
                                      linkColor: const Color(0xff6571ff),
                                      animation: true,
                                      collapseOnTextTap: true,
                                      expandOnTextTap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (!widget.isSeller)
                            Row(
                              children: [
                                widget.customOrder
                                    ? Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .all<Color>(Colors
                                                              .blue), // Warna latar belakang
                                                  foregroundColor:
                                                      MaterialStateProperty
                                                          .all<Color>(Colors
                                                              .white), // Warna teks atau ikon
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (box.read('user') ==
                                                      null) {
                                                    Get.to(() =>
                                                        const LoginPage());
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          Dialog(
                                                        child: Form(
                                                          key: _formKey,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              bottom: 16,
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              16),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        'Custom Order',
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleLarge
                                                                            ?.copyWith(
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                      ),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            IconButton(
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all<Color>(Colors.blue), // Warna latar belakang
                                                                            foregroundColor:
                                                                                MaterialStateProperty.all<Color>(Colors.white), // Warna teks atau ikon
                                                                            shape:
                                                                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          icon:
                                                                              const Icon(Icons.close),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                    left: 16,
                                                                    right: 16,
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      TextFormField(
                                                                        controller:
                                                                            customOrderDetailsController,
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.trim().isEmpty) {
                                                                            return 'Please enter your custom order details';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        maxLines:
                                                                            5,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              "Share details about custom order that your services want.",
                                                                          border:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            ElevatedButton(
                                                                          style:
                                                                              ButtonStyle(
                                                                            shape:
                                                                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            if (_formKey.currentState!.validate()) {
                                                                              Navigator.of(context).pop();
                                                                              final chatRoomId = await chatController.createChatRoom(widget.user);
                                                                              if (chatRoomId != null) {
                                                                                await chatController.customOrder(chatRoomId, widget.serviceId, customOrderDetailsController.text.trim());
                                                                              }

                                                                              customOrderDetailsController.clear();
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Text(
                                                                            "Submit",
                                                                          ),
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
                                                  }
                                                },
                                                child: const Text(
                                                  "Custom Order",
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .all<Color>(Colors
                                              .blue), // Warna latar belakang
                                      foregroundColor: MaterialStateProperty
                                          .all<Color>(Colors
                                              .white), // Warna teks atau ikon
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (widget.type.toLowerCase() ==
                                          'on-site service') {
                                        if (box.read('user') == null) {
                                          Get.to(() => const LoginPage());
                                        } else {
                                          openDialogOnSite(context);
                                        }
                                      } else {
                                        if (box.read('user') == null) {
                                          Get.to(() => const LoginPage());
                                        } else {
                                          print('clicked');
                                          showPaymentOptions(null, null, null);
                                        }
                                      }
                                    },
                                    child: Text(
                                      'buy'.tr,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => SellerDetailsPage(
                            sellerId: widget.user.userId.toString(),
                          ),
                        );
                      },
                      // Bagian container untuk mengatur background pada kontak Freelancer
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black // Warna teks untuk mode gelap
                            : Colors.white, // Warna teks untuk mode terang
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.user.piclink == null
                                ? SizedBox(
                                    width: 75,
                                    height: 75,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.network(
                                        'assets/images/blank_image.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width: 75,
                                    height: 75,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.network(
                                        widget.user.piclink!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            const Spacer(),
                            Text(
                              MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  // Jika orientasi potret dan panjang nama lebih dari 10 karakter, potong nama
                                  ? (widget.user.name.length > 10
                                      ? '${widget.user.name.substring(0, 10)}...' // Memotong karakter ke-11 dan menambahkan "..."
                                      : widget.user
                                          .name) // Tampilkan nama jika kurang dari atau sama dengan 10 karakter
                                  : widget.user
                                      .name, // Tampilkan nama lengkap di mode landscape
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            // Text(
                            //   widget.user.name,
                            //   style: Theme.of(context)
                            //       .textTheme
                            //       .titleMedium
                            //       ?.copyWith(
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            // ),
                            const Spacer(
                              flex: 8,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await chatController
                                    .createChatRoom(widget.user);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue), // Warna latar belakang
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white), // Warna teks atau ikon
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                'chat'.tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // Bagian Container untuk mengatur background pada bagian rating service
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black // Warna teks untuk mode gelap
                          : Colors.white, // Warna teks untuk mode terang
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Review",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                  Row(
                                    children: [
                                      RatingBarIndicator(
                                        rating: widget.rating,
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        direction: Axis.horizontal,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Text(
                                        widget.rating.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "(${widget.count.toString()})",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                          FutureBuilder(
                            future: futureReview,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data.isEmpty) {
                                return const Center(
                                  child: Text('No reviews available.'),
                                );
                              } else {
                                var data = snapshot.data;
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ReviewCard(
                                      name: data[index]['name'],
                                      date: data[index]['updated_at'],
                                      rating:
                                          double.parse(data[index]['rating']),
                                      desc: data[index]['comment'],
                                      pic: data[index]['piclink'],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 8,
                                    );
                                  },
                                  itemCount: data.length,
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: ElevatedButton(
                          //     onPressed: () {},
                          //     style: ButtonStyle(
                          //       backgroundColor:
                          //           MaterialStateProperty.all<Color>(
                          //               Colors.white),
                          //       shape: MaterialStateProperty.all<
                          //           RoundedRectangleBorder>(
                          //         RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(8.0),
                          //           side: const BorderSide(
                          //               color: Color(0xff6571ff)),
                          //         ),
                          //       ),
                          //     ),
                          //     child: Text("See all 2 Review",
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .titleSmall
                          //             ?.copyWith(
                          //               color: const Color(0xff6571ff),
                          //             )),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading) // Only show CircularProgressIndicator when loading
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(
                      0.5), // Adjust the background color and opacity
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.name,
    required this.date,
    required this.rating,
    required this.desc,
    required this.pic,
  });

  final String name;
  final String date;
  final double rating;
  final String desc;
  final String pic;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          pic,
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
                        Text(name,
                            style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          date,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
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
                      rating.toString(),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            ),
            if (desc.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    desc,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
