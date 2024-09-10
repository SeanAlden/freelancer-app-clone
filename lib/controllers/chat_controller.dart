// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clone_freelancer_mobile/models/chat_user_data.dart';
import 'package:clone_freelancer_mobile/views/chat/chat_detail_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constant/const.dart';

class ChatController extends GetxController {
  final isLoading = false.obs;
  final box = GetStorage();

  @override
  void onClose() {
    super.onClose();
    isLoading.close();
  }

  Future fetchAllChat() async {
    try {
      var response =
          await http.get(Uri.parse('${url}chat/getAllChat'), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> data = responseJson['chatList'];
        for (int i = 0; i < data.length; i++) {
          for (int j = 0; j < data[i]['participants'].length; j++) {
            if (data[i]['participants'][j]['user']['picture_id'] != null) {
              int picId = data[i]['participants'][j]['user']['picture_id'];
              try {
                var response = await http.get(
                    Uri.parse('${url}getProfileImage?pic=$picId'),
                    headers: {
                      'Accept': 'application/json',
                      'Authorization': 'Bearer ${box.read('token')}',
                    });
                if (response.statusCode == 200) {
                  String link = json.decode(response.body)['pic'];
                  link = url.replaceFirst('/api/', '') + link;
                  data[i]['participants'][j]['user']['piclink'] = link;
                } else {
                  Get.snackbar(
                    "Error",
                    json.decode(response.body)['message'],
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  data[i]['participants'][j]['user']['piclink'] = null;
                }
              } catch (e) {
                print(e.toString());
              }
            } else {
              data[i]['participants'][j]['user']['piclink'] = null;
            }
          }
        }
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future fetchAllMessage(int chatRoomId) async {
    try {
      var response = await http.get(
          Uri.parse('${url}chat/getAllMessage?chatRoom_id=$chatRoomId'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${box.read('token')}',
          });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> data = responseJson['data'];
        return data;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future sendMessage(int chatRoomId, String message) async {
    try {
      var data = {'chatRoom_id': chatRoomId.toString(), 'message': message};

      var response = await http.post(
        Uri.parse('${url}chat/sendMessage'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        return message;
      } else {
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

  Future customOrder(int chatRoomId, int serviceId, String message) async {
    try {
      var data = {
        'chatRoom_id': chatRoomId.toString(),
        'service_id': serviceId.toString(),
        'message': message
      };

      var response = await http.post(
        Uri.parse('${url}chat/sendMessage'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        return message;
      } else {
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

  Future customOrderChat(int chatRoomId, int customId) async {
    try {
      var data = {
        'chatRoom_id': chatRoomId.toString(),
        'custom_id': customId.toString(),
        'message': "",
      };

      var response = await http.post(
        Uri.parse('${url}chat/sendMessage'),
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
        print(json.decode(response.body));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future createChatRoom(UserData userData) async {
    try {
      var body = {'otherUserId': userData.userId.toString()};
      var response = await http.post(
        Uri.parse('${url}chat/create'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
        body: body,
      );

      if (response.statusCode == 201) {
        var data = json.decode(response.body)['chat'];
        Get.to(
          () => ChatDetailPage(
            chatId: data['chatRoom_id'],
            userList: [
              UserData(
                userId: box.read('user')['user_id'],
                piclink: box.read('pic'),
                name: box.read('user')['name'],
              ),
              userData,
            ],
          ),
        );
        return data['chatRoom_id'];
      } else if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        var data = json.decode(responseJson['data']);
        Get.to(
          () => ChatDetailPage(
            chatId: data['chatRoom_id'],
            userList: [
              UserData(
                userId: box.read('user')['user_id'],
                piclink: box.read('pic'),
                name: box.read('user')['name'],
              ),
              userData,
            ],
          ),
        );
        return data['chatRoom_id'];
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
