import 'package:flutter/material.dart';
import 'package:flutter_learning/model.dart/chat_model.dart';

import 'package:flutter_svg/svg.dart';




class IndivdualScreen extends StatefulWidget {
   IndivdualScreen({super.key,required this.chatmodel, required Type chatModel});
final chatModel chatmodel;

  @override
  State<IndivdualScreen> createState() => _IndivdualScreenState();
}

class _IndivdualScreenState extends State<IndivdualScreen> {
  @override
  Widget build(BuildContext context) {

    return   Scaffold(
        appBar: AppBar(
        leading: 
          CircleAvatar(
              radius: 25,
              // ignore: sort_child_properties_last
              child: SvgPicture.asset(
          widget.chatmodel.isGroup ? "assets/groups.svg":"assets/person.svg",
                color: Colors.white,
                height: 38,
                width: 38,
              ),
              backgroundColor: Colors.grey,
            
        ),
        ),

    );
  }
}