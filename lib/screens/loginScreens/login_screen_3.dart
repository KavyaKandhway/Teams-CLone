import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:teams_clone/resources/auth_methods.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/home_screen.dart';
import 'package:teams_clone/screens/loginScreens/design_theme.dart';
import 'package:teams_clone/screens/loginScreens/login_screen.dart';
import 'package:teams_clone/screens/loginScreens/sign_up.dart';
import 'package:teams_clone/screens/loginScreens/theme.dart';
import 'package:teams_clone/screens/loginScreens/values/values.dart';

class LoginScreen3 extends StatefulWidget {
  LoginScreen3({@required this.themeBloc});

  ThemeBloc? themeBloc;

  @override
  _LoginScreen3State createState() => _LoginScreen3State();
}

class _LoginScreen3State extends State<LoginScreen3> {
  FirebaseRepository _repository = FirebaseRepository();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey key = GlobalKey();
  double buttonOffset = 40.0;
  double textOffset = 60.0;

  @override
  void initState() {
    super.initState();
    widget.themeBloc!.selectedTheme.add(_buildLightTheme());
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // executes after build
      getSizeOfCard();
    });
  }

  CurrentTheme _buildLightTheme() {
    return CurrentTheme('light', LoginDesign1Theme.lightThemeData);
  }

  void getSizeOfCard() {
    final keyContext = key.currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      setState(() {
        buttonOffset = (box.size.height / 2) - 30;
        textOffset = box.size.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var heightOfScreen = MediaQuery.of(context).size.height;
    var widthOfScreen = MediaQuery.of(context).size.width;
    var textTheme = Theme.of(context).textTheme;
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
            Positioned(
              child: Container(
                margin: const EdgeInsets.all(Sizes.MARGIN_0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: <Widget>[
                          Container(
                            height: heightOfScreen * 0.25,
                          ),
                          Text("LOGIN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueGrey.shade100,
                                fontSize: 25,
                              )),
                          SizedBox(height: heightOfScreen * 0.05),
                          _buildForm(context: context),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: (widthOfScreen * 0.75)),
                            child: Text(
                              "Forgot ?",
                              style: textTheme.body1!.copyWith(
                                fontSize: Sizes.TEXT_SIZE_16,
                                color: AppColors.lightBlueShade1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 60,
                            width: 120,
                            margin:
                                EdgeInsets.only(right: (widthOfScreen - 120)),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey.shade800,
                                  elevation: 4, //elevation of button
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(20)),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SignUpScreen3(
                                    themeBloc: widget.themeBloc,
                                  );
                                }));
                              },
                              child: Text(
                                StringConst.REGISTER,
                                style: textTheme.button!.copyWith(
                                  color: AppColors.orangeShade1,
                                ),
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
      ),
    );
  }

  Widget _buildForm({@required BuildContext? context}) {
    var widthOfScreen = MediaQuery.of(context!).size.width;

    return Container(
      width: widthOfScreen,
      key: key,
      child: Stack(
        children: <Widget>[
          Container(
            width: widthOfScreen * 0.85,
            child: Card(
              color: Colors.blueGrey.shade800,
              elevation: Sizes.ELEVATION_4,
              margin: const EdgeInsets.only(
                left: Sizes.MARGIN_0,
                top: Sizes.MARGIN_8,
                bottom: Sizes.MARGIN_8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60.0),
                  bottomRight: Radius.circular(60.0),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: Sizes.MARGIN_16),
                child: Column(
                  children: <Widget>[
                    CustomTextFormField(
                      hasPrefixIcon: true,
                      prefixIcon: Icon(
                        FeatherIcons.user,
                        color: AppColors.lightBlueShade1,
                        size: Sizes.ICON_SIZE_20,
                      ),
                      hintText: StringConst.EMAIL_2,
                      textEditingController: email,
                      hintTextStyle: Styles.customTextStyle(
                        color: AppColors.lightBlueShade2,
                      ),
                      textStyle: Styles.customTextStyle(
                        color: Colors.blueGrey.shade100,
                      ),
                      contentPadding: EdgeInsets.only(top: Sizes.PADDING_16),
                      enabledBorder: Borders.noBorder,
                      border: Borders.noBorder,
                      focusedBorder: Borders.noBorder,
                    ),
                    Divider(
                      color: AppColors.grey,
                      height: Sizes.HEIGHT_20,
                    ),
                    CustomTextFormField(
                      hasPrefixIcon: true,
                      prefixIcon: Icon(
                        FeatherIcons.lock,
                        color: AppColors.lightBlueShade1,
                        size: Sizes.ICON_SIZE_20,
                      ),
                      hintText: "********",
                      hintTextStyle: Styles.customTextStyle(
                        color: AppColors.lightBlueShade2,
                      ),
                      textStyle: Styles.customTextStyle(
                        color: Colors.blueGrey.shade100,
                      ),
                      textEditingController: password,
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
            left: widthOfScreen * 0.75,
            top: buttonOffset,
            child: Container(
              height: Sizes.HEIGHT_60,
              width: Sizes.WIDTH_60,
              child: RaisedButton(
                padding: const EdgeInsets.all(Sizes.PADDING_0),
                elevation: Sizes.ELEVATION_8,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.RADIUS_30),
                ),
                child: Ink(
                  height: Sizes.HEIGHT_60,
                  width: Sizes.WIDTH_60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.RADIUS_30),
                    gradient: Gradients.buttonGradient,
                  ),
                  child: Icon(
                    FeatherIcons.arrowRight,
                    size: Sizes.ICON_SIZE_30,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: widthOfScreen * 0.75,
            top: textOffset + 16,
            child: Container(
              child: Text("Forgot"),
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

class CustomTextFormField extends StatelessWidget {
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? labelStyle;
  final TextStyle? titleStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? labelText;
  final String? title;
  final bool? obscured;
  final bool? hasPrefixIcon;
  final bool? hasSuffixIcon;
  final bool? hasTitle;
  final bool? hasTitleIcon;
  final Widget? titleIcon;
  final TextInputType? textInputType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? textFormFieldMargin;
  final TextEditingController? textEditingController;

  CustomTextFormField({
    this.textEditingController,
    this.prefixIcon,
    this.suffixIcon,
    this.textStyle,
    this.hintTextStyle,
    this.labelStyle,
    this.titleStyle,
    this.titleIcon,
    this.hasTitleIcon = false,
    this.title,
    this.contentPadding,
    this.textFormFieldMargin,
    this.hasTitle = false,
    this.border = Borders.primaryInputBorder,
    this.focusedBorder = Borders.focusedBorder,
    this.enabledBorder = Borders.enabledBorder,
    this.hintText,
    this.labelText,
    this.hasPrefixIcon = false,
    this.hasSuffixIcon = false,
    this.obscured = false,
    this.textInputType,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            hasTitleIcon! ? titleIcon! : Container(),
            hasTitle! ? Text(title!, style: titleStyle) : Container(),
          ],
        ),
//        hasTitle ? SpaceH4() : Container(),
        Container(
          width: width,
          height: height,
          margin: textFormFieldMargin,
          child: TextFormField(
            controller: textEditingController,
            style: textStyle,
            keyboardType: textInputType,
            onChanged: onChanged,
            validator: validator,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              contentPadding: contentPadding,
              labelText: labelText,
              labelStyle: labelStyle,
              border: border,
              enabledBorder: enabledBorder,
              focusedBorder: focusedBorder,
              prefixIcon: hasPrefixIcon! ? prefixIcon : null,
              suffixIcon: hasSuffixIcon! ? suffixIcon : null,
              hintText: hintText,
              hintStyle: hintTextStyle,
            ),
            obscureText: obscured!,
          ),
        ),
      ],
    );
  }
}
