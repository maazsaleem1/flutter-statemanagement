import 'package:flutter/material.dart';
import 'package:flutter_learning/model.dart/chat_model.dart';
import 'package:flutter_learning/view/indivdual_page.dart';

import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatefulWidget {
  CustomCard({super.key, required this.name, required this.id, });
  final String name;
  final String id;

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       // builder: (context) => IndivdualScreen(
        //       //       // chatmodel: widget.chatmodel,
        //       //     )),
        // );
      },
      child: Column(
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
            title: Text(widget.name),
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
            trailing: Text("10.00"),
          ),
          const Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
