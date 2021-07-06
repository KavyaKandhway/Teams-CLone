import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;

  //SIGN UP METHOD
  Future<User?> signUp({String? email, String? password}) async {
    try {
      UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(email: email!, password: password!);
      User? user = userCredential.user;
      return user!;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  //SIGN IN METHOD
  Future<User?> signIn({String? email, String? password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      User user = userCredential.user!;
      return user;
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }
}
