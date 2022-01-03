import 'dart:convert';
import 'package:blogone/screens/card.dart';
import 'package:blogone/screens/signin_screen.dart';
import 'package:http/http.dart' as http;

import 'package:blogone/screens/forgetpassword_screen.dart';

import 'package:blogone/screens/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:load/load.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var usernamecontroller = new TextEditingController();
  var passwordcontroller = new TextEditingController();

  bool _isObscure = true;
  var token, responsebody, statusCode;
  login() async {
    final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/login/');
    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "username": usernamecontroller.text.trim(),
      "password": passwordcontroller.text.trim(),
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    var response;

    try {
      response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      statusCode = response.statusCode;
      responsebody = jsonDecode(response.body);

      print(responsebody);
      SharedPreferenceHelper().saveToken(responsebody["token"]);
      token = responsebody["token"];
      setState(() {});
      print(token);
    } on Exception catch (e) {
      print("error on login django api $e");
    }
    return statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            TextFormField(
              controller: usernamecontroller,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                //hintText: 'Door no and Street Name',
                labelText: 'Username',
              ),
            ),
            TextFormField(
              controller: passwordcontroller,
              onFieldSubmitted: (String str) {
                final String username = usernamecontroller.text.trim();
                final String password = passwordcontroller.text.trim();
                if (username.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "username field is empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  print('username field is empty');
                } else if (password.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Password field is empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  print("Password field is empty");
                } else {
                  try {
                    login().then((value) {
                      if (value == 201) {
                        showLoadingDialog();

                        Fluttertoast.showToast(
                            msg: "Logged in Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CardView(value: token)));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Invalid Credentials",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    });
                  } on Exception catch (e) {
                    Fluttertoast.showToast(
                        msg: "Invalid Credentials $e",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                }
              },
              obscureText: _isObscure,
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                //hintText: 'Door no and Street Name',
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  final String username = usernamecontroller.text.trim();
                  final String password = passwordcontroller.text.trim();
                  if (username.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "username field is empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    print('username field is empty');
                  } else if (password.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Password field is empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    print("Password field is empty");
                  } else {
                    try {
                      login().then((value) {
                        if (value == 201) {
                          showLoadingDialog();

                          Fluttertoast.showToast(
                              msg: "Logged in Successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CardView(value: token)));
                          //Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Invalid Credentials",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      });
                    } on Exception catch (e) {
                      Fluttertoast.showToast(
                          msg: "Invalid Credentials $e",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }
                },
                child: Text("LOGIN")),
            Container(
                child: Center(
                    child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ForgetPassword()));
              },
              child: Text("Forget Password?"),
            ))),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
                child: Text("Dont Have an account? Signin")),
          ],
        ),
      ),
    );
  }
}
