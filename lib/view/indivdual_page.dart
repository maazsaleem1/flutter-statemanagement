import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_learning/auth_service/service.dart';
import 'package:flutter_learning/model.dart/chat_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class IndivdualScreen extends StatefulWidget {
  const IndivdualScreen({
    super.key,
    required this.senderid,
    required this.id,
    required this.name,
  });

  final String senderid;
  final String id;
  final String name;

  @override
  State<IndivdualScreen> createState() => _IndivdualScreenState();
}

class _IndivdualScreenState extends State<IndivdualScreen> {
  final List<Map<String, dynamic>> _messages = [];

  final textFieldController = TextEditingController();
  late IO.Socket socket;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () async {
      await getData();
      connect();
      emitSocket();
      _updateMessages();
    });
    super.initState();
  }

  Future<void> getData() async {
    var data = {
      "receiver": widget.id,
      "sender": widget.senderid,
    };
    await AuthService().callRoomApi(context, data);
  }

  void connect() {
    socket =
        IO.io("https://chatsocket.thesuitchstaging.com:3050", <String, dynamic>{
      'autoConnect': true,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
    });
  }

  void emitSocket() {
    socket.emit("join_room", roomid);
    print("+++++++++++++++++>>>>>>$roomid");
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  _updateMessages() {
    socket.on(
      "update_messages",
      (data) {
        print("data =========> $data");
        _messages.clear();
        for (var i in data) {
          if (i is Map<String, dynamic>) {
            _messages.add(i);
            setState(() {});
            print("data =========> $i");
          }
        }
      },
    );
  }

  _sendMessage(Map<String, dynamic> text) {
    socket.emit('send_message', {
      'text': textFieldController.text,
      'sender': widget.senderid,
      "receiver": widget.id,
      "room": roomid,
      "attachment": {
        "fileName": "",
        "fileType": "",
        "fileData": "",
      },
    });
    // setState(() {
    //   _messages.add(text);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leadingWidth: 80,
        leading: Row(children: [
          GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back)),
          CircleAvatar(
            radius: 25,
            // ignore: sort_child_properties_last
            child: SvgPicture.asset(
              "assets/person.svg",
              color: Colors.white,
              height: 38,
              width: 38,
            ),
            backgroundColor: Colors.grey,
          ),
        ]),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Text("last seen today at 10.00",
                style: TextStyle(fontSize: 13))
          ],
        ),
        actions: const [
          Icon(
            Icons.video_call,
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.call,
            size: 30,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 55,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: textFieldController,
                    decoration: InputDecoration(

                        // label: Text("Type a Message"),
                        hintText: ("Type a Message"),
                        prefixIcon: const Icon(Icons.emoji_emotions),
                        suffixIcon: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.camera_alt_sharp)),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.attach_file)),
                            ],
                          ),
                        )),
                  )),
            ),
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0XFF128C7E),
            child: IconButton(
                onPressed: () {
                  if (textFieldController.text.isNotEmpty) {
                    _sendMessage({"text": textFieldController.text});
                    textFieldController.clear();
                  }
                },
                icon: textFieldController.text.isNotEmpty
                    ? const Icon(Icons.send)
                    : const Icon(Icons.mic)),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/whatsapbackgroundimage.png"),
              fit: BoxFit.cover),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment:
                        _messages[index]["sender"] == widget.senderid
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 230,
                          child: GestureDetector(
                            onTap: () {
                              print(_messages[index]["_id"]);
                              print(_messages[index]["room"]);
                              print({
                                "messageId": _messages[index]["_id"],
                                "room": _messages[index]["room"]
                              });
                              setState(() {
                                socket.emit("delete_msg", {
                                  "messageId": _messages[index]["_id"],
                                  "room": _messages[index]["room"]
                                });
                              });
                            },
                            child: _messages[index]["isDeleted"] == false
                                ? Card(
                                    color: _messages[index]["sender"] ==
                                            widget.senderid
                                        ? Colors.teal.shade200
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: _messages[index]
                                                  ["sender"] ==
                                              widget.senderid
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            )
                                          : const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                    ),
                                    // margin: const EdgeInsets.only(right: 100, left: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        _messages[index]["text"],
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _messages[index]["sender"] ==
                                              widget.senderid
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {});
                                              },
                                              child: const Text(
                                                  "Message was delete"),
                                            )
                                          : const Text(""),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
