import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teams_clone/constants/strings.dart';
import 'package:teams_clone/models/call.dart';
import 'package:teams_clone/models/log.dart';
import 'package:teams_clone/resources/call_methods.dart';
import 'package:teams_clone/resources/local_db/repository/log_repository.dart';
import 'package:teams_clone/screens/callScreens/call_screen.dart';
import 'package:teams_clone/widgets/cached_image.dart';

class PickupScreen extends StatefulWidget {
  final Call? call;

  PickupScreen({
    @required this.call,
  });

  @override
  _PickupScreenState createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final CallMethods callMethods = CallMethods();

  bool callMissed = true;
  addToLocal({@required String? callStatus}) {
    Log log = Log(
      callerName: widget.call!.callerName,
      callerPic: widget.call!.callerPic,
      receiverName: widget.call!.receiverName,
      receiverPic: widget.call!.receiverPic,
      timestamp: DateTime.now().toString(),
      callStatus: callStatus,
    );

    LogRepository.addLogs(log);
  }

  @override
  void dispose() {
    super.dispose();
    if (callMissed) {
      addToLocal(callStatus: CALL_STATUS_MISSED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            CachedImage(
              widget.call!.callerPic,
              isRound: true,
              radius: 180,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.call!.callerName!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 75,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.call_end),
                    color: Colors.redAccent,
                    onPressed: () async {
                      callMissed = false;
                      addToLocal(callStatus: CALL_STATUS_RECEIVED);
                      await callMethods.endCall(call: widget.call!);
                    }),
                SizedBox(
                  width: 25,
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    callMissed = false;
                    addToLocal(callStatus: CALL_STATUS_RECEIVED);
                    await _handleCameraAndMic(Permission.camera);
                    await _handleCameraAndMic(Permission.microphone);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CallScreen(call: widget.call)));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
