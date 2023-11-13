import 'package:flutter/material.dart';
import 'package:flutter_learning/model.dart/chat_model.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class IndivdualScreen extends StatefulWidget {
  IndivdualScreen({
    super.key,
    required this.chatmodel,
  });
  final ChatModel chatmodel;

  @override
  State<IndivdualScreen> createState() => _IndivdualScreenState();
}

class _IndivdualScreenState extends State<IndivdualScreen> {
  final textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              widget.chatmodel.isGroup
                  ? "assets/groups.svg"
                  : "assets/person.svg",
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
              widget.chatmodel.name,
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/whatsapbackgroundimage.png"),
              fit: BoxFit.cover),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            ListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
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
                                          icon: const Icon(
                                              Icons.camera_alt_sharp)),
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
                        onPressed: () {},
                        icon: textFieldController.text.isNotEmpty
                            ? const Icon(Icons.send)
                            : const Icon(Icons.mic)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
