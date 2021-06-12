import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/widgets/app_bart.dart';
import 'package:teams_clone/widgets/custom_tile.dart';

final FirebaseRepository _repository = FirebaseRepository();

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String currentUserId;
  String initials;
  @override
  void initState() {
    super.initState();
    _repository.getCurentUser().then((user) {
      setState(() {
        currentUserId = user.uid;
        initials = Utils.getInitials(user.displayName);
      });
    });
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      actions: [
        IconButton(
            icon: Icon(
              Icons.video_call,
              color: Colors.white,
            ),
            onPressed: () {}),
        IconButton(
            icon: Icon(
              Icons.sort,
              color: Colors.white,
            ),
            onPressed: () {})
      ],
      centerTitle: false,
      title: Text("Chat"),
      leading: UserCircle(initials),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(currentUserId),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;
  ChatListContainer(this.currentUserId);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/search_screen");
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Text(
                    "Search",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          child: Expanded(
            child: SizedBox(
              height: 400,
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return CustomTile(
                    subtitle: Text(
                      "hello",
                      style: TextStyle(color: Colors.grey),
                    ),
                    mini: false,
                    onTap: () {},
                    title: Text(
                      "Jesus",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    leading: Container(
                      constraints: BoxConstraints(
                        maxHeight: 60,
                        maxWidth: 60,
                      ),
                      child: Stack(
                        children: [
                          CircleAvatar(
                              maxRadius: 40,
                              backgroundColor: Colors.blueAccent,
                              backgroundImage: NetworkImage(
                                  "https://th.bing.com/th/id/Rc49055e5e2b50f9583c751eb70b3026f?rik=gwqo8ogorv%2blIA&riu=http%3a%2f%2fwww.fotoplex.co.uk%2fapp%2fuploads%2f2018%2f08%2fReligious-Icon-2.jpg&ehk=nwp3lNk2nJVacDRV7Fa9EiVaPxlBV84A7WDW3Z5qfIM%3d&risl=&pid=ImgRaw")),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                  border: Border.all(
                                      color: Colors.green, width: 2)),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UserCircle extends StatelessWidget {
  final String text;
  UserCircle(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        shape: BoxShape.circle,
        color: Colors.indigo,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              (text == null) ? "#" : text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.green, width: 2),
                color: Colors.green,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}
