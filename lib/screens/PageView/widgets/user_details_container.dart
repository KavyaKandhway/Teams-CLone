import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/constants/strings.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/provider/user_provider.dart';
import 'package:teams_clone/resources/firebase_methods.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/PageView/widgets/shimmering_logo.dart';
import 'package:teams_clone/screens/loginScreens/start_screen.dart';
import 'package:teams_clone/screens/loginScreens/theme.dart';
import 'package:teams_clone/screens/loginScreens/values/values.dart';

import 'package:teams_clone/widgets/app_bart.dart';
import 'package:teams_clone/widgets/cached_image.dart';

class UserDetailsContainer extends StatelessWidget {
  ThemeBloc? themeBloc;
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    signOut() async {
      final bool loggedOut = await _firebaseRepository.signOut();
      if (loggedOut) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => StartScreen(
                    themeBloc: themeBloc,
                  )),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: [
          CustomAppBar(
            gradient: Gradients.headerOverlayGradient,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.blueGrey.shade100,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
            centerTitle: true,
            title: ShimmeringLogo(),
            actions: [
              TextButton(
                onPressed: () => signOut(),
                child: Text(
                  "Sign Out",
                  style:
                      TextStyle(color: Colors.blueGrey.shade100, fontSize: 12),
                ),
              ),
            ],
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}

class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final UserClass? user = userProvider.getUSer;
    return Container(
      color: Colors.blueGrey.shade900,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CachedImage(
            user!.profilePhoto != null ? user.profilePhoto : noImageAvailable,
            isRound: true,
            radius: 50,
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name != null ? user.name! : user.email!.split('@')[0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user.email!,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
