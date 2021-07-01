import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teams_clone/utils/call_utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/constants/strings.dart';
import 'package:teams_clone/enum/view_state.dart';
import 'package:teams_clone/models/message.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/provider/image_upload_provider.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/widgets/app_bart.dart';
import 'package:teams_clone/widgets/cached_image.dart';
import 'package:teams_clone/widgets/custom_tile.dart';
import 'package:teams_clone/provider/user_provider.dart';
import 'package:teams_clone/utils/permission.dart';

class ChatScreen extends StatefulWidget {
  final UserClass receiver;
  ChatScreen({this.receiver});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textieldController = TextEditingController();
  FirebaseRepository _repository = FirebaseRepository();
  UserProvider userProvider;
  ImageUploadProvider _imageUploadProvider;
  UserClass sender;
  String _currentUserId;
  bool isWriting = false;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });

    _repository.getCurentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = UserClass(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoURL,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
        appBar: customAppBar(context),
        body: Column(
          children: [
            Flexible(child: messageList()),
            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15),
                    child: CircularProgressIndicator())
                : Container(),
            chatControls(),
          ],
        ),
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(MESSAGES_COLLECTION)
          .doc(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.docs.length,
          reverse: true,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data.docs[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data());
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        alignment: _message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  Widget senderLayout(Message message) {
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
        child: getMessage(message),
      ),
    );
  }

  getMessage(Message message) {
    if (message.type == MESSAGE_TYPE_IMAGE) {
      if (message.photoUrl != null) {
        return CachedImage(
          message.photoUrl,
          height: 250,
          width: 250,
          radius: 10,
        );
      } else {
        return Text("Url was null");
      }
    } else {
      return Text(
        message.message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    }
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);
    return Container(
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
        child: getMessage(message),
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
                        onTap: () {
                          pickImage(source: ImageSource.gallery);
                        },
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
                  child: GestureDetector(
                    onTap: () {
                      pickImage(source: ImageSource.camera);
                    },
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey,
                    ),
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
                    onPressed: () {
                      sendMessage();
                    },
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

  sendMessage() {
    var text = textieldController.text;

    Message _message = Message(
      receiverId: widget.receiver.uid,
      senderId: sender.uid,
      message: text,
      timeStamp: Timestamp.now(),
      type: 'text',
    );
    setState(() {
      isWriting = false;
      textieldController.text = "";
    });
    _repository.addMessageToDb(_message, sender, widget.receiver);
  }

  pickImage({@required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _repository.uploadImage(
        image: selectedImage,
        receiverId: widget.receiver.uid,
        senderId: _currentUserId,
        imageUploadProvider: _imageUploadProvider);
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
          Text(widget.receiver.name.split(' ')[0]),
        ],
      ),
      actions: [
        IconButton(
            icon: Icon(Icons.videocam_outlined),
            onPressed: () async {
              await handleCameraAndMic(Permission.camera);
              await handleCameraAndMic(Permission.microphone);

              CallUtils.dial(
                from: sender,
                to: widget.receiver,
                context: context,
              );
            }),
        IconButton(icon: Icon(Icons.phone_enabled_outlined), onPressed: () {}),
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;
  const ModalTile({
    @required this.title,
    @required this.icon,
    @required this.subtitle,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        onTap: onTap,
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
