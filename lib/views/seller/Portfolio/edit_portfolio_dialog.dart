import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clone_freelancer_mobile/controllers/seller_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditPortfolioDialog extends StatefulWidget {
  const EditPortfolioDialog({
    super.key,
    this.onClose,
    required this.futurePortfolio,
  });

  final Function(dynamic)? onClose;
  final Future futurePortfolio;

  @override
  State<EditPortfolioDialog> createState() => _EditPortfolioDialogState();
}

class _EditPortfolioDialogState extends State<EditPortfolioDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final SellerController sellerController = Get.put(SellerController());
  bool updateImage = false;
  bool dataIsLoaded = false;
  int totalImage = 0;
  final _formKey = GlobalKey<FormState>();

  List<File> selectedImages = [];
  List<String> dataImg = [];

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
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: const Text('Edit Portfolio'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: widget.futurePortfolio,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        if (dataIsLoaded == false) {
                          dataImg.clear();
                          final dataPortfolio = snapshot.data['portfolio'];
                          final dataImgPortfolio =
                              snapshot.data['portfolio_img'];
                          titleController.text = dataPortfolio['title'];
                          descController.text = dataPortfolio['description'];

                          for (int i = 0; i < dataImgPortfolio.length; i++) {
                            var linkServicePic = dataImgPortfolio[i]['piclink'];
                            dataImg.add(linkServicePic);
                          }
                          dataIsLoaded = true;
                        }

                        return Column(
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
                                hintText: "Portfolio title",
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
                              controller: descController,
                              decoration: InputDecoration(
                                hintText: "Portfolio Description",
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
                            Text(
                              "Get noticed by the right buyers with visual examples of your services.",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            !updateImage
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              child: GridView.builder(
                                                itemCount: dataImg.length,
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
                                                    (BuildContext context,
                                                        int index) {
                                                  return Center(
                                                    child: FractionallySizedBox(
                                                      widthFactor: 1.0,
                                                      heightFactor: 1.0,
                                                      child: Container(
                                                        color: Colors.grey[300],
                                                        child: Image.network(
                                                          dataImg[index],
                                                          fit: BoxFit.contain,
                                                        ),
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
                                                setState(() {
                                                  updateImage = !updateImage;
                                                });
                                              },
                                              child: const Text(
                                                "Change Image",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
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
                                                      itemCount:
                                                          selectedImages.length,
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
                                                          (BuildContext context,
                                                              int index) {
                                                        return Center(
                                                          child:
                                                              FractionallySizedBox(
                                                            widthFactor: 1.0,
                                                            heightFactor: 1.0,
                                                            child: Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                Positioned.fill(
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                    child: Image
                                                                        .file(
                                                                      selectedImages[
                                                                          index],
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 3,
                                                                  right: 3,
                                                                  child:
                                                                      ClipOval(
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          selectedImages
                                                                              .removeAt(index);
                                                                          totalImage--;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          shape:
                                                                              BoxShape.circle,
                                                                          color:
                                                                              Colors.blueGrey[200],
                                                                        ),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            5),
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              Color(0xff221F1E),
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
                                                "Upload Image",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (updateImage == false) {
                                      final dataTemp =
                                          snapshot.data['portfolio'];

                                      List<String> pathTemp = [];
                                      for (var item in selectedImages) {
                                        pathTemp.add(item.path);
                                      }
                                      await sellerController
                                          .updatePortfolio(
                                            portfolioId:
                                                dataTemp['portfolio_id']
                                                    .toString(),
                                            portfolioTitle:
                                                titleController.text.trim(),
                                            portfolioDesc:
                                                descController.text.trim(),
                                            images: pathTemp,
                                            updateImage: updateImage,
                                          )
                                          .then((value) =>
                                              Navigator.pop(context, true));
                                    } else {
                                      if (selectedImages.isNotEmpty) {
                                        final dataTemp =
                                            snapshot.data['portfolio'];

                                        List<String> pathTemp = [];
                                        for (var item in selectedImages) {
                                          pathTemp.add(item.path);
                                        }
                                        await sellerController
                                            .updatePortfolio(
                                              portfolioId:
                                                  dataTemp['portfolio_id']
                                                      .toString(),
                                              portfolioTitle:
                                                  titleController.text.trim(),
                                              portfolioDesc:
                                                  descController.text.trim(),
                                              images: pathTemp,
                                              updateImage: updateImage,
                                            )
                                            .then((value) =>
                                                Navigator.pop(context, true));
                                      } else {
                                        Get.snackbar(
                                          "Error",
                                          'Portfolio Images cannot be empty',
                                          snackPosition: SnackPosition.TOP,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    }
                                  }
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
      ),
    );
  }
}
