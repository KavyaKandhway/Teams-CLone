import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/models/contact.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/provider/user_provider.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/PageView/chat_screen.dart';
import 'package:teams_clone/screens/PageView/widgets/last_message_container.dart';
import 'package:teams_clone/screens/PageView/widgets/online_dot_indicator.dart';

import 'package:teams_clone/widgets/cached_image.dart';
import 'package:teams_clone/widgets/custom_tile.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  ContactView({this.contact});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserClass>(
      future: _firebaseRepository.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserClass user = snapshot.data;
          return ViewLayout(contact: user);
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final UserClass contact;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  ViewLayout({@required this.contact});
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return CustomTile(
      subtitle: LastMessageContainer(
        stream: _firebaseRepository.fetchLastMessageBetween(
            senderId: userProvider.getUSer.uid, receiverId: contact.uid),
      ),
      mini: false,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      receiver: contact,
                    )));
      },
      title: Text(
        contact?.name ?? "..",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      leading: Container(
        constraints: BoxConstraints(
          maxHeight: 60,
          maxWidth: 60,
        ),
        child: Stack(
          children: [
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(uid: contact.uid),
          ],
        ),
      ),
    );
  }
}
