import 'package:flutter/material.dart';
import 'package:flutter_learning/auth_service/service.dart';
import 'package:flutter_learning/custom_ui/custom_card.dart';
import 'package:flutter_learning/model.dart/all_user_data_model/all_user_data_model.dart';
import 'package:flutter_learning/model.dart/chat_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatModel> chatModelList = [
    // ChatModel(
    //     name: "Almas",
    //     isGroup: false,
    //     currentMessage: "Hello",
    //     time: "10:00",
    //     icon: "person.svg"),
    // ChatModel(
    //     name: "Ahmed",
    //     isGroup: true,
    //     currentMessage: "Hello",
    //     time: "10:00",
    //     icon: "group.svg"),
    // ChatModel(
    //     name: "ward",
    //     isGroup: false,
    //     currentMessage: "Hello",
    //     time: "10:00",
    //     icon: "person.svg"),
    // ChatModel(
    //     name: "bilal",
    //     isGroup: true,
    //     currentMessage: "Hello",
    //     time: "10:00",
    //     icon: "group.svg"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.chat),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder<AllUserDataModel?>(
                  future: AuthService().getAllUser(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data?.data?.length,
                          itemBuilder: ((context, index) =>
                              //  Container(
                              //       margin: EdgeInsets.only(bottom: 10),
                              //       height: 100,
                              //       width: 100,
                              //       color: Colors.amber,
                              //     ))
                              CustomCard(
                                  name: snapshot.data?.data?[index].username ??
                                      '',
                                  id: snapshot.data?.data?[index].id ?? '')));
                    }
                  }),
            )
          ],
        ));
  }
}
