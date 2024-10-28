import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddPortfolioDialog extends StatefulWidget {
  const AddPortfolioDialog({super.key, this.onClose});
  final Function(dynamic)? onClose;

  @override
  State<AddPortfolioDialog> createState() => _AddPortfolioDialogState();
}

class _AddPortfolioDialogState extends State<AddPortfolioDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int totalImage = 0;
  List<File> selectedImages = [];
  final SellerController sellerController = Get.put(SellerController());
  final _formKey = GlobalKey<FormState>();

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
            "Add Portfolio", // Judul AppBar
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
                  Text(
                    'Title',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Portfolio title.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your portfolio title.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    maxLines: 5,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: "Describe your portfolio.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your portfolio description.';
                      }
                      return null;
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
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
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
                                  physics: const NeverScrollableScrollPhysics(),
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
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue), // Warna latar belakang
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white), // Warna teks atau ikon
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Choose Image",
                          ),
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
                        if (_formKey.currentState!.validate() &&
                            selectedImages.isNotEmpty) {
                          List<String> pathTemp = [];
                          for (var item in selectedImages) {
                            pathTemp.add(item.path);
                          }
                          await sellerController
                              .addPortfolio(
                                title: titleController.text.trim(),
                                desc: descriptionController.text.trim(),
                                images: pathTemp,
                              )
                              .then((value) => Navigator.pop(context, true));
                        } else if (selectedImages.isEmpty) {
                          Get.snackbar(
                            "Error",
                            'Portfolio Images cannot be empty',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: const Text(
                        "Add Portfolio",
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
