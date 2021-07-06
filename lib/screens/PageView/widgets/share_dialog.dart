import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/models/contact.dart';
import 'package:teams_clone/provider/user_provider.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/PageView/widgets/contact_share_view.dart';

class ShareDialog extends StatefulWidget {
  final String? roomId;
  ShareDialog({this.roomId});
  @override
  _ShareDialogState createState() => _ShareDialogState(
        roomId: roomId,
      );
}

class _ShareDialogState extends State<ShareDialog> {
  String? roomId;
  _ShareDialogState({this.roomId});
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Share"),
      ),
      backgroundColor: Colors.grey.shade800,
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firebaseRepository.fetchContacts(
                userId: userProvider.getUSer!.uid!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var docList = snapshot.data!.docs;

                if (docList.isEmpty) {
                  return Container();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10),
                  itemCount: docList.length,
                  itemBuilder: (context, index) {
                    Contact? contact = Contact.fromMap(
                        docList[index].data() as Map<String, dynamic>);

                    return ContactShareView(
                      roomId: roomId,
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
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(5),
            ),
            height: 50,
            width: 200,
            child: Center(
              child: TextButton(
                onPressed: () async {
                  await FlutterShare.share(
                    title: 'Invitation for group video call',
                    text: 'Hey there,\nEnter room ID to join the call.\n' +
                        'ID- *' +
                        roomId! +
                        '*',
                  );
                },
                child: Text(
                  "Share on Other Apps",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
