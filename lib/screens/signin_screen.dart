import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blogone/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var confirmcontroller = new TextEditingController();
  var usernamecontroller = new TextEditingController();
  var emailcontroller = new TextEditingController();
  bool _isObscure = true;
  bool _isConObscure = true;
  var passwordcontroller = new TextEditingController();

  signin() async {
    final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/register/');
    final headers = {'Content-Type': 'application/json'};
    var statuscode, responseBody;

    Map<String, dynamic> body = {
      "username": usernamecontroller.text.trim(),
      "email": emailcontroller.text.trim(),
      "password": passwordcontroller.text.trim()
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
      statuscode = response.statusCode;
      responseBody = jsonDecode(response.body);

      print(responseBody);
      print(statuscode);
    } on Exception catch (e) {
      print("Error in signin django api $e");
    }
    return statuscode;
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
              controller: emailcontroller,
              decoration: const InputDecoration(
                icon: const Icon(Icons.person),
                //hintText: 'Door no and Street Name',
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: passwordcontroller,
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
            TextFormField(
              onFieldSubmitted: (String str) {
                final String confirmPassword = confirmcontroller.text.trim();
                final String username = usernamecontroller.text.trim();
                final String email = emailcontroller.text.trim();
                final String password =
                    passwordcontroller.text.toString().trim();
                if (email.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Email field is empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  //print('Email field is empty');
                } else if (!email.contains('@')) {
                  Fluttertoast.showToast(
                      msg: "Email is not valid",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (password.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Password field is empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (password.length < 8) {
                  Fluttertoast.showToast(
                      msg: "Password should be greater than 7 letters",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (!password
                    .contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                  Fluttertoast.showToast(
                      msg: "Password should contain 1 special character",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (username.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Username field is empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  print("Username field is empty");
                } else if (username.length < 4) {
                  Fluttertoast.showToast(
                      msg: "Username should be grater than 3 letters",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else if (password != confirmPassword) {
                  Fluttertoast.showToast(
                      msg: "Password does not match",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  try {
                    signin().then((value) {
                      if (value == 201) {
                        Fluttertoast.showToast(
                            msg: "Registered Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Error signIn",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    });
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: e.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                }
              },
              controller: confirmcontroller,
              obscureText: _isConObscure,
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                //hintText: 'Door no and Street Name',
                labelText: 'Confirm Pasword',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isConObscure = !_isConObscure;
                    });
                  },
                  icon: Icon(
                      _isConObscure ? Icons.visibility : Icons.visibility_off),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  final String confirmPassword = confirmcontroller.text.trim();
                  final String username = usernamecontroller.text.trim();
                  final String email = emailcontroller.text.trim();
                  final String password =
                      passwordcontroller.text.toString().trim();
                  if (email.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Email field is empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);

                    //print('Email field is empty');
                  } else if (password.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Password field is empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    print("Password field is empty");
                  } else if (password.length < 8) {
                    Fluttertoast.showToast(
                        msg: "Password should be greater than 7 letters",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (!password
                      .contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                    Fluttertoast.showToast(
                        msg: "Password should contain 1 special character",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (username.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Username field is empty",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    print("Username field is empty");
                  } else if (username.length < 4) {
                    Fluttertoast.showToast(
                        msg: "Username should be grater than 3 letters",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (password != confirmPassword) {
                    Fluttertoast.showToast(
                        msg: "Password does not match",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 4,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    try {
                      signin().then((value) {
                        if (value == 201) {
                          Fluttertoast.showToast(
                              msg: "Registered Successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        } else {
                          Fluttertoast.showToast(
                              msg: "Error signin",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 4,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      });
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: e.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }
                },
                child: Text("SIGNUP")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text("Already Have an account? Login")),
          ],
        ),
      ),
    );
  }
}
