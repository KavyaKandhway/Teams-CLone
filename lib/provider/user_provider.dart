import 'package:flutter/cupertino.dart';
import 'package:teams_clone/models/user.dart';
import 'package:teams_clone/resources/firebase_repository.dart';

class UserProvider with ChangeNotifier {
  UserClass _user;
  FirebaseRepository _firebaseRepository = FirebaseRepository();

  UserClass get getUSer => _user;

  Future<void> refreshUser() async {
    UserClass user = await _firebaseRepository.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
