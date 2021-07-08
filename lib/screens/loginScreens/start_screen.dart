import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/home_screen.dart';
import 'package:teams_clone/screens/loginScreens/clip.dart';

import 'package:teams_clone/screens/loginScreens/login_screen_3.dart';
import 'package:teams_clone/screens/loginScreens/theme.dart';
import 'package:teams_clone/screens/loginScreens/values/values.dart';

class StartScreen extends StatefulWidget {
  ThemeBloc? themeBloc;
  StartScreen({this.themeBloc});
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
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
                              Text(
                                "Let's get started!",
                                textAlign: TextAlign.center,
                                style: textTheme.headline!.copyWith(
                                    color: Colors.blueGrey.shade200,
                                    fontSize: 30),
                              ),
                              SizedBox(height: heightOfScreen * 0.10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: CustomButton(
                                  title: StringConst.SIGN_IN,
                                  textStyle: textTheme.title!.copyWith(
                                      color: Colors.blueGrey.shade900),
                                  color: Colors.blueGrey.shade50,
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return LoginScreen3(
                                          themeBloc: widget.themeBloc);
                                    }));
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: Sizes.MARGIN_16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: CustomDivider(
                                          color: Colors.blueGrey.shade100),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text("OR",
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade100,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: CustomDivider(
                                            color: Colors.blueGrey.shade100)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: CustomButton(
                                  title: StringConst.SIGN_IN_WITH_GOOGLE,
                                  textStyle: textTheme.title,
                                  hasIcon: true,
                                  color: Colors.blueGrey.shade50,
                                  onPressed: () {
                                    performLoginWithGoogle();
                                  },
                                  icon: Image.asset(
                                    'images/google.png',
                                    height: Sizes.HEIGHT_25,
                                    width: Sizes.WIDTH_25,
                                  ),
                                ),
                              ),
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

class CustomButton extends StatelessWidget {
  CustomButton({
    this.title,
    this.onPressed,
//    this.width = Sizes.WIDTH_150,
    this.height = Sizes.HEIGHT_50,
    this.elevation = Sizes.ELEVATION_1,
    this.borderRadius = Sizes.RADIUS_24,
    this.color = AppColors.blackShade5,
    this.borderSide = Borders.defaultPrimaryBorder,
    this.textStyle,
    this.icon,
    this.hasIcon = false,
  });

  final VoidCallback? onPressed;
//  final double width;
  final double? height;
  final double? elevation;
  final double? borderRadius;
  final String? title;
  final Color? color;
  final BorderSide? borderSide;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool? hasIcon;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: elevation,
//      minWidth: width ?? MediaQuery.of(context).size.width,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius!),
        side: borderSide!,
      ),

      height: height,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          hasIcon! ? icon! : Container(),
          hasIcon!
              ? SizedBox(
                  width: 15,
                )
              : Container(),
          title != null
              ? Text(
                  title!,
                  style: textStyle,
                )
              : Container(),
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  CustomDivider({
    this.width = Sizes.WIDTH_80,
    this.height = Sizes.HEIGHT_1,
    this.color = AppColors.white,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: color,
    );
  }
}
