import 'package:flutter/material.dart';
import 'package:teams_clone/screens/PageView/widgets/log_list.dart';
import 'package:teams_clone/screens/PageView/widgets/user_circle.dart';
import 'package:teams_clone/widgets/app_bart.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: CustomAppBar(
        leading: UserCircle(),
        title: Text("Call History"),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10),
        child: LogList(),
      ),
    );
  }
}
