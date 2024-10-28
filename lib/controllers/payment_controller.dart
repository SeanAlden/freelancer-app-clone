// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/constant/const.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:midtrans_sdk/midtrans_sdk.dart';

class PaymentController extends GetxController {
  MidtransSDK? _midtrans;
  final box = GetStorage();

  @override
  void onClose() {
    super.onClose();
    _midtrans?.removeTransactionFinishedCallback();
  }

  Future initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: "SB-Mid-client-wYeSigdies_2dI1d",
        // clientKey: "SB-Mid-client-v6-15hiE40WcarUI",
        // clientKey: "SB-Mid-client-v6-15hiE40WcarUI",
        colorTheme: ColorTheme(
          colorPrimary: Theme.of(Get.context!).colorScheme.secondary,
          colorPrimaryDark: Theme.of(Get.context!).colorScheme.secondary,
          colorSecondary: Theme.of(Get.context!).colorScheme.secondary,
        ),
        merchantBaseUrl: url,
      ),
    );
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );
    _midtrans!.setTransactionFinishedCallback((result) {
      print(result.toJson());
    });
  }

  Future getTokenForCustomOrder({
    required int customId,
    required int serviceId,
    required String price,
    required int freelancerId,
  }) async {
    try {
      var data = {
        'custom_id': customId.toString(),
        'service_id': serviceId.toString(),
        'freelancer_id': freelancerId.toString(),
        'price': price,
        'name': box.read('user')['name'],
        'email': box.read('user')['email'],
      };

      var response = await http.post(
        Uri.parse('${url}midtrans/payment/custom_order'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        await initSDK();
        await _midtrans?.startPaymentUiFlow(
          token: data,
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
}
