import 'package:flutter/material.dart';
import 'package:flutter_learning/custom_ui/custom_card.dart';
import 'package:flutter_learning/model.dart/chat_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatModel> chatModelList = [
    ChatModel(
        name: "Almas",
        isGroup: false,
        currentMessage: "Hello",
        time: "10:00",
        icon: "person.svg"),
    ChatModel(
        name: "Ahmed",
        isGroup: true,
        currentMessage: "Hello",
        time: "10:00",
        icon: "group.svg"),
    ChatModel(
        name: "ward",
        isGroup: false,
        currentMessage: "Hello",
        time: "10:00",
        icon: "person.svg"),
    ChatModel(
        name: "bilal",
        isGroup: true,
        currentMessage: "Hello",
        time: "10:00",
        icon: "group.svg"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.chat),
        ),
        body: ListView.builder(
            itemCount: chatModelList.length,
            itemBuilder: ((context, index) => CustomCard(
                  chatmodel: chatModelList[index],
                ))));
  }
}
