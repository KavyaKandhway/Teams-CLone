import 'package:flutter/material.dart';

class JoinRoomDialog extends StatelessWidget {
  final TextEditingController roomTxtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.grey.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Room Created",
          style: TextStyle(color: Colors.white),
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
                      null;
                      // if (roomTxtController.text.isNotEmpty) {
                      //   bool isPermissionGranted =
                      //       await handlePermissionsForCall(context);
                      //   if (isPermissionGranted) {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => VideoCallScreen(
                      //                   channelName: roomTxtController.text,
                      //                 )));
                      //   } else {
                      //     Get.snackbar("Failed", "Enter Room-Id to Join.",
                      //         backgroundColor: Colors.white,
                      //         colorText: Color(0xFF1A1E78),
                      //         snackPosition: SnackPosition.BOTTOM);
                      //   }
                      // } else {
                      //   Get.snackbar("Failed",
                      //       "Microphone Permission Required for Video Call.",
                      //       backgroundColor: Colors.white,
                      //       colorText: Color(0xFF1A1E78),
                      //       snackPosition: SnackPosition.BOTTOM);
                      // }
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
