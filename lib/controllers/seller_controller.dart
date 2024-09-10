// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/models/language.dart';
import 'package:clone_freelancer_mobile/models/occupation.dart';
import 'package:clone_freelancer_mobile/models/package.dart';
import 'package:clone_freelancer_mobile/views/User/navigation_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../constant/const.dart';

class SellerController extends GetxController {
  final isLoading = false.obs;
  final box = GetStorage();

  @override
  void onClose() {
    super.onClose();
    isLoading.close();
  }

  Future reqVerification({
    required String name,
    required String description,
    required List<Languages> languages,
    required Occupation occupations,
    required List<String> subcategoryOccupation,
    required List<String> skills,
    required List<String> personalUrl,
    required String niknumber,
    required String nikname,
    required String nikgender,
    required String nikaddress,
    required String? profileImage,
    required String? idCardImage,
    required String? idCardWithSefieImage,
  }) async {
    try {
      isLoading.value = true;
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}freelancerActivation'),
      )..headers.addAll(headers);

      if (profileImage != null) {
        request.files.add(
            await http.MultipartFile.fromPath('profileImage', profileImage));
      }

      if (idCardImage != null) {
        request.files
            .add(await http.MultipartFile.fromPath('idCardImage', idCardImage));
      }

      if (idCardWithSefieImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'idCardWithSefieImage', idCardWithSefieImage));
      }

      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['languages'] = jsonEncode(languages);
      request.fields['occupations'] = jsonEncode(occupations);
      request.fields['skills'] = skills.join(',');
      request.fields['subcategoryOccupation'] = subcategoryOccupation.join(',');
      request.fields['url'] = jsonEncode(personalUrl);
      request.fields['niknumber'] = niknumber;
      request.fields['nikname'] = nikname;
      request.fields['nikgender'] = nikgender;
      request.fields['nikaddress'] = nikaddress;
      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        isLoading.value = false;
        Get.snackbar(
          "Success",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAll(() => const NavigationPage());
        });
        print(json.decode(respStr));
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(respStr));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future reqPackageVerification({
    required String type,
    required String category,
    required String subCategory,
    required String location,
    required String title,
    required String desc,
    required List<String> images,
    required bool customOrder,
    required List<Package> packages,
    required LatLng? position,
  }) async {
    try {
      // isLoading.value = true;

      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}packageActivation'),
      )..headers.addAll(headers);

      for (var imagePath in images) {
        request.files.add(
          await http.MultipartFile.fromPath('images[]', imagePath),
        );
      }

      request.fields['type'] = type;
      request.fields['category'] = category;
      request.fields['subCategory'] = subCategory;
      request.fields['location'] = location;
      request.fields['title'] = title;
      request.fields['desc'] = desc;
      if (position != null) {
        request.fields['lat'] = position.latitude.toString();
        request.fields['lng'] = position.longitude.toString();
      }

      if (customOrder == true) {
        request.fields['customOrder'] = 'true';
      } else {
        request.fields['customOrder'] = 'false';
      }
      request.fields['packages'] = jsonEncode(packages);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        isLoading.value = false;
        Get.snackbar(
          "Success",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAll(() => const NavigationPage());
        });
        print(json.decode(respStr));
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(respStr));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchProduct() async {
    try {
      var response =
          await http.get(Uri.parse('${url}getServiceFreelancer'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getServiceData({required int serviceId}) async {
    try {
      var response = await http
          .get(Uri.parse('${url}getServiceData/$serviceId'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteService({required int serviceId}) async {
    try {
      print('calling deleteSellerService');
      var response = await http
          .delete(Uri.parse('${url}deleteSellerService/$serviceId'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        print('finish calling deleteSavedService');
      } else {
        Get.snackbar(
          "Error",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('finish error calling deleteSavedService');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future updateService({
    required String type,
    required String category,
    required String subCategory,
    required String location,
    required String title,
    required String desc,
    required List<String> images,
    required bool customOrder,
    required List<Package> packages,
    required bool updateImage,
    required int serviceId,
    required LatLng? position,
  }) async {
    try {
      // isLoading.value = true;

      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}updateService'),
      )..headers.addAll(headers);

      if (updateImage == true) {
        for (var imagePath in images) {
          request.files.add(
            await http.MultipartFile.fromPath('images[]', imagePath),
          );
        }
      }
      request.fields['serviceId'] = serviceId.toString();
      request.fields['updateImage'] = updateImage == true ? 'true' : 'false';
      request.fields['type'] = type;
      request.fields['category'] = category;
      request.fields['subCategory'] = subCategory;
      request.fields['location'] = location;
      request.fields['title'] = title;
      request.fields['desc'] = desc;
      if (customOrder == true) {
        request.fields['customOrder'] = 'true';
      } else {
        request.fields['customOrder'] = 'false';
      }
      if (position != null) {
        request.fields['lat'] = position.latitude.toString();
        request.fields['lng'] = position.longitude.toString();
      }
      request.fields['packages'] = jsonEncode(packages);
      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        isLoading.value = false;
        Get.snackbar(
          "Success",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offNamedUntil('/', (route) => false);
        });
        print(json.decode(respStr));
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(respStr));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<DropdownMenuItem<String>>> getDropdownItem(String type) async {
    List<DropdownMenuItem<String>> dropdownItems = [];
    try {
      var response = await http
          .get(Uri.parse('${url}freelancer/getDropdownItem/$type'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        for (var item in data) {
          dropdownItems.add(
            DropdownMenuItem<String>(
              value: item['service_id'].toString(),
              child: Text(item['title']),
            ),
          );
        }
        return dropdownItems;
      } else {
        return dropdownItems;
      }
    } catch (e) {
      print(e.toString());
      return dropdownItems;
    }
  }

  Future addPortfolio({
    required String title,
    required String desc,
    required List<String> images,
  }) async {
    try {
      // isLoading.value = true;

      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}freelancer/addPortfolio'),
      )..headers.addAll(headers);

      for (var imagePath in images) {
        request.files.add(
          await http.MultipartFile.fromPath('images[]', imagePath),
        );
      }

      request.fields['title'] = title;
      request.fields['desc'] = desc;

      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar(
          "Success",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print(json.decode(respStr));
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(respStr));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchHeader() async {
    try {
      var response = await http.get(Uri.parse('${url}getHeader'), headers: {
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

  Future fetchAbout() async {
    try {
      var response = await http.get(Uri.parse('${url}getAbout'), headers: {
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

  Future fetchServices() async {
    try {
      var response = await http.get(Uri.parse('${url}getServices'), headers: {
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

  Future fetchReviews() async {
    try {
      var response =
          await http.get(Uri.parse('${url}getServiceData'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchPortfolio() async {
    try {
      var response = await http.get(Uri.parse('${url}getPortfolio'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['services'];
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchPortfolioById({
    required String portfolioId,
  }) async {
    try {
      var response = await http
          .get(Uri.parse('${url}getPortfolio/$portfolioId'), headers: {
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

  Future updateSellerProfile(
      {required String description,
      required List<Languages> languages,
      required List<String> skills,
      required List<String> personalUrl,
      required}) async {
    try {
      var data = {
        'description': description,
        'languages': jsonEncode(languages),
        'skills': skills.join(','),
        'url': jsonEncode(personalUrl),
      };

      var response = await http.post(
        Uri.parse('${url}freelancer/updateSellerProfile'),
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

  Future deletePortfolio({required String portfolioId}) async {
    try {
      var response = await http
          .delete(Uri.parse('${url}deletePortfolio/$portfolioId'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
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

  Future updatePortfolio({
    required String portfolioId,
    required String portfolioTitle,
    required String portfolioDesc,
    required List<String> images,
    required bool updateImage,
  }) async {
    try {
      // isLoading.value = true;

      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}freelancer/updatePortfolio'),
      )..headers.addAll(headers);

      if (updateImage == true) {
        for (var imagePath in images) {
          request.files.add(
            await http.MultipartFile.fromPath('images[]', imagePath),
          );
        }
      }
      request.fields['portfolioId'] = portfolioId.toString();
      request.fields['updateImage'] = updateImage == true ? 'true' : 'false';
      request.fields['title'] = portfolioTitle;
      request.fields['desc'] = portfolioDesc;
      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
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

  Future getAllOrder({required String status}) async {
    try {
      var response = await http
          .get(Uri.parse('${url}freelancer/getAllOrder/$status'), headers: {
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

  Future orderConfirmation({
    required String orderId,
    required String status,
  }) async {
    try {
      var data = {
        'order_id': orderId,
        'status': status,
      };

      var response = await http.post(
        Uri.parse('${url}freelancer/orderConfirmation'),
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

  Future deliverNow({
    required String fileUrl,
    required String orderId,
    required String desc,
  }) async {
    try {
      isLoading.value = true;

      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}freelancer/deliver'),
      )..headers.addAll(headers);

      if (fileUrl.isNotEmpty) {
        request.files
            .add(await http.MultipartFile.fromPath('fileUrl', fileUrl));
      }
      request.fields['order_id'] = orderId;
      request.fields['desc'] = desc;
      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar(
          "Success",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        print(json.decode(respStr));
      } else {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          json.decode(respStr)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print(json.decode(respStr));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future requestConfirmation({
    required String orderId,
    required String status,
    required String respon,
  }) async {
    try {
      var data = {
        'order_id': orderId,
        'status': status,
        'response': respon,
      };

      var response = await http.post(
        Uri.parse('${url}freelancer/requestConfirmation'),
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

  Future fetchAllReviews() async {
    try {
      var response =
          await http.get(Uri.parse('${url}freelancer/getReviews'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['reviews'];
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
