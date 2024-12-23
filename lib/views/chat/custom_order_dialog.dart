import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clone_freelancer_mobile/controllers/chat_controller.dart';
import 'package:clone_freelancer_mobile/controllers/custom_order_controller.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:clone_freelancer_mobile/views/seller/Service/map_picker_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomOrderDialog extends StatefulWidget {
  const CustomOrderDialog({super.key, required this.chatId, this.onClose});
  final int chatId;
  final Function(dynamic)? onClose;

  @override
  State<CustomOrderDialog> createState() => _CustomOrderDialogState();
}

class _CustomOrderDialogState extends State<CustomOrderDialog> {
  late Future<List<DropdownMenuItem<String>>> futureDropdownItem;
  final SellerController sellerController = Get.put(SellerController());
  final CustomOrderController customOrderController =
      Get.put(CustomOrderController());
  final ChatController chatController = Get.put(ChatController());
  String? selectedService;
  String? selectedServiceType;
  DateTime? selectedDateTime;
  var selectedLoc;
  final _formKey = GlobalKey<FormState>();

  TextEditingController desc = TextEditingController();
  TextEditingController dev = TextEditingController();
  TextEditingController rev = TextEditingController();
  TextEditingController exp = TextEditingController();
  TextEditingController price = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureDropdownItem = sellerController.getDropdownItem('all');
  }

  Future getDropdown(String type) async {
    futureDropdownItem = sellerController.getDropdownItem(type);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
       // mengatur title page
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'create_offer'.tr, // Judul AppBar
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
          ),
        ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'select_service_type'.tr,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextSpan(
                          text: "*",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButtonFormField2<String>(
                      value: selectedServiceType,
                      isExpanded: true,
                      hint: Text('select_service_type'.tr),
                      items: [
                        DropdownMenuItem(
                          value: 'Digital Service',
                          child: Text('digital_service'.tr),
                        ),
                        DropdownMenuItem(
                          value: 'On-Site Service',
                          child: Text('on_site_service'.tr),
                        ),
                      ],
                      onChanged: (String? value) {
                        selectedService = null;
                        selectedDateTime = null;
                        selectedLoc = null;
                        getDropdown(value!);
                        setState(() {
                          selectedServiceType = value;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        padding: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                        ),
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility:
                              MaterialStateProperty.all<bool>(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        padding: EdgeInsets.only(left: 22, right: 0),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'select_service_type_required'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  if (selectedServiceType == 'On-Site Service')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'select_date_time'.tr,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextSpan(
                                text: "*",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.red,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (selectedDateTime != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(selectedDateTime.toString()),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () async {
                              DateTime? dateTime = await showOmniDateTimePicker(
                                  context: context);
                              setState(() {
                                selectedDateTime = dateTime;
                              });
                            },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color(0xff6571ff),
                              ),
                            ),
                            child: Text(
                              'select_date_time'.tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'select_address'.tr,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              TextSpan(
                                text: "*",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.red,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (selectedLoc != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(selectedLoc['address']),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () async {
                              if (await Permission
                                  .location.isPermanentlyDenied) {
                                openAppSettings();
                              } else {
                                await Permission.location.request();
                                var position = await GeolocatorPlatform.instance
                                    .getCurrentPosition(
                                  locationSettings: const LocationSettings(
                                    accuracy: LocationAccuracy.high,
                                  ),
                                );

                                var result = await Get.to(
                                  () => MapPickerLocation(
                                    position: LatLng(
                                      position.latitude,
                                      position.longitude,
                                    ),
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    selectedLoc = result;
                                  });
                                }
                              }
                            },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Color(0xff6571ff),
                              ),
                            ),
                            child: Text(
                              'select_address'.tr,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'select_a_service'.tr,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextSpan(
                          text: "*",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  FutureBuilder<List<DropdownMenuItem<String>>>(
                    future: futureDropdownItem,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Loading indicator while waiting for data
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return Text(
                            'no_data_available'.tr); // Placeholder when no data is available
                      } else {
                        return DropdownButtonHideUnderline(
                          child: DropdownButtonFormField2<String>(
                            value: selectedService,
                            isExpanded: true,
                            hint: Text('select_service'.tr),
                            items: snapshot.data,
                            onChanged: (String? value) {
                              setState(() {
                                selectedService = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              padding: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility:
                                    MaterialStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              padding: EdgeInsets.only(left: 22, right: 0),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'please_select_service'.tr;
                              }
                              return null;
                            },
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'description'.tr,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextSpan(
                          text: "*",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    maxLines: 5,
                    controller: desc,
                    decoration: InputDecoration(
                      hintText: 'describe_offer'.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'description_required'.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'delivery_days'.tr,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  TextSpan(
                                    text: "*",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.red,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: dev,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'delivery_day_required'.tr;
                                      } else if (value == '0') {
                                        return 'delivery_day_morethan_zero'.tr;
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'number_of_revision'.tr,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  TextSpan(
                                    text: "*",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: Colors.red,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: rev,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'revision_required'.tr;
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'expiration_time'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: exp,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'price'.tr,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextSpan(
                          text: "*",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.red,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Text('IDR'),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: price,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'price_is_required'.tr;
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blue), // Warna latar belakang
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Warna teks atau ikon
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (selectedServiceType == 'On-Site Service') {
                            if (selectedDateTime != null &&
                                selectedLoc != null) {
                              final customId =
                                  await customOrderController.createCustomOrder(
                                serviceId: selectedService!,
                                description: desc.text.trim(),
                                price: price.text.trim(),
                                revision: rev.text.trim(),
                                deliveryDays: dev.text.trim(),
                                expiration: exp.text.isNotEmpty
                                    ? DateTime.now().add(
                                        Duration(
                                          days: int.parse(
                                            exp.text.trim(),
                                          ),
                                        ),
                                      )
                                    : null,
                                onsiteDate: selectedDateTime,
                                latlng: selectedLoc != null
                                    ? LatLng(
                                        selectedLoc['lat'], selectedLoc['lng'])
                                    : null,
                                loc: selectedLoc != null
                                    ? selectedLoc['address']
                                    : null,
                              );
                              await chatController
                                  .customOrderChat(
                                    widget.chatId,
                                    customId,
                                  )
                                  .then(
                                      (value) => Navigator.pop(context, true));
                            } else {
                              Get.snackbar(
                                "Error",
                                'Address and DateTime cannot be empty',
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          } else {
                            final customId =
                                await customOrderController.createCustomOrder(
                              serviceId: selectedService!,
                              description: desc.text.trim(),
                              price: price.text.trim(),
                              revision: rev.text.trim(),
                              deliveryDays: dev.text.trim(),
                              expiration: exp.text.isNotEmpty
                                  ? DateTime.now().add(
                                      Duration(
                                        days: int.parse(
                                          exp.text.trim(),
                                        ),
                                      ),
                                    )
                                  : null,
                              onsiteDate: null,
                              latlng: null,
                              loc: null,
                            );
                            await chatController
                                .customOrderChat(
                                  widget.chatId,
                                  customId,
                                )
                                .then((value) => Navigator.pop(context, true));
                          }
                        }
                      },
                      child: Text(
                        'submit_offer'.tr,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
