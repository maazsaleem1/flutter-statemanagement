import 'package:flutter/material.dart';
import 'package:flutter_learning/pages/chat_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // ignore: prefer_final_fields
  late TabController _controller =
      TabController(length: 4, vsync: this, initialIndex: 0);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _controller = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Whatsapp clone"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
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
      body: TabBarView(controller: _controller, children: const [
        Text("camera"),
        ChatScreen(),
        Text("status"),
        Text("calls")
      ]),
    );
  }
}
