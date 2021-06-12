import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/widgets/app_bart.dart';
import 'package:teams_clone/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget {
  final UserClass receiver;
  ChatScreen({this.receiver});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textieldController = TextEditingController();

  bool isWriting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: customAppBar(context),
      body: Column(
        children: [
          Flexible(child: messageList()),
          chatControls(),
        ],
      ),
    );
  }

  Widget messageList() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: 6,
      itemBuilder: (context, index) {
        return chatMessageItem();
      },
    );
  }

  Widget chatMessageItem() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        alignment: Alignment.centerRight,
        child: senderLayout(),
      ),
    );
  }

  Widget senderLayout() {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: Colors.indigo.shade300,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Hello",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget receiverLayout() {
    Radius messageRadius = Radius.circular(10);
    return Container(
      width: 10,
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.only(
          bottomLeft: messageRadius,
          topRight: messageRadius,
          bottomRight: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          "Hello",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: Colors.black,
          builder: (context) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.maybePop(context);
                        },
                      ),
                      Expanded(
                        child: Align(
                          child: Text(
                            "Contents and tools",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: [
                      ModalTile(
                        title: "Media",
                        subtitle: "Share Photos and Videos",
                        icon: Icons.camera_alt_outlined,
                      ),
                      ModalTile(
                        title: "Attach",
                        subtitle: "Share Files",
                        icon: Icons.attach_file_sharp,
                      ),
                      ModalTile(
                        title: "Location",
                        subtitle: "Share Location",
                        icon: Icons.location_on_outlined,
                      ),
                      ModalTile(
                        title: "GIF",
                        subtitle: "Share GIFs",
                        icon: Icons.gif_outlined,
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.indigo,
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onTap: () {
                addMediaModal(context);
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              controller: textieldController,
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (val) {
                if (val.length > 0 && val.trim() != "") {
                  setWritingTo(true);
                } else {
                  setWritingTo(false);
                }
              },
              decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  filled: true,
                  fillColor: Colors.grey.shade900,
                  suffixIcon: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey,
                    ),
                  )),
            ),
          ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.grey,
                  ),
                ),
          isWriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Icon(
                    Icons.mic_none,
                    color: Colors.grey,
                  ),
                ),
          isWriting
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: IconButton(
                    iconSize: 30,
                    onPressed: () {},
                    icon: Icon(
                      Icons.send,
                      color: Colors.indigo,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
      centerTitle: false,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.indigo,
            backgroundImage: NetworkImage(widget.receiver.profilePhoto),
          ),
          SizedBox(
            width: 10,
          ),
          Text(widget.receiver.name),
        ],
      ),
      actions: [
        IconButton(icon: Icon(Icons.videocam_outlined), onPressed: () {}),
        IconButton(icon: Icon(Icons.phone_enabled_outlined), onPressed: () {}),
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  const ModalTile({
    this.title,
    this.icon,
    this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey.shade900,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.grey,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
