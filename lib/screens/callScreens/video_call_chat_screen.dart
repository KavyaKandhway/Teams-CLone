import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teams_clone/screens/loginScreens/values/values.dart';
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
import 'package:teams_clone/widgets/room_id.dart';

class VideoCallChatScreen extends StatefulWidget {
  final UserClass? user1;
  final UserClass? user2;
  VideoCallChatScreen({this.user1, this.user2});
  @override
  _VideoCallChatScreenState createState() => _VideoCallChatScreenState();
}

class _VideoCallChatScreenState extends State<VideoCallChatScreen> {
  TextEditingController textieldController = TextEditingController();
  FirebaseRepository _repository = FirebaseRepository();
  UserProvider? userProvider;
  ImageUploadProvider? _imageUploadProvider;
  UserClass? sender;
  String? _currentUserId;
  bool isWriting = false;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider!.refreshUser();
    });

    _repository.getCurentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = UserClass(
          uid: user.uid,
          name: user.displayName != null
              ? user.displayName
              : user.email!.split('@')[0],
          profilePhoto: user.photoURL != null
              ? user.photoURL
              : "https://irisvision.com/wp-content/uploads/2019/01/no-profile-1.png",
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade900,
        appBar: CustomAppBar(
          title: Text("Chat"),
          gradient: Gradients.headerOverlayGradient,
        ),
        body: Column(
          children: [
            Flexible(child: messageList()),
            _imageUploadProvider!.getViewState == ViewState.LOADING
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
          .collection(_currentUserId == widget.user1!.uid
              ? widget.user2!.uid!
              : widget.user1!.uid!)
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
          itemCount: snapshot.data!.docs.length,
          reverse: true,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data!.docs[index]);
          },
        );
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot? snapshot) {
    Message? _message =
        Message.fromMap(snapshot!.data() as Map<String, dynamic>);
    if (_message.type == MESSAGE_TYPE_CALL_TEXT) {
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
    } else {
      return SizedBox();
    }
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      decoration: BoxDecoration(
        gradient: Gradients.curvesGradient2,
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
    if (message.type == MESSAGE_TYPE_CALL_TEXT) {
      return Text(
        message.message!,
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
        gradient: Gradients.curvesGradient3,
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

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
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
              ),
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
      receiverId: widget.user1!.uid == _currentUserId
          ? widget.user2!.uid
          : widget.user1!.uid,
      senderId: sender!.uid,
      message: text,
      timeStamp: Timestamp.now(),
      type: MESSAGE_TYPE_CALL_TEXT,
    );
    setState(() {
      isWriting = false;
      textieldController.text = "";
    });
    _repository.addMessageToDb(_message, sender!,
        widget.user1!.uid == _currentUserId ? widget.user2! : widget.user1!);
  }
}
