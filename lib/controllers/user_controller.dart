// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:clone_freelancer_mobile/views/User/navigation_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class UserController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;
  final box = GetStorage();
  late String _localPath;
  TargetPlatform platform = TargetPlatform.android;

  Future sendIssue({
    required String subject,
    required String issue,
    required String? orderId,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'subject': subject,
        'issue': issue,
        if (orderId != null) 'order_id': orderId,
      };

      var response = await http.post(
        Uri.parse('${url}sendIssue'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar(
          "Success",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAll(() => const NavigationPage());
        });
      } else {
        isLoading.value = false;
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

  Future fetchAllReportMessage({
    required String reportId,
  }) async {
    try {
      var response = await http.get(
        Uri.parse('${url}getTicketMessage/$reportId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return data;
      } else {
        isLoading.value = false;
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

  Future sendReportMessage({
    required String reportId,
    required String message,
  }) async {
    try {
      var data = {
        'report_id': reportId,
        'message': message,
      };

      var response = await http.post(
        Uri.parse('${url}sendTicketMessage'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );
      if (response.statusCode != 200) {
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

  Future getListSupportTicket() async {
    try {
      var response = await http.get(Uri.parse('${url}listTicket'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return data;
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

  Future changeProfilePicture(String profilePicture) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}changeProfilePicture'),
      )
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath(
            'profilePicture', profilePicture));

      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var piclink = json.decode(respStr)['picture'];
        if (piclink != null) {
          piclink = url.replaceFirst('/api/', '') + piclink;
          box.write('pic', piclink);
        }
        Get.snackbar(
          "Success",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future changeUserData({
    required String name,
    required String email,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'name': name,
        'email': email,
      };

      var response = await http.post(
        Uri.parse('${url}changeUserData'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        print(box.read('user'));
        Map<String, dynamic> userData = box.read('user');
        userData['name'] = name;
        userData['email'] = email;
        box.write('user', userData);

        Get.snackbar(
          "Success",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        isLoading.value = false;
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

  Future changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'current_password': currentPassword,
        'new_password': newPassword,
      };

      var response = await http.post(
        Uri.parse('${url}changePassword'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar(
          "Success",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => NavigationPage());
      } else {
        isLoading.value = false;
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

  Future fetchDataSeller({required String sellerId}) async {
    try {
      var response = await http
          .get(Uri.parse('${url}fetchDataSeller/$sellerId'), headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future cancelOrder({required String orderId}) async {
    try {
      var response = await http
          .post(Uri.parse('${url}midtrans/payment/cancel/$orderId'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future cancelRefundOrder({required String orderId}) async {
    try {
      var response = await http
          .post(Uri.parse('${url}midtrans/payment/refund/$orderId'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getBalance() async {
    try {
      var response = await http.get(Uri.parse('${url}getBalance'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
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

  Future getTransaction() async {
    try {
      var response =
          await http.get(Uri.parse('${url}getTransaction'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return data;
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

  Future getDownload({required String orderId}) async {
    try {
      var response = await http.get(
          Uri.parse(
            '${url}download-file/$orderId',
          ),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${box.read('token')}',
          });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        String randomName = Uuid().v4();
        if (await Permission.storage.isPermanentlyDenied) {
          openAppSettings();
        } else {
          await Permission.storage.request();
          await _prepareSaveDir();
          try {
            await Dio()
                .download(data['fileUrl'],
                    "$_localPath/$randomName.${data['fileExtension']}")
                .then(
                  (value) => Get.snackbar(
                    "Success",
                    'Download Complete',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  ),
                );
          } catch (e) {
            Get.snackbar(
              "Download Failed",
              e.toString(),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print('Path: $_localPath');
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/storage/emulated/0/Download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  Future completeOrder({required String orderId}) async {
    try {
      var response =
          await http.post(Uri.parse('${url}completeOrder/$orderId'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
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

  Future sendReview({
    required String orderId,
    required String freelancerId,
    required String rating,
    required String comment,
    required String serviceId,
    required String broadcast,
  }) async {
    try {
      var data = {
        'order_id': orderId,
        'freelancer_id': freelancerId,
        'rating': rating,
        'comment': comment,
        'service_id': serviceId,
        'broadcast': broadcast,
      };
      var response = await http.post(
        Uri.parse('${url}sendReview'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
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

  Future getReview({required String serviceId}) async {
    try {
      var response =
          await http.get(Uri.parse('${url}getReview/$serviceId'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return data;
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

  Future sendRevisionRequest({
    required String orderId,
    required String comment,
  }) async {
    try {
      var data = {
        'order_id': orderId,
        'notes': comment,
      };
      var response = await http.post(
        Uri.parse('${url}requestRevision'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        Get.snackbar(
          "Success",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return data;
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
}
