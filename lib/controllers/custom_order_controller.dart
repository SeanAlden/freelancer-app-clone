// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class CustomOrderController extends GetxController {
  final box = GetStorage();

  Future setCustomOrderStatus({
    required String customId,
    required String status,
    required String chatRoomId,
  }) async {
    try {
      print('test: $chatRoomId');
      var data = {
        'custom_id': customId,
        'status': status,
        'chatRoom_id': chatRoomId,
      };

      var response = await http.post(
        Uri.parse('${url}freelancer/setCustomOrderStatus'),
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

  Future createCustomOrder({
    required String serviceId,
    required String description,
    required String price,
    required String revision,
    required String deliveryDays,
    required DateTime? expiration,
    required DateTime? onsiteDate,
    required LatLng? latlng,
    required String? loc,
  }) async {
    try {
      var data = {
        'service_id': serviceId,
        'description': description,
        'price': price,
        'revision': revision,
        'delivery_days': deliveryDays,
        'expiration_date': expiration == null ? "" : expiration.toString(),
        'onsite_date': onsiteDate == null ? "" : onsiteDate.toString(),
        if (latlng != null) 'lat': latlng.latitude.toString(),
        if (latlng != null) 'lng': latlng.longitude.toString(),
        if (loc != null) 'loc': loc,
      };

      var response = await http.post(
        Uri.parse('${url}freelancer/createCustomOrder'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        return data['custom_id'];
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
