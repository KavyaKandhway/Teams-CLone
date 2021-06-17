import 'package:flutter/material.dart';

class ShimmeringLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      child: Image.network(
          "https://www.sharevision.at/wp-content/uploads/2018/09/Logo-Teams.png"),
    );
  }
}
