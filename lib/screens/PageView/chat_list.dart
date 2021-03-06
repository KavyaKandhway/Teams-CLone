import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/models/contact.dart';
import 'package:teams_clone/provider/user_provider.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/PageView/widgets/contact_view.dart';
import 'package:teams_clone/screens/PageView/widgets/new_chat_button.dart';
import 'package:teams_clone/screens/PageView/widgets/user_circle.dart';
import 'package:teams_clone/screens/loginScreens/values/values.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:teams_clone/widgets/app_bart.dart';
import 'package:teams_clone/widgets/custom_tile.dart';
import 'package:teams_clone/screens/PageView/widgets/quiet_box.dart';

final FirebaseRepository _repository = FirebaseRepository();

class ChatListScreen extends StatelessWidget {
  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      actions: [
        IconButton(
            icon: Icon(
              Icons.sort,
              color: Colors.white,
            ),
            onPressed: () {})
      ],
      gradient: Gradients.headerOverlayGradient,
      centerTitle: false,
      title: Text("Chat"),
      leading: UserCircle(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade900,
        appBar: customAppBar(context),
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/search_screen");
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade700,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    Text(
                      "Search",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          child: Expanded(
            child: SizedBox(
              height: 400,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebaseRepository.fetchContacts(
                    userId: userProvider.getUSer!.uid!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var docList = snapshot.data!.docs;

                    if (docList.isEmpty) {
                      return QuietBox(
                        heading: "This is where all chats are listed",
                        subtitle:
                            "Add your friends and family to start chatting",
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: docList.length,
                      itemBuilder: (context, index) {
                        Contact? contact = Contact.fromMap(
                            docList[index].data() as Map<String, dynamic>);
                        return ContactView(
                          contact: contact,
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
