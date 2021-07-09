import 'package:flutter/material.dart';
import 'package:teams_clone/screens/loginScreens/values/values.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? centerTitle;
  final Color? color;
  final Gradient? gradient;

  const CustomAppBar({
    @required this.title,
    @required this.actions,
    @required this.leading,
    @required this.centerTitle,
    this.color,
    this.gradient,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        gradient: gradient,
        color: color,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1.4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
