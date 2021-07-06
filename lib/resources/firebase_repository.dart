import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:teams_clone/enum/user_state.dart';
import 'package:teams_clone/models/message.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/provider/image_upload_provider.dart';
import 'package:teams_clone/resources/firebase_methods.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Future<User> getCurentUser() => _firebaseMethods.getCurrentUser();

  Future<User> signIn() => _firebaseMethods.signIn();

  Future<UserClass> getUserDetails() => _firebaseMethods.getUserDetails();

  Future<bool> signOut() => _firebaseMethods.signOut();

  Future<bool> authenticateuser(User user) =>
      _firebaseMethods.authenticateUser(user);

  Future<void> addDataToDb(User user) => _firebaseMethods.addDataToDb(user);

  Future<List<UserClass>> fetchAllUsers(User user) =>
      _firebaseMethods.fetchAllUsers(user);

  Future<void> addMessageToDb(
          Message message, UserClass sender, UserClass receiver) =>
      _firebaseMethods.addMessageToDb(message, sender, receiver);

  void uploadImage(
          {@required File? image,
          @required String? receiverId,
          @required String? senderId,
          @required ImageUploadProvider? imageUploadProvider}) =>
      _firebaseMethods.uploadImage(
        image!,
        receiverId!,
        senderId!,
        imageUploadProvider!,
      );

  Stream<QuerySnapshot> fetchContacts({String? userId}) =>
      _firebaseMethods.fetchContacts(userId: userId!);

  Future<UserClass> getUserDetailsById(id) =>
      _firebaseMethods.getUserDetailsById(id);

  Stream<QuerySnapshot> fetchLastMessageBetween(
          {@required String? senderId, @required String? receiverId}) =>
      _firebaseMethods.fetchLastMessageBetween(
          senderId: senderId!, receiverId: receiverId!);

  Stream<DocumentSnapshot> getUsersStream({@required String? uid}) =>
      _firebaseMethods.getUsersStream(uid: uid!);

  void setUserState(
          {@required String? userId, @required UserState? userState}) =>
      _firebaseMethods.setUserState(userId: userId!, userState: userState!);
}
