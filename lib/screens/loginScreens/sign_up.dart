import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:teams_clone/resources/auth_methods.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/home_screen.dart';
import 'package:teams_clone/screens/loginScreens/login_screen.dart';

import 'package:teams_clone/screens/loginScreens/login_screen_3.dart';
import 'package:teams_clone/screens/loginScreens/theme.dart';
import 'package:teams_clone/screens/loginScreens/values/values.dart';

class SignUpScreen3 extends StatefulWidget {
  ThemeBloc? themeBloc;
  SignUpScreen3({this.themeBloc});
  @override
  _SignUpScreen3State createState() => _SignUpScreen3State();
}

class _SignUpScreen3State extends State<SignUpScreen3> {
  FirebaseRepository _repository = FirebaseRepository();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey cardKey = GlobalKey();
  double buttonOffset = 40.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // executes after build
      getSizeOfCard();
    });
  }

  void getSizeOfCard() {
    final keyContext = cardKey.currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      setState(() {
        buttonOffset = (box.size.height / 2) - 30;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: ClipPath(
                clipper: CustomLoginShapeClipper5(),
                child: Container(
                  height: heightOfScreen,
                  decoration: BoxDecoration(
                    gradient: Gradients.curvesGradient1,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: ClipPath(
                clipper: CustomLoginShapeClipper3(),
                child: Container(
                  height: heightOfScreen,
                  decoration: BoxDecoration(
                    gradient: Gradients.curvesGradient2,
                  ),
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              Container(
                                height: heightOfScreen * 0.25,
                              ),
                              Text("REGISTER",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.blueGrey.shade100,
                                    fontSize: 25,
                                  )),
                              SizedBox(height: heightOfScreen * 0.08),
                              _buildForm(context: context),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildForm({@required BuildContext? context}) {
    var widthOfScreen = MediaQuery.of(context!).size.width;

    return Container(
      width: widthOfScreen,
      child: Stack(
        children: <Widget>[
          Container(
            width: widthOfScreen * 0.85,
            child: Card(
              color: Colors.blueGrey.shade800,
              key: cardKey,
              elevation: 4,
              margin: const EdgeInsets.only(
                left: 0,
                top: 8,
                bottom: 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(300.0),
                  bottomRight: Radius.circular(300.0),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: <Widget>[
                    CustomTextFormField(
                      textEditingController: email,
                      hasPrefixIcon: true,
                      prefixIcon: Icon(
                        FeatherIcons.mail,
                        color: AppColors.lightBlueShade1,
                        size: Sizes.ICON_SIZE_20,
                      ),
                      hintText: StringConst.EMAIL_ADDRESS,
                      hintTextStyle: Styles.customTextStyle(
                          color: AppColors.lightBlueShade2),
                      textStyle: Styles.customTextStyle(
                        color: Colors.blueGrey.shade100,
                      ),
                      contentPadding: EdgeInsets.only(top: Sizes.PADDING_16),
                      enabledBorder: Borders.noBorder,
                      border: Borders.noBorder,
                      focusedBorder: Borders.noBorder,
                    ),
                    Divider(color: AppColors.grey, height: Sizes.HEIGHT_16),
                    CustomTextFormField(
                      textEditingController: password,
                      hasPrefixIcon: true,
                      prefixIcon: Icon(
                        FeatherIcons.lock,
                        color: AppColors.lightBlueShade1,
                        size: Sizes.ICON_SIZE_20,
                      ),
                      hintTextStyle: Styles.customTextStyle(
                          color: AppColors.lightBlueShade2),
                      textStyle: Styles.customTextStyle(
                        color: Colors.blueGrey.shade100,
                      ),
                      hintText: StringConst.PASSWORD,
                      obscured: true,
                      contentPadding: EdgeInsets.only(top: Sizes.PADDING_16),
                      enabledBorder: Borders.noBorder,
                      border: Borders.noBorder,
                      focusedBorder: Borders.noBorder,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: widthOfScreen * 0.78,
            top: 50,
            child: Container(
              height: Sizes.HEIGHT_60,
              width: Sizes.WIDTH_60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey.shade800,
                    elevation: 8, //elevation of button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.RADIUS_30),
                    ),
                    padding: EdgeInsets.all(0)),
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
                child: Ink(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: Gradients.buttonGradient,
                  ),
                  child: Icon(
                    FeatherIcons.check,
                    size: Sizes.ICON_SIZE_30,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
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
