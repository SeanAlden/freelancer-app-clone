// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clone_freelancer_mobile/constant/globals.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:clone_freelancer_mobile/models/currency.dart';
import 'package:clone_freelancer_mobile/models/package.dart';
import 'package:clone_freelancer_mobile/views/seller/Service/map_picker_page.dart';
import 'package:clone_freelancer_mobile/widgets/loading_indicator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  bool customOrder = false;
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedType;
  int _index = 0;
  LatLng? locLatLng;
  String selectedCityCountry = '';
  int totalImage = 0;

  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  final SellerController sellerController = Get.put(SellerController());
  List<File> selectedImages = [];

  List<String> listOccupation = [];
  List<Package> listPackage = [];

  final formKeyDialog = GlobalKey<FormState>();
  String title = '';
  String desc = '';
  int price = 0;
  int deliveryDays = 0;
  int revision = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickMultiImage(
        imageQuality: 100,
        maxHeight: 1000,
        maxWidth: 1000,
      );
      List<XFile> xfilePick = image;
      if (xfilePick.length + totalImage > 5) {
        Get.snackbar(
          "Error",
          'Cannot select more than 5 images',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      setState(() {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
            totalImage++;
          }
        } else {
          return;
        }
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

  Future<void> _getAddressFromLatLng(
      double varlatitude, double varlongitude) async {
    await placemarkFromCoordinates(varlatitude, varlongitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        selectedCityCountry =
            '${place.subAdministrativeArea}, ${place.country}';
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Package'),
          content: Form(
            key: formKeyDialog,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: "Input Your Package Title.",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      title = value!;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Package Description",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    maxLines: 5,
                    maxLength: 600,
                    decoration: InputDecoration(
                      hintText: "Input Your Package Description.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onSaved: (value) {
                      desc = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      hintText: "Input Your Package Price.",
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      price = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Delivery Days',
                      hintText: "Input Your Package Delivery Days.",
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      deliveryDays = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Revision',
                      hintText: "Input How Much You Accept Revision.",
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      revision = int.parse(value!);
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKeyDialog.currentState!.validate()) {
                  formKeyDialog.currentState!.save();
                  // Use the data (title, description, price, deliveryDays) as needed
                  setState(() {
                    listPackage.add(
                      Package(
                        id: null,
                        title: title,
                        desc: desc,
                        price: price,
                        deliveryDays: deliveryDays,
                        revision: revision,
                      ),
                    );

                    title = '';
                    desc = '';
                    price = 0;
                    deliveryDays = 0;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Add Service Form",
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Stepper(
              type: StepperType.horizontal,
              currentStep: _index,
              onStepTapped: (index) {
                setState(() {
                  _index = index;
                });
              },
              onStepCancel: () {
                if (_index != 0) {
                  setState(() {
                    _index--;
                  });
                }
              },
              onStepContinue: () async {
                if (_index == 0) {
                  if (formKeys[_index].currentState!.validate() &&
                      selectedType != null &&
                      selectedCategory != null &&
                      selectedSubCategory != null) {
                    if (selectedType == 'On-Site Service' &&
                        locLatLng != null) {
                      setState(() {
                        _index++;
                      });
                    } else if (selectedType != 'On-Site Service') {
                      setState(() {
                        _index++;
                      });
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please fill out all required fields",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } else {
                    Get.snackbar(
                      "Error",
                      "Please fill out all required fields",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else if (_index == 1) {
                  if (formKeys[_index].currentState!.validate() &&
                      selectedImages.isNotEmpty) {
                    setState(() {
                      _index++;
                    });
                  } else {
                    Get.snackbar(
                      "Error",
                      "Please fill out all required fields",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  if (formKeys[_index].currentState!.validate() &&
                      listPackage.isNotEmpty) {
                    List<String> pathTemp = [];
                    for (var item in selectedImages) {
                      pathTemp.add(item.path);
                    }
                    await sellerController.reqPackageVerification(
                      type: selectedType!,
                      category: selectedCategory!,
                      subCategory: selectedSubCategory!,
                      location: selectedCityCountry,
                      title: titleController.text.trim(),
                      desc: descController.text.trim(),
                      images: pathTemp,
                      customOrder: customOrder,
                      packages: listPackage,
                      position: locLatLng,
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      "Please fill out all required fields",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              },
              steps: [
                Step(
                  state: _index > 0 ? StepState.complete : StepState.indexed,
                  isActive: _index >= 0,
                  title: const Text('Category'),
                  content: Form(
                    key: formKeys[0],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Service Type",
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
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: const Text("Select Service Type"),
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'Digital Service',
                                child: Text("Digital Service"),
                              ),
                              DropdownMenuItem<String>(
                                value: 'On-Site Service',
                                child: Text("On-Site Service"),
                              ),
                            ],
                            value: selectedType,
                            onChanged: (String? value) {
                              setState(() {
                                selectedType = value;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 56,
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
                              maxHeight: 250,
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
                              height: 40,
                              padding: EdgeInsets.only(left: 22, right: 0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (selectedType == 'On-Site Service')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Location",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
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
                              Column(
                                children: [
                                  locLatLng == null
                                      ? const Center(
                                          child: Text(
                                            'Sorry location not selected!!',
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            '$selectedCityCountry\n$locLatLng',
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (await Permission
                                            .location.isPermanentlyDenied) {
                                          openAppSettings();
                                        } else {
                                          await Permission.location.request();
                                          var position =
                                              await GeolocatorPlatform.instance
                                                  .getCurrentPosition(
                                            locationSettings:
                                                const LocationSettings(
                                              accuracy: LocationAccuracy.high,
                                            ),
                                          );

                                          var result = await Get.to(
                                            () => MapPicker(
                                              position: LatLng(
                                                position.latitude,
                                                position.longitude,
                                              ),
                                            ),
                                          );
                                          if (result != null) {
                                            setState(() {
                                              locLatLng = result;
                                              _getAddressFromLatLng(
                                                locLatLng!.latitude,
                                                locLatLng!.longitude,
                                              );
                                            });
                                          }
                                        }
                                      },
                                      child: const Text(
                                        "Select Location",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Category",
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
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: const Text("Select Category"),
                            items: listProfession.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            value: selectedCategory,
                            onChanged: (String? value) {
                              setState(() {
                                selectedSubCategory = null;
                                selectedCategory = value;
                                switch (selectedCategory) {
                                  case 'Digital Marketing':
                                    listOccupation = listDigitalMarketing;
                                    break;
                                  case 'Graphics & Design':
                                    listOccupation = listGraphicsAndDesign;
                                    break;
                                  case 'Writing & Translation':
                                    listOccupation = listWritingAndTranslation;
                                    break;
                                  case 'Business':
                                    listOccupation = listBussines;
                                    break;
                                  case 'Programming & Tech':
                                    listOccupation = listProgrammingAndTech;
                                    break;
                                  case 'Music & Audio':
                                    listOccupation = listMusicAndAudio;
                                    break;
                                  case 'Video & Animation':
                                    listOccupation = listVideoAndAudio;
                                    break;
                                  case 'Data':
                                    listOccupation = listData;
                                    break;
                                  case 'Photography':
                                    listOccupation = listPhotography;
                                    break;
                                  case 'Lifestyle':
                                    listOccupation = listLifestyle;
                                    break;
                                  case 'Other':
                                    listOccupation = listOther;
                                    break;
                                  default:
                                    break;
                                }
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 56,
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
                              maxHeight: 250,
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
                              height: 40,
                              padding: EdgeInsets.only(left: 22, right: 0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (selectedCategory != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Sub-Category",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
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
                              DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: const Text("Select Sub-Category"),
                                  items: listOccupation
                                      .map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                  value: selectedSubCategory,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedSubCategory = value;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 56,
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
                                    maxHeight: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness:
                                          MaterialStateProperty.all<double>(6),
                                      thumbVisibility:
                                          MaterialStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 22, right: 0),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                Step(
                  state: _index > 1 ? StepState.complete : StepState.indexed,
                  isActive: _index >= 1,
                  title: const Text('Overview'),
                  content: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: formKeys[1],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Title",
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
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "What will you do",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          controller: titleController,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Description",
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
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Description is required';
                            }
                            return null;
                          },
                          controller: descController,
                          maxLines: 5,
                          maxLength: 1200,
                          decoration: InputDecoration(
                            hintText: "Please enter brief description",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) {
                            return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    transform: Matrix4.translationValues(
                                        0, double.minPositive, 0),
                                    child: Text("$currentLength/$maxLength"),
                                  ),
                                ]);
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
                                text: "Image ($totalImage/5)",
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
                        Text(
                          "Get noticed by the right buyers with visual examples of your services.",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: selectedImages.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'Sorry nothing selected!!',
                                        ),
                                      )
                                    : GridView.builder(
                                        itemCount: selectedImages.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Center(
                                            child: FractionallySizedBox(
                                              widthFactor: 1.0,
                                              heightFactor: 1.0,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Positioned.fill(
                                                    child: Container(
                                                      color: Colors.grey[300],
                                                      child: Image.file(
                                                        selectedImages[index],
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 3,
                                                    right: 3,
                                                    child: ClipOval(
                                                      child: InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedImages
                                                                .removeAt(
                                                                    index);
                                                            totalImage--;
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors
                                                                .blueGrey[200],
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 16,
                                                            color: Color(
                                                                0xff221F1E),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  pickImageGallery();
                                },
                                child: const Text(
                                  "Choose Image",
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  state: _index > 2 ? StepState.complete : StepState.indexed,
                  isActive: _index >= 2,
                  title: const Text('Scope'),
                  content: Form(
                    key: formKeys[2],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Custom Order",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Switch(
                              // This bool value toggles the switch.
                              value: customOrder,
                              activeColor: const Color(0xff6571ff),
                              onChanged: (bool value) {
                                // This is called when the user toggles the switch.
                                setState(() {
                                  customOrder = value;
                                });
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Package & Price",
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
                              width: 8,
                            ),
                            InkWell(
                              onTap: () {
                                if (listPackage.length >= 3) {
                                  Get.snackbar(
                                    "Error",
                                    'Cannot create more than 3 package',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                } else {
                                  _dialogBuilder(context);
                                }
                              },
                              child: const Icon(
                                Icons.add,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        // listPackage.isEmpty
                        //     ? SizedBox(
                        //         height: 16,
                        //       )
                        //     :
                        Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: GridView.builder(
                                    itemCount: listPackage.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        margin: EdgeInsets.zero,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Stack(
                                          children: [
                                            InkWell(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      listPackage[index].title,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(Icons
                                                            .access_time_outlined),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          "${listPackage[index].deliveryDays} Days",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        listPackage[index].desc,
                                                        maxLines: 5,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 4,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        CurrencyFormat
                                                            .convertToIdr(
                                                                listPackage[
                                                                        index]
                                                                    .price,
                                                                2),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {},
                                            ),
                                            Positioned(
                                              top: 3,
                                              right: 3,
                                              child: ClipOval(
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      listPackage
                                                          .removeAt(index);
                                                      totalImage--;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          Colors.blueGrey[200],
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 16,
                                                      color: Color(0xff221F1E),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: _index == 0 ? null : details.onStepCancel,
                      child: const Text('Back'),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Continue'),
                    ),
                  ],
                );
              },
            ),
            Obx(
              () {
                return sellerController.isLoading.value
                    ? LoaderTransparent(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      )
                    : Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
