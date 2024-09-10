// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/core.dart';
import 'package:clone_freelancer_mobile/views/Auth/reset_password.dart';
import 'package:clone_freelancer_mobile/views/Auth/set_password.dart';
import 'package:clone_freelancer_mobile/views/Auth/verification_notice.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final token = ''.obs;
  final box = GetStorage();
  NavigationController navigationController = Get.find<NavigationController>();
  ModeController modeController = Get.find<ModeController>();

  Future signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'name': name,
        'email': email,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${url}register'),
        headers: {'Accept': 'application/json'},
        body: data,
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        if (Get.previousRoute == '/') {
          Get.off(
            () => const VerNoticePage(
              choice: '1',
            ),
          );
        } else {
          Get.off(
            () => const VerNoticePage(
              choice: '2',
            ),
          );
        }
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future logIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'email': email,
        'password': password,
      };

      var response = await http.post(
        Uri.parse('${url}login'),
        headers: {'Accept': 'application/json'},
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        token.value = json.decode(response.body)['token'];
        box.write('token', token.value);
        print(box.read('token'));
        var test = json.decode(response.body)['user'];
        var piclink = json.decode(response.body)['picture'];
        if (piclink != null) {
          piclink = url.replaceFirst('/api/', '') + piclink;
          box.write('pic', piclink);
        }
        box.write('user', test);
        navigationController.selectedIndex.value = 0;
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
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future logout() async {
    try {
      isLoading.value = true;
      var response = await http.post(
        Uri.parse('${url}logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        box.remove('token');
        box.remove('user');
        box.remove('pic');

        Get.offAll(() => const NavigationPage());
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future closeAccount() async {
    try {
      isLoading.value = true;
      var response = await http.post(
        Uri.parse('${url}closeAccount'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 200) {
        isLoading.value = false;

        box.remove('token');
        box.remove('user');
        box.remove('pic');

        Get.snackbar(
          "Success",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAll(() => const NavigationPage());

        if (modeController.mode.value == true) {
          navigationController.selectedIndex.value = 0;
          modeController.mode.value = false;
        }
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future forgot({required String email}) async {
    try {
      isLoading.value = true;
      var data = {
        'email': email,
      };

      var response = await http.post(
        Uri.parse('${url}forgot'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Sucess",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isLoading.value = false;
        Get.off(
          () => ResetPassword(
            email: email,
          ),
        );
      } else {
        Get.snackbar(
          "Error",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoading.value = false;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future checkCode({required String email, required String token}) async {
    try {
      isLoading.value = true;
      var data = {
        'email': email,
        'token': token,
      };

      var response = await http.post(
        Uri.parse('${url}check'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.off(
          () => SetPasswordPage(
            email: email,
            token: token,
          ),
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

  Future reset({
    required String email,
    required String password,
    required String token,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        'email': email,
        'password': password,
        'token': token,
      };

      var response = await http.post(
        Uri.parse('${url}reset'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        var data = json.decode(response.body)['token'];
        box.write('token', data);
        var test = json.decode(response.body)['user'];
        var piclink = json.decode(response.body)['picture'];
        box.write('pic', piclink);
        box.write('user', test);
        navigationController.selectedIndex.value = 0;
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
}
