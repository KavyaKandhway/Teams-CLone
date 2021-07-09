import 'package:flutter/material.dart';
import 'package:teams_clone/screens/loginScreens/values/values.dart';
import 'package:teams_clone/screens/search_screen.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: Gradients.curvesGradient3,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 25,
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }
}
