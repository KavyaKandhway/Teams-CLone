import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/enum/user_state.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/resources/local_db/repository/log_repository.dart';
import 'package:teams_clone/screens/PageView/group_video_call.dart';
import 'package:teams_clone/screens/PageView/log_screen.dart';
import 'package:teams_clone/utils/universal_variables.dart';
import 'package:teams_clone/provider/user_provider.dart';
import 'PageView/chat_list.dart';
import 'package:teams_clone/screens/callScreens/pickup/pickup_layout.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController? pageController;
  int _page = 0;
  FirebaseRepository _firebaseRepository = FirebaseRepository();
  UserProvider? userProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider!.refreshUser();

      _firebaseRepository.setUserState(
          userId: userProvider!.getUSer!.uid!, userState: UserState.Online);

      LogRepository.init(isHive: true, dbName: userProvider!.getUSer!.uid);
    });

    WidgetsBinding.instance!.addObserver(this);

    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String? currentUserId =
        (userProvider != null && userProvider!.getUSer != null)
            ? userProvider!.getUSer!.uid
            : "";
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _firebaseRepository.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resumed state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _firebaseRepository.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _firebaseRepository.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _firebaseRepository.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController!.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: [
            Container(
              child: GroupVideoCallScreen(),
            ),
            Center(
              child: ChatListScreen(),
            ),
            Center(
              child: LogScreen(),
            ),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: Colors.black,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    (_page == 0) ? Icons.people : Icons.people_outline,
                    color: (_page == 0) ? Colors.white : Colors.grey,
                  ),
                  title: Text(
                    "Teams",
                    style: TextStyle(
                      color: (_page == 0) ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    (_page == 1) ? Icons.chat : Icons.chat_outlined,
                    color: (_page == 1) ? Colors.white : Colors.grey,
                  ),
                  title: Text(
                    "Chat",
                    style: TextStyle(
                      color: (_page == 1) ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    (_page == 2) ? Icons.call : Icons.call_outlined,
                    color: (_page == 2) ? Colors.white : Colors.grey,
                  ),
                  title: Text(
                    "Calls",
                    style: TextStyle(
                      color: (_page == 2) ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
