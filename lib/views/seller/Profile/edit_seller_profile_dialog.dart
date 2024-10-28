import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:clone_freelancer_mobile/models/language.dart';
import 'package:clone_freelancer_mobile/models/language_suggestion.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EditSellerProfileDialog extends StatefulWidget {
  const EditSellerProfileDialog({
    super.key,
    this.onClose,
    required this.futureAbout,
  });

  final Function(dynamic)? onClose;
  final Future futureAbout;

  @override
  State<EditSellerProfileDialog> createState() =>
      _EditSellerProfileDialogState();
}

class _EditSellerProfileDialogState extends State<EditSellerProfileDialog> {
  final SellerController sellerController = Get.put(SellerController());
  TextEditingController userInformation = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  String? selectedLanguage;
  List<Languages> listLanguage = [];
  List<String> listSkill = [];
  List<String> listUrl = [];

  final List<String> languages = isoLangs.entries
      .map((entry) => "${entry.value['name']} (${entry.value['nativeName']})")
      .toList();

  List<String> levels = [
    "Basic",
    "Conversational",
    "Fluent",
    "Native/Bilingual"
  ];

  void deleteRow(int index) {
    setState(() {
      listLanguage.removeAt(index);
    });
  }

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
            "Edit Seller Profile", // Judul AppBar
            style: TextStyle(
              color: Colors.white, // Ganti dengan warna yang diinginkan
              fontSize: 20, // Ukuran teks bisa disesuaikan
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: widget.futureAbout,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final data = snapshot.data;
                      if (userInformation.text.isEmpty) {
                        userInformation.text =
                            data['freelancer']['description'];
                      }
                      if (listLanguage.isEmpty) {
                        for (var i = 0; i < data['languages'].length; i++) {
                          listLanguage.add(
                            Languages(
                              language: data['languages'][i]['language_name'],
                              level: data['languages'][i]['proficiency_level'],
                            ),
                          );
                        }
                      }
                      if (listSkill.isEmpty) {
                        for (var i = 0; i < data['skills'].length; i++) {
                          listSkill.add(data['skills'][i]['skill_name']);
                        }
                      }
                      if (listUrl.isEmpty) {
                        for (var i = 0; i < data['personalUrl'].length; i++) {
                          listUrl.add(data['personalUrl'][i]['personalUrl']);
                        }
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "User Information",
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
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'User Information is required';
                              } else if (value.length < 150) {
                                return 'Please enter at least 150 characters';
                              }
                              return null;
                            },
                            controller: userInformation,
                            maxLines: 5,
                            maxLength: 500,
                            decoration: InputDecoration(
                              hintText: "Please enter user information",
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
                                  text: "Languages",
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
                                          hint: const Text("Language"),
                                          items: languages
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: GoogleFonts
                                                          .notoSans(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                            ),
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 250,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: MaterialStateProperty
                                                  .all<double>(6),
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
                                          hintText: "Language Level",
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
                                              onPressed: () {
                                                setState(() {
                                                  selectedLanguage = null;
                                                  levelController.clear();
                                                });
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
                                              child: const Text("Cancel"),
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
                                                    selectedLanguage != null) {
                                                  setState(() {
                                                    listLanguage.add(
                                                      Languages(
                                                        language:
                                                            selectedLanguage
                                                                .toString(),
                                                        level: levelController
                                                            .text
                                                            .trim(),
                                                      ),
                                                    );
                                                    languages.remove(
                                                        selectedLanguage);

                                                    selectedLanguage = null;
                                                    levelController.clear();
                                                  });
                                                } else {
                                                  Get.snackbar(
                                                    "Error",
                                                    "Languages field can't be empty",
                                                    snackPosition:
                                                        SnackPosition.TOP,
                                                    backgroundColor: Colors.red,
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
                                              child: const Text("Add"),
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
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Colors.grey.withOpacity(0.30))),
                                  child: DataTable(
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) =>
                                                Colors.grey.withOpacity(0.20)),
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text("Language"),
                                      ),
                                      DataColumn(
                                        label: Text("Level"),
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
                                                    style:
                                                        GoogleFonts.notoSans(),
                                                  ),
                                                ),
                                                DataCell(
                                                  Text(e.level),
                                                ),
                                                DataCell(
                                                  IconButton(
                                                    onPressed: () {
                                                      if (listLanguage.length !=
                                                          1) {
                                                        languages
                                                            .add(e.language);
                                                        languages.sort();
                                                        deleteRow(listLanguage
                                                            .indexOf(e));
                                                      } else {
                                                        Get.snackbar(
                                                          "Error",
                                                          "List Languages can't be empty",
                                                          snackPosition:
                                                              SnackPosition.TOP,
                                                          backgroundColor:
                                                              Colors.red,
                                                          colorText:
                                                              Colors.white,
                                                        );
                                                      }
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
                            height: 16,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Skills",
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
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      validator: (value) {
                                        if (listSkill.isEmpty) {
                                          return 'Skill cannot be empty.';
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
                                        hintText: "Separate Tags with 'space'",
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
                                                  borderRadius:
                                                      BorderRadius.all(
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
                                                    if (listSkill.length != 1) {
                                                      setState(() {
                                                        listSkill
                                                            .removeAt(index);
                                                      });
                                                    } else {
                                                      Get.snackbar(
                                                        "Error",
                                                        "List Skill can't be empty",
                                                        snackPosition:
                                                            SnackPosition.TOP,
                                                        backgroundColor:
                                                            Colors.red,
                                                        colorText: Colors.white,
                                                      );
                                                    }
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
                            "Showcase portfolio Url",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: urlController,
                            decoration: InputDecoration(
                              hintText: "End input with 'space' to add url",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onChanged: (text) {
                              if (text.endsWith(" ")) {
                                setState(() {
                                  listUrl
                                      .add(text.replaceFirst(" ", '').trim());
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
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemCount: listUrl.length,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
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
                              onPressed: () async {
                                await sellerController
                                    .updateSellerProfile(
                                      description: userInformation.text.trim(),
                                      languages: listLanguage,
                                      skills: listSkill,
                                      personalUrl: listUrl,
                                    )
                                    .then((value) =>
                                        Navigator.pop(context, true));
                              },
                              child: const Text(
                                "Submit",
                              ),
                            ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
