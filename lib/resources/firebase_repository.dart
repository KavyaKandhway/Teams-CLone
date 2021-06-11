import 'package:firebase_auth/firebase_auth.dart';
import 'package:teams_clone/resources/firebase_methods.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseRepository {
  FirebaseMethods _firebaseMethods = FirebaseMethods();
  Future<User> getCurentUser() => _firebaseMethods.getCurrentUser();
  Future<User> signIn() => _firebaseMethods.signIn();
  Future<void> signOut() => _firebaseMethods.signOut();
  Future<bool> authenticateuser(User user) =>
      _firebaseMethods.authenticateUser(user);
  Future<void> addDataToDb(User user) => _firebaseMethods.addDataToDb(user);
}
