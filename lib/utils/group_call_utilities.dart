import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/models/group_call.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/resources/group_call_methods.dart';
import 'package:teams_clone/screens/callScreens/group_call_screen.dart';

class GroupCallUtils {
  static final GroupCallMethods groupCallMethods = GroupCallMethods();

  static dial({UserClass from, String roomId, BuildContext context}) async {
    GroupCall groupCall = GroupCall(
      roomId: roomId,
    );

    bool callMade = await groupCallMethods.makeGroupCall(groupCall: groupCall);

    if (callMade) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupCallScreen(
            groupCall: groupCall,
            role: ClientRole.Broadcaster,
            roomId: roomId,
          ),
        ),
      );
    }
  }
}
