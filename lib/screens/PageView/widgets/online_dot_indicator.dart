import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/enum/user_state.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/utils/utilities.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  OnlineDotIndicator({@required this.uid});
  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: _firebaseRepository.getUsersStream(
        uid: uid,
      ),
      builder: (context, snapshot) {
        UserClass user;
        if (snapshot.hasData && snapshot.data.data() != null) {
          user = UserClass.fromMap(snapshot.data.data());
        }
        return Container(
          height: 10,
          width: 10,
          margin: EdgeInsets.only(right: 8, top: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: getColor(user?.state),
          ),
        );
      },
    );
  }
}
