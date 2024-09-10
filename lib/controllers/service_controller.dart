// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ServiceController extends GetxController {
  final box = GetStorage();

  Future getPopularService() async {
    try {
      var response =
          await http.get(Uri.parse('${url}getPopularService'), headers: {
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

  Future getRecommendation() async {
    try {
      var response =
          await http.get(Uri.parse('${url}getRecommendation'), headers: {
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

  Future getServiceImage(int serviceId) async {
    try {
      print('calling getServiceImage');
      var response = await http
          .get(Uri.parse('${url}getServiceImage/$serviceId'), headers: {
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        List<String> imageList = [];
        for (int i = 0; i < data.length; i++) {
          var link = url.replaceFirst('/api/', '') + data[i]['picasset'];
          imageList.add(link);
        }
        print('finish calling getServiceImage');
        return imageList;
      } else {
        Get.snackbar(
          "Error",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('finish error calling getServiceImage');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getServicePackage(int serviceId) async {
    try {
      print('calling getServicePackage');
      var response = await http
          .get(Uri.parse('${url}getServicePackage/$serviceId'), headers: {
        'Accept': 'application/json',
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        print('finish calling getServicePackage');
        return data;
      } else {
        Get.snackbar(
          "Error",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('finish error calling getServicePackage');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future saveService(int serviceId) async {
    try {
      print('calling getSavedService');
      var response = await http.post(
        Uri.parse('${url}savedService'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: {'service_id': serviceId.toString()},
      );
      if (response.statusCode == 201) {
        print('finish calling getSavedService');
      } else {
        Get.snackbar(
          "Error",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('finish error calling getSavedService');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getAllSavedService() async {
    try {
      print('calling getAllSavedService');
      var response = await http.get(Uri.parse('${url}savedService'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];

        print('finish calling getAllSavedService');
        return data;
      } else {
        Get.snackbar(
          "Error",
          json.decode(response.body)['message'],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('finish error calling getAllSavedService');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future deleteSavedService(int serviceId) async {
    try {
      print('calling deleteSavedService');
      var response = await http
          .delete(Uri.parse('${url}savedService/$serviceId'), headers: {
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

  Future getAllCategory() async {
    try {
      var response =
          await http.get(Uri.parse('${url}getAllCategory'), headers: {
        'Accept': 'application/json',
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

  Future getAllSubCategory(int categoryId) async {
    try {
      var response = await http
          .get(Uri.parse('${url}getAllSubCategory/$categoryId'), headers: {
        'Accept': 'application/json',
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

  Future getDisplayBySubCategoryIdAuth(int subCategoryId) async {
    try {
      print('calling getAllSavedService');
      var response = await http.get(
          Uri.parse('${url}getDisplayBySubCategoryIdAuth/$subCategoryId'),
          headers: {
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

  Future getDisplayBySubCategoryIdNoAuth(int subCategoryId) async {
    try {
      print('calling getAllSavedService');
      var response = await http.get(
          Uri.parse('${url}getDisplayBySubCategoryIdNoAuth/$subCategoryId'),
          headers: {
            'Accept': 'application/json',
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

  Future getAllOrders({required String status}) async {
    try {
      var response =
          await http.get(Uri.parse('${url}getAllOrders/$status'), headers: {
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

  // Future<List<AutoComplete>> getSuggestion(String suggestion) async {
  //   try {
  //     var response = await http.get(
  //       Uri.parse('${url}getSuggestion/$suggestion'),
  //       headers: {
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer ${box.read('token')}',
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.body)['suggestions'] as List<dynamic>;
  //       List<AutoComplete> autoCompleteList =
  //           data.map((item) => AutoComplete.fromJson(item)).toList();
  //       return autoCompleteList;
  //     } else {
  //       return [];
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //     return [];
  //   }
  // }

  Future getResult({required String keyword}) async {
    try {
      var response = await http.get(
        Uri.parse('${url}getResult/$keyword'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['suggestions'];
        print(data);
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getResultNotLogged({required String keyword}) async {
    try {
      var response = await http.get(
        Uri.parse('${url}getResultNotLogged/$keyword'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['suggestions'];
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future filterData({
    required int? type,
    required String? lowRange,
    required String? highRange,
    required int? rating,
    required LatLng? position,
    required String keyword,
  }) async {
    try {
      var data = {
        if (type != null)
          'type': type == 0 ? 'Digital Service' : 'On-Site Service',
        if (lowRange != null) 'lowRange': lowRange,
        if (highRange != null) 'highRange': highRange,
        if (rating != null) 'rating': rating.toString(),
        if (position != null) 'lat': position.latitude.toString(),
        if (position != null) 'lng': position.longitude.toString(),
        'keyword': keyword,
      };

      var response = await http.post(
        Uri.parse('${url}getResult/filterData'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['suggestions'];
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future filterDataNotLogged({
    required int? type,
    required String? lowRange,
    required String? highRange,
    required int? rating,
    required LatLng? position,
    required String keyword,
  }) async {
    try {
      var data = {
        if (type != null)
          'type': type == 0 ? 'Digital Service' : 'On-Site Service',
        if (lowRange != null) 'lowRange': lowRange,
        if (highRange != null) 'highRange': highRange,
        if (rating != null) 'rating': rating.toString(),
        if (position != null) 'lat': position.latitude.toString(),
        if (position != null) 'lng': position.longitude.toString(),
        'keyword': keyword,
      };

      var response = await http.post(
        Uri.parse('${url}getResult/filterDataNotLogged'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['suggestions'];
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future filterSubCategory({
    required int? type,
    required String? lowRange,
    required String? highRange,
    required int? rating,
    required String subCategoryId,
    required LatLng? position,
  }) async {
    try {
      var data = {
        if (type != null)
          'type': type == 0 ? 'Digital Service' : 'On-Site Service',
        if (lowRange != null) 'lowRange': lowRange,
        if (highRange != null) 'highRange': highRange,
        if (rating != null) 'rating': rating.toString(),
        'subcategory_id': subCategoryId,
        if (position != null) 'lat': position.latitude.toString(),
        if (position != null) 'lng': position.longitude.toString(),
      };

      var response = await http.post(
        Uri.parse('${url}getResult/filterSubCategory'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['suggestions'];
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future filterSubCategoryNotLogged({
    required int? type,
    required String? lowRange,
    required String? highRange,
    required int? rating,
    required String subCategoryId,
    required LatLng? position,
  }) async {
    try {
      var data = {
        if (type != null)
          'type': type == 0 ? 'Digital Service' : 'On-Site Service',
        if (lowRange != null) 'lowRange': lowRange,
        if (highRange != null) 'highRange': highRange,
        if (rating != null) 'rating': rating.toString(),
        if (position != null) 'lat': position.latitude.toString(),
        if (position != null) 'lng': position.longitude.toString(),
        'subcategory_id': subCategoryId,
      };

      var response = await http.post(
        Uri.parse('${url}getResult/filterSubCategoryNotLogged'),
        headers: {
          'Accept': 'application/json',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['suggestions'];
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
