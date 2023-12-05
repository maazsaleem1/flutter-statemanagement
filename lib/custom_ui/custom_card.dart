import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
 
class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.name,
    required this.id,
    required this.senderid,
  });
  final String name;
  final String id;
  final String senderid;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            // ignore: sort_child_properties_last
            child: SvgPicture.asset(
              // widget.chatmodel.isGroup
              //     ? "assets/groups.svg"
              //     :
              "assets/person.svg",
              color: Colors.white,
              height: 38,
              width: 38,
            ),
            backgroundColor: Colors.grey,
          ),
          title: Text(name),
          subtitle: const Row(
            children: [
              Icon(Icons.done_all),
              SizedBox(
                width: 5,
              ),
              Text(
                "heloo",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: const Text("10.00"),
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
