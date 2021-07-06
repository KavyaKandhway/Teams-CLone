import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teams_clone/screens/callScreens/group_call_screen.dart';

import 'package:teams_clone/utils/permission.dart';

class RoomID extends StatelessWidget {
  String? roomId;
  RoomID({this.roomId});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.videocam_outlined,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Meeting Details",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(left: 35),
          width: MediaQuery.of(context).size.width,
          child: Text(
            "Room ID- " + roomId!,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.indigo.shade200,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextButton(
                onPressed: () async {
                  await handleCameraAndMic(Permission.camera);
                  await handleCameraAndMic(Permission.microphone);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupCallScreen(
                        channelName: roomId,
                        role: ClientRole.Broadcaster,
                      ),
                    ),
                  );
                },
                child: Text(
                  "Join",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        )
      ],
    );
  }
}
