import 'package:flutter/material.dart';
import 'package:flutter_learning/auth_service/service.dart';
import 'package:flutter_learning/custom_ui/custom_card.dart';
import 'package:flutter_learning/model.dart/all_user_data_model/all_user_data_model.dart';
import 'package:flutter_learning/model.dart/chat_model.dart';
import 'package:flutter_learning/view/indivdual_page.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.senderid});
  final String senderid;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatModel> chatModelList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          
          // centerTitle: true,
          // title: Text("Whatsapp Clone"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.chat),
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
                          itemBuilder: ((context, index) => GestureDetector(
                                onTap: () {
                                  Get.to(() => IndivdualScreen(
                                        name: snapshot
                                                .data?.data?[index].username ??
                                            "",
                                        senderid: widget.senderid,
                                        id: snapshot.data?.data?[index].id ??
                                            "",
                                      ));
                                  print(
                                      "idddd ===============> ${snapshot.data?.data?[index].userRooms.toString() ?? ""}");
                                  print(
                                      "senderIddd ===============> ${widget.senderid}");
                                },
                                child: CustomCard(
                                    senderid: widget.senderid,
                                    name:
                                        snapshot.data?.data?[index].username ??
                                            '',
                                    id: snapshot.data?.data?[index].id ?? ''),
                              )));
                    }
                  }),
            )
          ],
        ));
  }
}
