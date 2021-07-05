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
      Map<String, dynamic> hasDialedMap = groupCall.toMap(groupCall);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({GroupCall groupCall}) async {
    try {
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
