import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/screens/PageView/widgets/create_root_dialog.dart';
import 'package:teams_clone/screens/PageView/widgets/join_room_dialog.dart';
import 'package:teams_clone/screens/loginScreens/values/values.dart';

class GroupVideoCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Stack(
          children: [
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        gradient: Gradients.curvesGradient2,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
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
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 50,
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
                                      child: Container(
                                        child: Text(
                                          "Create Team",
                                          style: TextStyle(
                                              color: Colors.blueGrey.shade50,
                                              fontSize: 20),
                                        ),
                                      )),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Join Team",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontSize: 20),
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
          ],
        ),
      ),
    );
  }
}
