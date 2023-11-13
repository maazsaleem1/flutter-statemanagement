import 'package:flutter/material.dart';

class chatModel{
   String name;
   bool isGroup;
  String currentMessage;
  String time;
  String icon;

  chatModel({required this.name,required this.isGroup,required this.currentMessage,
  required this.time,required this.icon
  });

}