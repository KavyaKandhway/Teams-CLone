import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/provider/user_provider.dart';
import 'package:teams_clone/screens/PageView/widgets/user_details_container.dart';
import 'package:teams_clone/screens/loginScreens/values/values.dart';
import 'package:teams_clone/utils/utilities.dart';

class UserCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.blueGrey.shade900,
        builder: (context) => UserDetailsContainer(),
        isScrollControlled: true,
      ),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            shape: BoxShape.circle,
            gradient: Gradients.curvesGradient3),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                Utils.getInitials(userProvider.getUSer!.name == null
                    ? userProvider.getUSer!.email!
                    : userProvider.getUSer!.name!),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 2),
                  color: Colors.green,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
