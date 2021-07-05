import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/resources/auth_methods.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/home_screen.dart';
import 'package:teams_clone/utils/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 100, 40, 50),
            child: Image.asset("images/teams_logo.png"),
          ),
          loginWithGoogleButton(),
          loginWithEmailButton(),
        ],
      )),
    );
  }

  Widget loginWithGoogleButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextButton(
          onPressed: () {
            performLoginWithGoogle();
          },
          child: Container(
            width: 500,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.indigo.shade500,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                "Login With Google",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
          )),
    );
  }

  Widget loginWithEmailButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return EmailPasswordScreen();
            }));
          },
          child: Container(
            width: 500,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.indigo.shade500,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                "Login With Email",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                  color: Colors.white,
                ),
              ),
            ),
          )),
    );
  }

  void performLoginWithGoogle() {
    _repository.signIn().then((User user) {
      if (user != null) {
        authenticateUser(user);
      } else {
        print("there was an error");
      }
    });
  }

  void authenticateUser(User user) {
    _repository.authenticateuser(user).then((isNewUser) {
      if (isNewUser) {
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}

class EmailPasswordScreen extends StatefulWidget {
  @override
  _EmailPasswordScreenState createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Enter email id",
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: email,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                "Enter password",
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: password,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                  ),
                  child: TextButton(
                    onPressed: () {
                      AuthenticationHelper()
                          .signIn(email: email.text, password: password.text)
                          .then((user) {
                        if (user != null) {
                          authenticateUser(user);
                        } else {
                          print("there was an error");
                        }
                      });
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                  ),
                  child: TextButton(
                    onPressed: () {
                      AuthenticationHelper()
                          .signUp(email: email.text, password: password.text)
                          .then((user) {
                        if (user != null) {
                          authenticateUser(user);
                        } else {
                          print("there was an error");
                        }
                      });
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void authenticateUser(User user) {
    _repository.authenticateuser(user).then((isNewUser) {
      if (isNewUser) {
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
