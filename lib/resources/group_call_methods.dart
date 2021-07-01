import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teams_clone/constants/strings.dart';
import 'package:teams_clone/models/group_call.dart';

class GroupCallMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection(GROUP_CALL_COLLECTION);

  Stream<DocumentSnapshot> callStream({String uid}) =>
      callCollection.doc(uid).snapshots();
  Future<bool> makeGroupCall({GroupCall groupCall}) async {
    try {
      groupCall.hasDialed = true;
      Map<String, dynamic> hasDialedMap = groupCall.toMap(groupCall);

      await callCollection.doc(groupCall.callerId).set(hasDialedMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({GroupCall groupCall}) async {
    try {
      await callCollection.doc(groupCall.callerId).delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
