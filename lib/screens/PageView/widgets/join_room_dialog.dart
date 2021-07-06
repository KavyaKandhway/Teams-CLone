import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/callScreens/group_call_screen.dart';

import 'package:teams_clone/utils/permission.dart';

class JoinRoomDialog extends StatefulWidget {
  @override
  _JoinRoomDialogState createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  final TextEditingController roomTxtController = TextEditingController();
  UserClass? sender;
  FirebaseRepository _repository = FirebaseRepository();

  @override
  void initState() {
    // TODO: implement initState
    _repository.getCurentUser().then((user) {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.grey.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Join Room",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        content: Expanded(
          child: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'images/room_join_vector.png',
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  width: 200,
                  child: TextFormField(
                    controller: roomTxtController,
                    decoration: InputDecoration(
                        hintText: "Enter room id to join",
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2))),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
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
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GroupCallScreen(
                            channelName: roomTxtController.text,
                            role: ClientRole.Broadcaster,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 100,
                      child: Center(
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
                ),
              ],
            ),
          ),
        ));
  }
}
