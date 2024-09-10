// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clone_freelancer_mobile/core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final UserController userController = Get.put(UserController());
  ModeController modeController = Get.find<ModeController>();
  NavigationController navigationController = Get.find<NavigationController>();
  final box = GetStorage();
  File? profileImage;

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      File imageTemp = File(image.path);
      setState(() {
        profileImage = imageTemp;
        userController.changeProfilePicture(profileImage!.path);
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
      setState(() {
        profileImage = imageTemp;
        userController.changeProfilePicture(profileImage!.path);
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

  Future getReq() async {
    try {
      var response = await http.get(Uri.parse('${url}getRequest'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 201) {
        Get.to(() => const RequestSentPage());
      } else {
        Get.to(() => const SellerReqPage());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getUserType() async {
    try {
      var response = await http.get(Uri.parse('${url}getUserType'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        setState(() {
          box.write('user', data['user']);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    print('profile_type');
    super.initState();
    getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Profile"),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[100],
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 20.0),
                      alignment: Alignment.topCenter,
                      height: 235.0,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(30, 8),
                          bottomRight: Radius.elliptical(30, 8),
                        ),
                        color: Color(0xff4259E2),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              profileImage != null
                                  ? SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.file(
                                          profileImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : box.read('pic') != null
                                      ? SizedBox(
                                          width: 120,
                                          height: 120,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                              box.read('pic'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: 120,
                                          height: 120,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.asset(
                                              'assets/images/blank_image.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    if (box.read('token') == null) {
                                      Get.to(() => const LoginPage());
                                    } else {
                                      showOptions();
                                    }
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
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
                          const SizedBox(
                            height: 8,
                          ),
                          box.read('token') != null
                              ? Column(
                                  children: [
                                    Text(
                                      box.read('user')['name'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    Text(
                                      box.read('user')['email'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ],
                                )
                              : Text(
                                  "Guest",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                        ],
                      ),
                    ),
                    if (box.read('token') != null)
                      box.read('user')['profile_type'] == 'freelancer'
                          ? Container(
                              padding: const EdgeInsets.only(
                                  top: 215, left: 16, right: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(32, 8, 32, 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Seller Mode",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Obx(() {
                                        return Switch(
                                          value: modeController.mode.value,
                                          activeColor: const Color(0xff6571ff),
                                          onChanged: (bool value) {
                                            setState(() {
                                              navigationController
                                                  .selectedIndex.value = 0;
                                              modeController.mode.value = value;
                                            });
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                  ],
                ),
                if (modeController.mode.value == true)
                  Column(
                    children: [
                      Container(
                        color: Colors.grey[100],
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "Selling",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(box.read('pic'));
                          Get.to(() => const SellerProfilePage())?.then(
                            (_) {
                              setState(() {});
                            },
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.2),
                              top: BorderSide(color: Colors.grey, width: 0.2),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 8,
                                    ),
                                    child: Icon(
                                      Icons.person_outline,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text("My Profile"),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border(
                      //       bottom: BorderSide(color: Colors.grey, width: 0.2),
                      //     ),
                      //   ),
                      //   padding: const EdgeInsets.all(16),
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Padding(
                      //             padding: EdgeInsets.only(
                      //               right: 8,
                      //             ),
                      //             child: Icon(
                      //               Icons.book_outlined,
                      //               size: 25,
                      //               color: Colors.grey,
                      //             ),
                      //           ),
                      //           Text("Manage Services"),
                      //         ],
                      //       ),
                      //       Icon(
                      //         Icons.arrow_forward_ios_outlined,
                      //         size: 20,
                      //         color: Colors.grey,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border(
                      //       bottom: BorderSide(color: Colors.grey, width: 0.2),
                      //     ),
                      //   ),
                      //   padding: const EdgeInsets.all(16),
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Padding(
                      //             padding: EdgeInsets.only(
                      //               right: 8,
                      //             ),
                      //             child: Icon(
                      //               Icons.wallet_outlined,
                      //               size: 25,
                      //               color: Colors.grey,
                      //             ),
                      //           ),
                      //           Text("Earnings"),
                      //         ],
                      //       ),
                      //       Icon(
                      //         Icons.arrow_forward_ios_outlined,
                      //         size: 20,
                      //         color: Colors.grey,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                Column(
                  children: [
                    if (box.read('token') == null)
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const SignUpPage());
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      right: 8,
                                    ),
                                    child: Icon(
                                      Icons.add_circle_outline,
                                      size: 25,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    "Sign Up",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Colors.green,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const LoginPage());
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 8,
                                    ),
                                    child: Icon(
                                      Icons.login_outlined,
                                      size: 25,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "Log In",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (box.read('token') != null)
                      Column(
                        children: [
                          Container(
                            color: Colors.grey[100],
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  "Settings",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const AccountPage())?.then(
                                (_) {
                                  setState(() {});
                                },
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                  top: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Icon(
                                          Icons.manage_accounts_outlined,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text("Edit Profile"),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const ChangePasswordPage());
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Icon(
                                          Icons.password_outlined,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text("Change Password"),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          box.read('user')['profile_type'] == 'client'
                              ? GestureDetector(
                                  onTap: () {
                                    getReq();
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 0.2),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: 8,
                                              ),
                                              child: Icon(
                                                Icons.store_outlined,
                                                size: 25,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text("Become a Seller"),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const WalletPage());
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Icon(
                                          Icons.account_balance_wallet_outlined,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text("Wallet"),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const SavedServicesPage());
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Icon(
                                          Icons.archive_outlined,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text("Saved Service"),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const SupportListPage());
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: Icon(
                                          Icons.support,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text("Support"),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (box.read('token') != null)
                      GestureDetector(
                        onTap: () async {
                          await authenticationController.logout();
                          setState(() {
                            navigationController.selectedIndex.value = 0;
                            modeController.mode.value = false;
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom:
                                  BorderSide(color: Colors.grey, width: 0.2),
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 8,
                                ),
                                child: Icon(
                                  Icons.logout_outlined,
                                  size: 25,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                "Log Out",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
