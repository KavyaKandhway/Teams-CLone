import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teams_clone/resources/auth_methods.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/home_screen.dart';
import 'package:teams_clone/screens/loginScreens/login_screen.dart';
import 'package:teams_clone/screens/loginScreens/login_screen_3.dart';
import 'package:teams_clone/screens/loginScreens/theme.dart';
import 'package:teams_clone/utils/universal_variables.dart';

class LoginScreen extends StatefulWidget {
  ThemeBloc? themeBloc;
  LoginScreen({this.themeBloc});
  @override
  _LoginScreenState createState() => _LoginScreenState(themeBloc: themeBloc);
}

class _LoginScreenState extends State<LoginScreen> {
  ThemeBloc? themeBloc;
  _LoginScreenState({this.themeBloc});
  FirebaseRepository _repository = FirebaseRepository();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    themeBloc = ThemeBloc();
  }

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
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LoginScreen3(themeBloc: themeBloc);
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
