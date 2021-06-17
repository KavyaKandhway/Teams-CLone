import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teams_clone/constants/strings.dart';
import 'package:teams_clone/enum/user_state.dart';
import 'package:teams_clone/models/contact.dart';
import 'package:teams_clone/models/message.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/provider/image_upload_provider.dart';
import 'package:teams_clone/utils/utilities.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseMethods {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.Reference _storageReference;
  //user class

  static final CollectionReference _userCollection =
      firestore.collection(USERS_COLLECTION);
  static final CollectionReference _messageCollection =
      firestore.collection(MESSAGES_COLLECTION);
  UserClass userClass = UserClass();

  Future<User> getCurrentUser() async {
    Firebase.initializeApp();
    FirebaseAuth _auth = FirebaseAuth.instance;
    User currentUser;
    currentUser = await _auth.currentUser;
    return currentUser;
  }

  Future<UserClass> getUserDetails() async {
    User currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
        await _userCollection.doc(currentUser.uid).get();
    return UserClass.fromMap(documentSnapshot.data());
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
    addToContacts(senderId: message.senderId, receiverId: message.receiverId);
    return await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactsDocument({String of, String forContact}) =>
      _userCollection.doc(of).collection(CONTACTS_COLLECTION).doc(forContact);

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();
    await addToSendersContact(senderId, receiverId, currentTime);
    await addToReceiversContact(senderId, receiverId, currentTime);
  }

  Future<void> addToSendersContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();
    if (!senderSnapshot.exists) {
      Contact receiverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );

      var receiverMap = receiverContact.toMap(receiverContact);

      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(receiverMap);
    }
  }

  Future<void> addToReceiversContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();
    if (!receiverSnapshot.exists) {
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );

      var senderMap = senderContact.toMap(senderContact);

      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(senderMap);
    }
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      _storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('${DateTime.now().millisecondsSinceEpoch}');
      UploadTask _storageUploadTask = _storageReference.putFile(image);
      var url = (await _storageUploadTask).ref.getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message _message;
    _message = Message.imageMessage(
      message: "IMAGE",
      senderId: senderId,
      receiverId: receiverId,
      photoUrl: url,
      timeStamp: Timestamp.now(),
      type: 'image',
    );
    var map = _message.toImageMap();
    await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(_message.senderId)
        .collection(_message.receiverId)
        .add(map);
    await firestore
        .collection(MESSAGES_COLLECTION)
        .doc(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  void uploadImage(File image, String receiverId, String senderId,
      ImageUploadProvider imageUploadProvider) async {
    imageUploadProvider.setToLoading();
    String url = await uploadImageToStorage(image);
    imageUploadProvider.setToIdle();
    setImageMsg(url, receiverId, senderId);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) =>
      _userCollection.doc(userId).collection(CONTACTS_COLLECTION).snapshots();
  Stream<QuerySnapshot> fetchLastMessageBetween(
          {@required String senderId, @required String receiverId}) =>
      _messageCollection
          .doc(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();

  Future<UserClass> getUserDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(id).get();
      return UserClass.fromMap(documentSnapshot.data());
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setUserState({@required String userId, @required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    _userCollection.doc(userId).update({
      "state": stateNum,
    });
  }

  Stream<DocumentSnapshot> getUsersStream({@required String uid}) =>
      _userCollection.doc(uid).snapshots();
}
