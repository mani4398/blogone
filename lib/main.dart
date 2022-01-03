import 'package:blogone/screens/card.dart';
import 'package:blogone/screens/signin_screen.dart';
import 'package:blogone/screens/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:shared_preferences/shared_preferences.dart';

var token;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs =
  //                       await SharedPreferences.getInstance();
  //                   prefs.clear();
  token = await SharedPreferenceHelper().getToken();

  print('---------------------------');
  print(token);
  print('---------------------------');

  //runApp(MyApp());
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingProvider(
          themeData:
              LoadingThemeData(animDuration: Duration(milliseconds: 800)),
          child: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: token == null ? "signin" : "/",
      routes: {
        '/': (context) => CardView(value: token),
        "signin": (context) => SignIn()
      },
    );
  }
}
