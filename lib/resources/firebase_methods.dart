import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teams_clone/constants/strings.dart';
import 'package:teams_clone/models/message.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/utils/utilities.dart';

class FirebaseMethods {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //user class
  UserClass userClass = UserClass();
  Future<User> getCurrentUser() async {
    Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

  Future<User> signIn() async {
    Firebase.initializeApp();
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;
    FirebaseAuth _auth = FirebaseAuth.instance;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken,
    );
    UserCredential result = await _auth.signInWithCredential(credential);
    User user = result.user;
    return user;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where("email", isEqualTo: user.email)
        .get();
    final List<DocumentSnapshot> docs = result.docs;
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(User currentUser) async {
    String username = Utils.getUsername(currentUser.email);
    userClass = UserClass(
      uid: currentUser.uid,
      email: currentUser.email,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoURL,
      username: username,
    );
    firestore
        .collection(USERS_COLLECTION)
        .doc(currentUser.uid)
        .set(userClass.toMap(userClass));
  }

  Future<void> signOut() async {
    Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<UserClass>> fetchAllUsers(User user) async {
    List<UserClass> userList = [];
    QuerySnapshot querySnapshot =
        await firestore.collection(USERS_COLLECTION).get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      if (querySnapshot.docs[i].id != user.uid) {
        userList.add(UserClass.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(
      Message message, UserClass sender, UserClass receiver) async {
    var map = message.toMap();
    await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(message.senderId)
        .collection(message.receiverId)
        .add(map);
    return await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }
}
