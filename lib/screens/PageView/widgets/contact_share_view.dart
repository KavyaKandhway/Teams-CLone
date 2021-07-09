import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/constants/strings.dart';
import 'package:teams_clone/models/contact.dart';
import 'package:teams_clone/models/message.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/provider/user_provider.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/loginScreens/values/values.dart';
import 'package:teams_clone/widgets/cached_image.dart';
import 'package:teams_clone/widgets/custom_tile.dart';

class ContactShareView extends StatelessWidget {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  final Contact? contact;
  final String? roomId;
  ContactShareView({this.contact, this.roomId});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<UserClass>(
          future: _firebaseRepository.getUserDetailsById(contact!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserClass? user = snapshot.data;

              return ShareViewLayout(contact: user!, roomId: roomId!);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
}

class ShareViewLayout extends StatefulWidget {
  final UserClass? contact;
  final String? roomId;

  ShareViewLayout({@required this.contact, this.roomId});

  @override
  _ShareViewLayoutState createState() =>
      _ShareViewLayoutState(roomId: roomId!, contact: contact!);
}

class _ShareViewLayoutState extends State<ShareViewLayout> {
  final String? roomId;
  final UserClass? contact;
  _ShareViewLayoutState({this.roomId, this.contact});
  FirebaseRepository? _repository = FirebaseRepository();
  UserProvider? userProvider;
  String? _currentUserId;
  UserClass? sender;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider!.refreshUser();
    });

    _repository!.getCurentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = UserClass(
          uid: user.uid,
          name: user.displayName != null
              ? user.displayName
              : user.email!.split('@')[0],
          profilePhoto:
              user.photoURL != null ? user.photoURL : noImageAvailable,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTile(
      leading: CachedImage(
        widget.contact!.profilePhoto != null
            ? widget.contact!.profilePhoto
            : noImageAvailable,
        radius: 60,
        isRound: true,
      ),
      title: Text(
        widget.contact!.name != null
            ? widget.contact!.name!
            : widget.contact!.email!.split('@')[0],
        style: TextStyle(
          color: Colors.blueGrey.shade100,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        widget.contact!.username != null
            ? widget.contact!.username!
            : widget.contact!.email!.split('@')[0],
        style: TextStyle(
          color: Colors.blueGrey.shade100,
          fontSize: 14,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          gradient: Gradients.curvesGradient3,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton(
          onPressed: () {
            sendRoomId(roomId!);
          },
          child: Text(
            "Send",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void sendRoomId(String roomId) {
    Message _message = Message(
      receiverId: widget.contact!.uid,
      senderId: sender!.uid,
      message: "ROOMID-" + roomId,
      timeStamp: Timestamp.now(),
      type: MESSAGE_TYPE_CALL,
    );

    _repository!.addMessageToDb(_message, sender!, widget.contact!);
  }
}
