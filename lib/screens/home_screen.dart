import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController;
  int _page = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: PageView(
        children: [
          Center(
            child: Text("Activity Screen"),
          ),
          Center(
            child: Text("Chat List Screen"),
          ),
          Center(
            child: Text("Meet Screen"),
          ),
          Center(
            child: Text("Contact List"),
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
                  (_page == 0) ? Icons.notifications : Icons.notifications_none,
                  color: (_page == 0) ? Colors.white : Colors.grey,
                ),
                title: Text(
                  "Activity",
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
                  (_page == 2) ? Icons.videocam : Icons.videocam_outlined,
                  color: (_page == 2) ? Colors.white : Colors.grey,
                ),
                title: Text(
                  "Meet",
                  style: TextStyle(
                    color: (_page == 2) ? Colors.white : Colors.grey,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.more_horiz_rounded,
                  color: (_page == 3) ? Colors.white : Colors.grey,
                ),
                title: Text(
                  "More",
                  style: TextStyle(
                    color: (_page == 3) ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ],
            onTap: navigationTapped,
            currentIndex: _page,
          ),
        ),
      ),
    );
  }
}
