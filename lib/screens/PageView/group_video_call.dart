import 'package:flutter/material.dart';
import 'package:teams_clone/screens/PageView/widgets/create_root_dialog.dart';
import 'package:teams_clone/screens/PageView/widgets/join_room_dialog.dart';

class GroupVideoCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60, left: 30),
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Microsoft Teams",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  "Easy connect with friends via video call.",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                top: 30,
              ),
              padding: const EdgeInsets.only(
                top: 30,
              ),
              decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Center(
                  child: Column(
                children: [
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return CreateRoomDialog(); //CreateRoomDialog
                              });
                        },
                        child: Row(
                          children: [
                            Flexible(
                                flex: 7,
                                child: Image.asset(
                                  "images/create_meeting_vector.png",
                                  fit: BoxFit.fill,
                                )),
                            Flexible(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Create Room",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 2,
                        margin: const EdgeInsets.all(20),
                        color: Colors.white),
                  ),
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return JoinRoomDialog();
                              });
                        },
                        child: Row(
                          children: [
                            Flexible(
                                flex: 6,
                                child: Image.asset(
                                  "images/join_meeting_vector.png",
                                  fit: BoxFit.fill,
                                )),
                            Flexible(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Join Room",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
