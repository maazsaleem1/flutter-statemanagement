import 'dart:io';
import 'package:flutter_learning/custom_ui/pdf_view.dart';
import 'package:flutter_learning/custom_ui/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/auth_service/service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

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
  File? _pickedPDF;

  final List<Map<String, dynamic>> _messages = [];
  List<dynamic> selectedVideos = [];
  String isTyping = "";
  String? thumbnailPath;
  ScrollController _scrollController = ScrollController();
  final textFieldController = TextEditingController();
  final editTextField = TextEditingController();
  late IO.Socket socket;
  List<dynamic> imageFileList = [];
  final picker = ImagePicker();

  @override
  void initState() {
    // generateThumbnail();
    Future.delayed(const Duration(seconds: 1), () async {
      await getData();
      connect();
      emitSocket();
      _updateMessages();

      textFieldController.addListener(_emitTypingEvent);
    });
  }

  void _emitTypingEvent() {
    socket.emit("typing", {"roomId": roomid, "typer": widget.senderid});
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
    socket.on("user_typing", (data) {
      // print("typing data ===========> $data");
      setState(() {
        isTyping = data;
      });
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
    textFieldController.removeListener(_emitTypingEvent);
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

            print("data =========> $i");
          }
        }
        for (var message in _messages) {
          if (message["receiver"].toString() == widget.senderid &&
              message["isSeen"] == false) {
            socket.emit("update_seen_message", message);
          }
        }

        setState(() {});
      },
    );
  }

  Future<void> pickVideos(context) async {
    FilePickerResult? pickedFiles = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: true,
    );

    if (pickedFiles != null) {
      for (var file in pickedFiles.files) {
        final videoPlayerController =
            VideoPlayerController.file(File(file.path!));
      }

      selectedVideos = pickedFiles.files;
    }
    setState(() {});
  }

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pickedPDF = File(result.files.single.path!);
      });
    }
  }

  void _pickImage() async {
    final List<dynamic> selectedImages = await picker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.clear();
      imageFileList.addAll(selectedImages);
    }

    setState(() {});

    print("Image List Path:${imageFileList[0].path}");
    print("Image List Obj:${imageFileList[0]}");
  }

  sendPdf() async {
    if (_pickedPDF != null) {
      var fileName = _pickedPDF!.path.split('/').last;

      List<int> bytes = await _pickedPDF!.readAsBytes();

      Map<String, dynamic> data = {
        'text': textFieldController.text,
        'sender': widget.senderid,
        "receiver": widget.id,
        "room": roomid,
        "attachment": {
          "fileName": fileName,
          "fileType": "pdf",
          "fileData": bytes,
        }
      };

      print("======================= data $data");
      socket.emit('send_message', data);
      setState(() {
        _pickedPDF = null;
      });
    }
  }

  _sendImageMessage() async {
    var fileName = "";
    var bytes;
    if (imageFileList.isNotEmpty) {
      fileName = imageFileList[0].name;
      var file = File(imageFileList[0].path);
      bytes = await file.readAsBytes();
    }
    Map<String, dynamic> data = {
      'text': textFieldController.text,
      'sender': widget.senderid,
      "receiver": widget.id,
      "room": roomid,
      "attachment": {
        "fileName": fileName,
        "fileType": "jpg",
        "fileData": bytes,
      }
    };
    print("======================= data $data");
    socket.emit('send_message', data);
    imageFileList.clear();
  }

  _sendVideo() async {
    for (var video in selectedVideos) {
      var fileName = video.name;
      var bytes = await File(video.path).readAsBytes();
      // var mp4 = await video.extension;
      var fileExtension = fileName.split('.').last;

      Map<String, dynamic> data = {
        'text': textFieldController.text,
        'sender': widget.senderid,
        "receiver": widget.id,
        "room": roomid,
        "attachment": {
          "fileName": fileName,
          "fileType": fileExtension,
          "fileData": bytes,
        }
      };
      print("======================= data $data");
      socket.emit('send_message', data);
      selectedVideos.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // extendBody: true,
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
            Text(
                isTyping == widget.senderid || isTyping == ""
                    ? "last seen today at 10.00..."
                    : "Typing",
                style: const TextStyle(fontSize: 13))
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.video_call,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const Icon(
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
                  child: FocusScope(
                    onFocusChange: (value) {
                      if (value) {
                        _emitTypingEvent();
                        setState(() {});
                      } else {
                        setState(() {
                          isTyping = "";
                        });
                      }
                    },
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
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
                                    onPressed: () {
                                      _pickImage();
                                    },
                                    icon: const Icon(Icons.camera_alt_sharp)),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Choose an action'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                pickVideos(context);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'Videos',
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _pickPDF();
                                                // Navigator.of(context).pop();
                                              },
                                              child: Text('pdf'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.attach_file),
                                ),
                              ],
                            ),
                          )),
                    ),
                  )),
            ),
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0XFF128C7E),
            child: IconButton(
                onPressed: () async {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                  await _sendImageMessage();
                  await _sendVideo();
                  await sendPdf();
                  textFieldController.clear();

                  // }
                },
                icon: (textFieldController.text.isNotEmpty ||
                        imageFileList.isNotEmpty ||
                        selectedVideos.isNotEmpty ||
                        (_pickedPDF != null && _pickedPDF!.path.isNotEmpty))
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
          controller: _scrollController,
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Row(
                    mainAxisAlignment: message["sender"] == widget.senderid
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 230,
                          child: GestureDetector(
                            onLongPress: () {
                              message["sender"] == widget.senderid
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  print({
                                                    "messageId": message["_id"],
                                                    "room": message["room"]
                                                  });
                                                  socket.emit("delete_msg", {
                                                    "messageId": message["_id"],
                                                    "room": message["room"]
                                                  });
                                                  setState(() {});
                                                  Get.back();
                                                },
                                                child: Container(
                                                  // delete container
                                                  width: 100,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: const Center(
                                                    child: Text(
                                                      "delete",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  editTextField.text =
                                                      message["text"];
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          80)),
                                                          height: 150,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              const Text(
                                                                  "Edit your message"),
                                                              SizedBox(
                                                                height: 40,
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      editTextField,
                                                                  decoration: InputDecoration(
                                                                      border: OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20))),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    message["sender"] ==
                                                                            widget
                                                                                .senderid
                                                                        ? socket.emit(
                                                                            "edit_msg",
                                                                            {
                                                                                "messageId": message["_id"],
                                                                                "room": message["room"],
                                                                                "txt": editTextField.text,
                                                                              })
                                                                        : null;
                                                                  });
                                                                  Get.back();
                                                                  Get.back();
                                                                },
                                                                child:
                                                                    // this is the container of the delete and edit one
                                                                    Container(
                                                                  width: 100,
                                                                  height: 40,
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .black),
                                                                      color: Colors
                                                                          .blue,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                      "done",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: 100,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: const Center(
                                                    child: Text(
                                                      "edit",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                  : null;
                            },
                            child: message["isDeleted"] == false
                                ? Card(
                                    color: message["sender"] == widget.senderid
                                        ? const Color(0xffdcf8c6)
                                        : const Color.fromARGB(255, 65, 60, 60),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: message["sender"] ==
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
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            message["text"],
                                          ),
                                          if (message["attachment"] != null &&
                                              message["attachment"]
                                                      ["fileType"] ==
                                                  "jpg")
                                            Container(
                                              height: 250,
                                              width: 250,
                                              child: Image(
                                                image: NetworkImage(
                                                  // thumbnailPath.toString(),
                                                  "https://chatsocket.thesuitchstaging.com/sio/Uploads/${message["attachment"]["fileName"]}",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          if (message["attachment"] != null &&
                                              message["attachment"]
                                                      ["fileType"] ==
                                                  "mp4")
                                            VideoPlayerWidget(
                                              videoUrl:
                                                  "https://chatsocket.thesuitchstaging.com/sio/Uploads/${message["attachment"]["fileName"]}",
                                            ),
                                          if (message["attachment"] != null &&
                                              message["attachment"]
                                                      ["fileType"] ==
                                                  "pdf")
                                            Container(
                                              height: 300,
                                              width: 300,
                                              child: const ShowPdf(
                                                remotePDFURL:
                                                    "https://assets.kpmg.com/content/dam/kpmg/pk/pdf/2022/06/Pakistan-Economic-Brief-2022.pdf",
                                                //  "https://chatsocket.thesuitchstaging.com/sio/Uploads/${message["attachment"]["fileName"]}",
                                              ),
                                            ),
                                          message["isSeen"] == true
                                              ? IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.done_all_sharp,
                                                    color: Colors.blue,
                                                  ))
                                              : IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.done_all_sharp,
                                                  )),
                                        ],
                                      ),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Message has been deleted"),
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
