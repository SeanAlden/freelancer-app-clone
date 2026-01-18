import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:clone_freelancer_mobile/constant/globals.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:clone_freelancer_mobile/widgets/loading_indicator.dart';
import 'package:clone_freelancer_mobile/models/language.dart';
import 'package:clone_freelancer_mobile/models/language_suggestion.dart';
import 'package:clone_freelancer_mobile/models/occupation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class SellerReqPage extends StatefulWidget {
  const SellerReqPage({super.key});

  @override
  State<SellerReqPage> createState() => _SellerReqPageState();
}

class _SellerReqPageState extends State<SellerReqPage> {
  int _index = 0;
  final List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController nikNameController = TextEditingController();
  TextEditingController nikGenderController = TextEditingController();
  TextEditingController nikAddressController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  final SellerController sellerController = Get.put(SellerController());

  final box = GetStorage();
  String? selectedLanguage;
  String? selectedProfession;
  String? selectedLevel;
  String gender = 'Male';

  List<String> levels = [
    "Basic",
    "Conversational",
    "Fluent",
    "Native/Bilingual"
  ];

  bool visibility = true;

  List<Languages> listLanguage = [];

  Future<void> _showMyDialog() async {
    String? current;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('Basic'),
                trailing: Radio<String>(
                  value: levels[0],
                  groupValue: current,
                  onChanged: (String? value) {
                    setState(() {
                      levelController.text = value!;
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
              ListTile(
                leading: const Text('Conversational'),
                trailing: Radio<String>(
                  value: levels[1],
                  groupValue: current,
                  onChanged: (String? value) {
                    setState(() {
                      levelController.text = value!;
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
              ListTile(
                leading: const Text('Fluent'),
                trailing: Radio<String>(
                  value: levels[2],
                  groupValue: current,
                  onChanged: (String? value) {
                    setState(() {
                      levelController.text = value!;
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
              ListTile(
                leading: const Text('Native/Bilingual'),
                trailing: Radio<String>(
                  value: levels[3],
                  groupValue: current,
                  onChanged: (String? value) {
                    setState(() {
                      levelController.text = value!;
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  File? profileImage;
  File? ktpImage;
  File? selfieImageWithKTP;

  Future pickImageCamera(int temp) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      File imageTemp = File(image.path);
      if (temp == 0) {
        setState(() => profileImage = imageTemp);
      } else if (temp == 1) {
        setState(() => ktpImage = imageTemp);
      } else {
        setState(() => selfieImageWithKTP = imageTemp);
      }
    } on PlatformException catch (e) {
      Get.snackbar(
        "Error",
        "${'image_pick_fail'.tr}: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future pickImageGallery(int temp) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File imageTemp = File(image.path);
      if (temp == 0) {
        setState(() => profileImage = imageTemp);
      } else if (temp == 1) {
        setState(() => ktpImage = imageTemp);
      } else {
        setState(() => selfieImageWithKTP = imageTemp);
      }
    } on PlatformException catch (e) {
      Get.snackbar(
        "Error",
        "${'image_pick_fail'.tr}: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future showOptions(int temp) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();
              pickImageCamera(temp);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Gallery'),
            onPressed: () {
              Navigator.of(context).pop();
              pickImageGallery(temp);
            },
          ),
        ],
      ),
    );
  }

  void deleteRow(int index) {
    setState(() {
      listLanguage.removeAt(index);
    });
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
  void initState() {
    if (box.read('token') != null) {
      nameController.text = box.read('user')['name'];
    }
    checkReq();
    super.initState();
  }

  final List<String> languages = isoLangs.entries
      .map((entry) => "${entry.value['name']} (${entry.value['nativeName']})")
      .toList();

  List<String> listSkill = [];
  List<String> listUrl = [];

  List<String> listProfession = [
    'Digital Marketing',
    'Graphics & Design',
    'Writing & Translation',
    'Business',
    'Programming & Tech',
    'Music & Audio',
    'Video & Animation',
    'Data',
    'Photography',
    'Lifestyle',
  ];

  List<String> fromList =
      List.generate(51, (index) => (DateTime.now().year - index).toString());

  List<String> toList = [];

  String? selectedFrom;
  String? selectedTo;

  List<String> listOccupation = [];

  final Map<String, bool> _checkedItems = {};
  bool expanded = true;
  final _scrollController = ScrollController();
  List<String> listSubOccupation = [];
  String? tempPic1;
  String? tempPic2;

  Future checkReq() async {
    print('calling');
    try {
      var response = await http
          .get(Uri.parse('${url}freelancer/getFreelancerReq'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var dataFreelancer = data['data'];
        var lsLanguages = data['listlanguages'];
        var lsSkills = data['listskills'];
        var lsUrl = data['listurl'];
        var occ = data['occ'];
        var lsocc = data['listsubocc'];
        setState(() {
          descController.text = dataFreelancer['description'];
          for (var i = 0; i < lsLanguages.length; i++) {
            listLanguage.add(Languages(
              language: lsLanguages[i]['language_name'],
              level: lsLanguages[i]['proficiency_level'],
            ));
          }
          for (var i = 0; i < lsSkills.length; i++) {
            listSkill.add(lsSkills[i]['skill_name']);
          }
          for (var i = 0; i < lsUrl.length; i++) {
            listUrl.add(lsUrl[i]['personalUrl']);
          }
          selectedProfession = occ['category_name'];
          switch (selectedProfession) {
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
            default:
              break;
          }
          selectedFrom = occ['from'];
          int length = DateTime.now().year - int.parse(selectedFrom!) + 1;
          toList = List.generate(
              length, (index) => (DateTime.now().year - index).toString());
          selectedTo = occ['to'];

          List arraySub = [];
          for (var i = 0; i < lsocc.length; i++) {
            arraySub.add(lsocc[i]['subcategory_name']);
          }

          for (var i = 0; i < listOccupation.length; i++) {
            if (arraySub.contains(listOccupation[i])) {
              _checkedItems[listOccupation[i]] = true;
            } else {
              _checkedItems[listOccupation[i]] = false;
            }
          }

          nikController.text = dataFreelancer['identity_number'];
          nikNameController.text = dataFreelancer['identity_name'];
          gender = dataFreelancer['identity_gender'];
          nikAddressController.text = dataFreelancer['identity_address'];
          tempPic1 = dataFreelancer['idPiclink'];
          tempPic2 = dataFreelancer['idsPiclink'];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'seller_request_form'.tr, // Judul AppBar
          style: TextStyle(
            color: Colors.white, // Ganti dengan warna yang diinginkan
            fontSize: 20, // Ukuran teks bisa disesuaikan
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
                      profileImage != null &&
                      listLanguage.isNotEmpty) {
                    setState(() {
                      _index++;
                    });
                  } else if (formKeys[_index].currentState!.validate() &&
                      box.read('pic') != null &&
                      listLanguage.isNotEmpty) {
                    setState(() {
                      _index++;
                    });
                  } else {
                    Get.snackbar(
                      "Error",
                      'fill_required'.tr,
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else if (_index == 1) {
                  listSubOccupation.clear();
                  _checkedItems.forEach((item, isChecked) {
                    if (isChecked) {
                      listSubOccupation.add(item);
                    }
                  });
                  if (formKeys[_index].currentState!.validate() &&
                      selectedFrom != null &&
                      selectedTo != null &&
                      listSubOccupation.isNotEmpty &&
                      selectedProfession != null) {
                    setState(() {
                      _index++;
                    });
                  } else {
                    Get.snackbar(
                      "Error",
                      'fill_required'.tr,
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  if (formKeys[_index].currentState!.validate() &&
                      (ktpImage != null || tempPic1 != null) &&
                      (selfieImageWithKTP != null || tempPic2 != null)) {
                    await sellerController.reqVerification(
                      name: nameController.text.trim(),
                      description: descController.text.trim(),
                      languages: listLanguage,
                      occupations: Occupation(
                          occupation: selectedProfession!,
                          from: selectedFrom!,
                          to: selectedTo!),
                      subcategoryOccupation: listSubOccupation,
                      skills: listSkill,
                      personalUrl: listUrl,
                      niknumber: nikController.text.trim(),
                      nikname: nikNameController.text.trim(),
                      nikgender: gender,
                      nikaddress: nikAddressController.text.trim(),
                      profileImage:
                          profileImage == null ? null : profileImage!.path,
                      idCardImage: ktpImage == null ? null : ktpImage!.path,
                      idCardWithSefieImage: selfieImageWithKTP == null
                          ? null
                          : selfieImageWithKTP!.path,
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      'fill_required'.tr,
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
                  title: const Text('Profile'),
                  content: Form(
                    key: formKeys[0],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'personal_info'.tr,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Divider(),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'profile_picture'.tr,
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
                        Center(
                          child: Stack(
                            children: [
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: box.read('pic') != null
                                      ? Image.network(
                                          box.read('pic'),
                                          fit: BoxFit.cover,
                                        )
                                      : profileImage == null
                                          ? Image.asset(
                                              'assets/images/blank_image.png',
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              profileImage!,
                                              fit: BoxFit.cover,
                                            ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: const Color(0xff858AFF)),
                                  child: IconButton(
                                    icon: const Icon(Icons.camera_alt_outlined,
                                        size: 20),
                                    color: Colors.black,
                                    onPressed: () {
                                      showOptions(0);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'name'.tr,
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
                            return value!.length < 2
                                ? 'name_must_filled'.tr
                                : null;
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'name'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
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
                            return value!.length < 150
                                ? 'user_information_length'.tr
                                : null;
                          },
                          controller: descController,
                          maxLines: 5,
                          maxLength: 500,
                          decoration: InputDecoration(
                            hintText: 'description_hint'.tr,
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
                          height: 16,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'languages'.tr,
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
                        visibility
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                      ),
                                      child: Column(
                                        children: [
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              hint: Text('language'.tr),
                                              items: languages
                                                  .map((String item) =>
                                                      DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(
                                                          item,
                                                          style: GoogleFonts
                                                              .notoSans(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ))
                                                  .toList(),
                                              value: selectedLanguage,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedLanguage = value;
                                                });
                                              },
                                              buttonStyleData: ButtonStyleData(
                                                height: 56,
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              iconStyleData:
                                                  const IconStyleData(
                                                icon: Icon(
                                                  Icons.keyboard_arrow_down,
                                                ),
                                              ),
                                              dropdownStyleData:
                                                  DropdownStyleData(
                                                maxHeight: 250,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                scrollbarTheme:
                                                    ScrollbarThemeData(
                                                  radius:
                                                      const Radius.circular(40),
                                                  thickness:
                                                      MaterialStateProperty.all<
                                                          double>(6),
                                                  thumbVisibility:
                                                      MaterialStateProperty.all<
                                                          bool>(true),
                                                ),
                                              ),
                                              menuItemStyleData:
                                                  const MenuItemStyleData(
                                                height: 40,
                                                padding: EdgeInsets.only(
                                                    left: 22, right: 0),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            readOnly: true,
                                            controller: levelController,
                                            decoration: InputDecoration(
                                              suffixIcon: const Icon(
                                                  Icons.keyboard_arrow_down),
                                              hintText: 'language_level'.tr,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            onTap: _showMyDialog,
                                          ),
                                          Row(
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
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      visibility = false;
                                                    });
                                                  },
                                                  child: Text('cancel'.tr),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (levelController.text !=
                                                            "" &&
                                                        selectedLanguage !=
                                                            null) {
                                                      setState(() {
                                                        listLanguage.add(
                                                          Languages(
                                                            language:
                                                                selectedLanguage
                                                                    .toString(),
                                                            level:
                                                                levelController
                                                                    .text
                                                                    .trim(),
                                                          ),
                                                        );
                                                        languages.remove(
                                                            selectedLanguage);
                                                        visibility = false;
                                                        selectedLanguage = null;
                                                        levelController.clear();
                                                      });
                                                    } else {
                                                      Get.snackbar(
                                                        "Error",
                                                        'language_required'.tr,
                                                        snackPosition:
                                                            SnackPosition.TOP,
                                                        backgroundColor:
                                                            Colors.red,
                                                        colorText: Colors.white,
                                                      );
                                                    }
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .blue), // Warna latar belakang
                                                    foregroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(Colors
                                                                .white), // Warna teks atau ikon
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text('add'.tr),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.30))),
                                child: DataTable(
                                  headingRowColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Colors.grey.withOpacity(0.20)),
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text('language'.tr),
                                    ),
                                    DataColumn(
                                      label: Text('level'.tr),
                                    ),
                                    DataColumn(
                                      label: Text(""),
                                    ),
                                  ],
                                  rows: listLanguage
                                      .map((e) => DataRow(
                                            cells: [
                                              DataCell(
                                                Text(
                                                  e.language,
                                                  style: GoogleFonts.notoSans(),
                                                ),
                                              ),
                                              DataCell(
                                                Text(e.level),
                                              ),
                                              DataCell(
                                                IconButton(
                                                  onPressed: () {
                                                    languages.add(e.language);
                                                    languages.sort();
                                                    deleteRow(listLanguage
                                                        .indexOf(e));
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))
                                      .toList(),
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
                                text: 'add_language'.tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: const Color(0xff6571ff),
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() {
                                      visibility = true;
                                    });
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  state: _index > 1 ? StepState.complete : StepState.indexed,
                  isActive: _index >= 1,
                  title: Text('freelance'.tr),
                  content: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: formKeys[1],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'freelance_info'.tr,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Divider(),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'occupation'.tr,
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
                            hint: Text('profession'.tr),
                            items: listProfession.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            value: selectedProfession,
                            onChanged: (String? value) {
                              setState(() {
                                selectedProfession = value;
                                switch (selectedProfession) {
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
                          height: 8,
                        ),
                        if (selectedProfession != null)
                          ExpansionPanelList(
                            expansionCallback: (panelIndex, isExpanded) {
                              setState(() {
                                expanded = !isExpanded;
                              });
                            },
                            elevation: 1,
                            dividerColor: Colors.grey,
                            expandedHeaderPadding: const EdgeInsets.all(8),
                            children: [
                              ExpansionPanel(
                                canTapOnHeader: true,
                                headerBuilder: (context, isExpanded) {
                                  return Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(selectedProfession!));
                                },
                                body: Container(
                                  height: 200,
                                  padding: const EdgeInsets.all(1),
                                  child: Scrollbar(
                                    radius: const Radius.circular(40),
                                    controller: _scrollController,
                                    thumbVisibility: true,
                                    child: ListView.builder(
                                      controller: _scrollController,
                                      itemCount: listOccupation.length,
                                      itemBuilder: (context, index) {
                                        final item = listOccupation[index];
                                        final isChecked =
                                            _checkedItems[item] ?? false;
                                        return InkWell(
                                          onTap: () {
                                            if (isChecked) {
                                              setState(() {
                                                _checkedItems[item] = false;
                                              });
                                            } else {
                                              if (_checkedItems.values
                                                      .where((value) => value)
                                                      .length <
                                                  5) {
                                                setState(() {
                                                  _checkedItems[item] = true;
                                                });
                                              }
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                              left: 16,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  listOccupation[index],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Checkbox(
                                                  value: isChecked,
                                                  onChanged: (bool? val) {
                                                    if (isChecked) {
                                                      setState(() {
                                                        _checkedItems[item] =
                                                            false;
                                                      });
                                                    } else {
                                                      if (_checkedItems.values
                                                              .where((value) =>
                                                                  value)
                                                              .length <
                                                          5) {
                                                        setState(() {
                                                          _checkedItems[item] =
                                                              true;
                                                        });
                                                      }
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                isExpanded: expanded,
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("From"),
                            const SizedBox(
                              width: 8,
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                buttonStyleData: ButtonStyleData(
                                  height: 56,
                                  padding: const EdgeInsets.only(right: 7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
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
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                ),
                                hint: Text("Year"),
                                items: fromList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
                                value: selectedFrom,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedTo = null;
                                    selectedFrom = value;
                                    int length = DateTime.now().year -
                                        int.parse(value!) +
                                        1;
                                    toList = List.generate(
                                        length,
                                        (index) => (DateTime.now().year - index)
                                            .toString());
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text("To"),
                            const SizedBox(
                              width: 8,
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                buttonStyleData: ButtonStyleData(
                                  height: 56,
                                  padding: const EdgeInsets.only(right: 7),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
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
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                ),
                                hint: Text("Year"),
                                items: toList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
                                value: selectedTo,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedTo = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'skills'.tr,
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
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (listSkill.isEmpty) {
                                        return 'skills_required'.tr;
                                      }
                                      return null;
                                    },
                                    onChanged: (text) {
                                      if (text.endsWith(" ")) {
                                        setState(() {
                                          listSkill.add(text
                                              .replaceFirst(" ", '')
                                              .trim());
                                          skillsController.clear();
                                        });
                                      }
                                    },
                                    controller: skillsController,
                                    decoration: InputDecoration(
                                      hintText: 'skills_hint'.tr,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 10,
                                      children: List.generate(
                                        listSkill.length,
                                        (index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Container(
                                              height: 30,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xFFDEDCF8),
                                                    blurRadius: 3,
                                                    offset: Offset(0,
                                                        3), // Shadow position
                                                  ),
                                                ],
                                              ),
                                              child: Chip(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                ),
                                                deleteIcon: const Icon(
                                                  Icons.clear,
                                                  size: 14,
                                                ),
                                                backgroundColor:
                                                    Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.black
                                                        : Colors.white,
                                                label: Text(
                                                  listSkill[index],
                                                  // style: GoogleFonts.roboto(
                                                  //     color: Colors.black,
                                                  //     textStyle: Theme.of(context)
                                                  //         .textTheme
                                                  //         .titleMedium,
                                                  //     fontWeight: FontWeight.w300),
                                                ),
                                                onDeleted: () {
                                                  setState(() {
                                                    listSkill.removeAt(index);
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'showcase_portfolio_url'.tr,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: urlController,
                          decoration: InputDecoration(
                            hintText: 'portfolio_hint'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (text) {
                            if (text.endsWith(" ")) {
                              setState(() {
                                listUrl.add(text.replaceFirst(" ", '').trim());
                                urlController.clear();
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () async {
                                _launchUrl(listUrl[index]);
                              },
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                style: const TextStyle(color: Colors.blue),
                                listUrl[index],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  setState(() {
                                    listUrl.removeAt(index);
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: listUrl.length,
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
                  title: Text('card'.tr),
                  content: Form(
                    key: formKeys[2],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'id_card'.tr,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Divider(),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'nik_according_to_id_card'.tr,
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
                              return 'id_card_number_required'.tr;
                            }
                            if (value.length != 16) {
                              return 'id_card_number_length'.tr;
                            }
                            if (!value.containsOnlyDigits()) {
                              return 'id_card_number_type'.tr;
                            }
                            return null;
                          },
                          controller: nikController,
                          decoration: InputDecoration(
                            hintText: 'fill_required'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'name_according_to_id_card'.tr,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'id_card_name_required'.tr;
                            }
                            return null;
                          },
                          controller: nikNameController,
                          decoration: InputDecoration(
                            hintText: 'name'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'gender_according_to_id_card'.tr,
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
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                value: 'Male',
                                groupValue: gender,
                                title: Text('male'.tr),
                                onChanged: (value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                value: 'Female',
                                groupValue: gender,
                                title: Text('female'.tr),
                                onChanged: (value) {
                                  setState(() {
                                    gender = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'address_according_to_id_card'.tr,
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
                              return 'id_card_address_required'.tr;
                            }
                            return null;
                          },
                          controller: nikAddressController,
                          decoration: InputDecoration(
                            hintText: 'address'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'id_card_picture'.tr,
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
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 250,
                                child: Container(
                                  color: Colors.grey[300],
                                  child: ClipRRect(
                                      child:
                                          tempPic1 != null && ktpImage == null
                                              ? Image.network(
                                                  tempPic1!,
                                                  fit: BoxFit.cover,
                                                )
                                              : ktpImage == null
                                                  ? Image.asset(
                                                      'assets/images/idcard.png',
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      ktpImage!,
                                                      fit: BoxFit.contain,
                                                    )),
                                ),
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
                                onPressed: () {
                                  showOptions(1);
                                },
                                child: Text(
                                  'upload_card_picture'.tr,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'id_card_picture_with_selfie'.tr,
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
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 250,
                                child: Container(
                                  color: Colors.grey[300],
                                  child: ClipRRect(
                                      child: tempPic2 != null &&
                                              selfieImageWithKTP == null
                                          ? Image.network(
                                              tempPic2!,
                                              fit: BoxFit.cover,
                                            )
                                          : selfieImageWithKTP == null
                                              ? Image.asset(
                                                  'assets/images/selfie.png',
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  selfieImageWithKTP!,
                                                  fit: BoxFit.contain,
                                                )),
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
                                  showOptions(2);
                                },
                                child: Text(
                                  'upload_card_picture_selfie'.tr,
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
              ],
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: _index == 0 ? null : details.onStepCancel,
                      child: Text('back'.tr),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey), // Warna latar belakang
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Warna teks atau ikon
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text('continue'.tr),
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

extension StringExtensions on String {
  bool containsOnlyDigits() {
    final RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(this);
  }
}

class ListLevels {
  static final List<String> levels = [
    'Basic',
    'Conversational',
    'Fluent',
    'Native/Bilingual',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(levels);

    matches.retainWhere((s) => s.contains(query));
    return matches;
  }
}
