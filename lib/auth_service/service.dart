import 'dart:convert';
import 'package:flutter_learning/model.dart/all_user_data_model/all_user_data_model.dart';
import 'package:flutter_learning/pages/chat_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthService {
  Future<void> LoginApi(context, data) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    final uri = Uri.parse(
        "https://chatsocket.thesuitchstaging.com:3050/api/v1/createprofile");
    String jsonbody = json.encode(data);
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonbody,
      );
      var res_data = json.decode(response.body);
      if (res_data['status'] == true) {
        Get.to(() => const ChatScreen());
      } else {
        Get.snackbar("Error", res_data['message'],
            colorText: Colors.black, backgroundColor: Colors.white);
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", e.toString(),
          colorText: Colors.black, backgroundColor: Colors.white);
    }
  }

  AllUserDataModel? allUserResponse;
  Future<AllUserDataModel?> getAllUser() async {
    final uri =
        Uri.parse("https://chatsocket.thesuitchstaging.com:3050/api/v1/getall");
    final response = await http.get(uri);
    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      allUserResponse = AllUserDataModel.fromJson(responseData);
      return allUserResponse!;
    } else {
      return null;
    }
  }
}