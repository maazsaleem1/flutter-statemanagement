import 'package:flutter/material.dart';
import 'package:flutter_learning/auth_service/service.dart';
import 'package:flutter_learning/custom_ui/custom_card.dart';
import 'package:flutter_learning/global.dart';
import 'package:flutter_learning/model.dart/all_user_data_model/datum.dart';
// import 'package:flutter_learning/view/Home_Screen.dart';
import 'package:flutter_learning/view/indivdual_page.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.senderid});
  final String senderid;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<Datum> fiteredList = chatModelList;
  late final TabController _controller =
      TabController(length: 4, vsync: this, initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Whatsapp clone"),
        actions: [
          SizedBox(
            width: Get.width * .5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: TextFormField(
                  onChanged: (value) {
                    fiteredList.clear();
                    fiteredList = chatModelList
                        .where((element) => element.username!
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ),
          // ignore: non_constant_identifier_names
          PopupMenuButton<String>(itemBuilder: (BuildContext Context) {
            return const [
              PopupMenuItem(
                child: Text("New group"),
              ),
              PopupMenuItem(
                child: Text("New broadcast"),
              ),
              PopupMenuItem(
                child: Text("whatsaap web"),
              ),
              PopupMenuItem(
                child: Text("stareed message"),
              ),
            ];
          })
        ],
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _controller,
          tabs: const [
            Tab(
              icon: Icon(Icons.camera_alt),
            ),
            Tab(
              text: "CHATS",
            ),
            Tab(
              text: "STATUS",
            ),
            Tab(
              text: "CALLS",
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
      body: TabBarView(controller: _controller, children: [
        const Text("camera"),
        Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: AuthService().getAllUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      fiteredList = chatModelList;
                      return fiteredList.isEmpty
                          ? const Center(
                              child: Text("no user found"),
                            )
                          : ListView.builder(
                              itemCount: fiteredList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => IndivdualScreen(
                                          name:
                                              fiteredList[index].username ?? "",
                                          senderid: widget.senderid,
                                          id: fiteredList[index].id ?? "",
                                        ));
                                    print(
                                        "idddd ===============> ${snapshot.data?.data?[index].userRooms.toString() ?? ""}");
                                    print(
                                        "senderIddd ===============> ${widget.senderid}");
                                  },
                                  child: CustomCard(
                                      senderid: widget.senderid,
                                      name: fiteredList[index].username ?? '',
                                      id: fiteredList[index].id ?? ''),
                                );
                              },
                            );
                    }
                  }),
            )
          ],
        ),
        const Text("status"),
        const Text("calls")
      ]),
    );
  }

  // Widget customColumn({required filtered}) {
  //   return
  // }
}
