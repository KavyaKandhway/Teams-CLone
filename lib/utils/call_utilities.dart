import 'dart:math';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/constants/strings.dart';
import 'package:teams_clone/models/log.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/resources/call_methods.dart';
import 'package:teams_clone/models/call.dart';
import 'package:teams_clone/resources/local_db/repository/log_repository.dart';
import 'package:teams_clone/screens/callScreens/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({UserClass? from, UserClass? to, context}) async {
    Call? call = Call(
      callerId: from!.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to!.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerPic: from.profilePhoto,
      callerName: from.name,
      callStatus: CALL_STATUS_DIALED,
      receiverPic: to.profilePhoto,
      receiverName: to.name,
      timestamp: DateTime.now().toString(),
    );
    bool callMade = await callMethods.makeCall(call: call);
    call.hasDialed = true;
    if (callMade) {
      print("callMade");
      LogRepository.addLogs(log);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            call: call,
            role: ClientRole.Broadcaster,
          ),
        ),
      );
    }
  }
}
