import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:teams_clone/provider/image_upload_provider.dart';
import 'package:teams_clone/resources/firebase_repository.dart';
import 'package:teams_clone/screens/home_screen.dart';
import 'package:teams_clone/screens/loginScreens/start_screen.dart';
import 'package:teams_clone/screens/loginScreens/theme.dart';
import 'package:teams_clone/screens/login_screen.dart';
import 'package:teams_clone/screens/search_screen.dart';
import 'package:teams_clone/provider/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeBloc? _themeBloc;

  FirebaseRepository _repository = FirebaseRepository();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _themeBloc = ThemeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: StreamBuilder<ThemeData>(
          initialData: _themeBloc!.initialTheme().data,
          stream: _themeBloc!.themeDataStream,
          builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
            return MaterialApp(
              title: "Teams Clone",
              theme: ThemeData.light().copyWith(
                hintColor: Colors.grey,
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: "/",
              routes: {
                '/search_screen': (context) => SearchScreen(),
              },
              home: FutureBuilder(
                future: _repository.getCurentUser(),
                builder: (context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.hasData) {
                    return HomeScreen();
                  } else {
                    return StartScreen(
                      themeBloc: _themeBloc,
                    );
                  }
                },
              ),
            );
          }),
    );
  }
}
