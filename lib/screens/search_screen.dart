import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/widgets/custom_tile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  List<UserClass> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurentUser().then((User user) {
      _repository.fetchAllUsers(user).then((List<UserClass> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  SearchAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 60,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                  child: TextField(
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                    decoration: InputDecoration(
                      hintText: "Search",
                      focusColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                    controller: searchController,
                    onChanged: (val) {
                      setState(() {
                        query = val;
                        print("query=" + query);
                      });
                    },
                    autofocus: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<UserClass> suggestionList = query.isEmpty
        ? []
        : userList.where((UserClass user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUserName = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);
            return (matchesName || matchesUserName);
          }).toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        UserClass searchedUser = UserClass(
          uid: suggestionList[index].uid,
          profilePhoto: suggestionList[index].profilePhoto,
          name: suggestionList[index].name,
          username: suggestionList[index].username,
        );
        return CustomTile(
            mini: false,
            onTap: () {},
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchedUser.profilePhoto),
              backgroundColor: Colors.indigo,
            ),
            title: Text(
              searchedUser.username,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              searchedUser.name,
              style: TextStyle(color: Colors.white),
            ));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: SearchAppBar(context),
        bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Expanded(
                    child: SizedBox(
                  height: 100,
                  child: buildSuggestions(query),
                )),
              ],
            )),
      ),
    );
  }
}
