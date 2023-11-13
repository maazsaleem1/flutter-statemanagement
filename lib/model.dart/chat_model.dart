import 'package:flutter/material.dart';

class ChatModel {
  String name;
  bool isGroup;
  String currentMessage;
  String time;
  String icon;

  ChatModel(
      {required this.name,
      required this.isGroup,
      required this.currentMessage,
      required this.time,
      required this.icon});
}
