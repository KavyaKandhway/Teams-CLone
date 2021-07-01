import 'package:flutter/material.dart';
import 'dart:math';

import 'package:permission_handler/permission_handler.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/utils/group_call_utilities.dart';
import 'package:teams_clone/utils/permission.dart';

class CreateRoomDialog extends StatefulWidget {
  @override
  _CreateRoomDialogState createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  String roomId = "";
  FirebaseRepository _repository = FirebaseRepository();
  String _currentUserId;
  UserClass sender;
  @override
  void initState() {
    roomId = generateRandomString(8);
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
    super.initState();
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        "Room Created",
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'images/room_created_vector.png',
          ),
          Text("Room id : " + roomId,
              style: TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.black,
                ),
                child: TextButton(
                  onPressed: () {
                    null; // shareToApps(roomId);
                  },
                  child: Container(
                    width: 80,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.share, color: Colors.white),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Share",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6)),
                child: TextButton(
                  onPressed: () async {
                    await handleCameraAndMic(Permission.camera);
                    await handleCameraAndMic(Permission.microphone);
                    GroupCallUtils.dial(
                      context: context,
                      from: sender,
                      roomId: roomId,
                    );
                  },
                  child: Container(
                    width: 80,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward, color: Colors.white),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Join",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
