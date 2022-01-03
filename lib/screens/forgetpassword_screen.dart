import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blogone/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var emailcontroller = new TextEditingController();
  var tokencontroller = new TextEditingController();
  var passwordcontroller = new TextEditingController();
  bool _isObscure = true;

  forgetpassword() async {
    final uri =
        Uri.parse('http://manikandanblog.pythonanywhere.com/password_reset/');
    final headers = {'Content-Type': 'application/json'};
    var response, fstatuscode, forgetresponsebody;
    Map<String, dynamic> body = {
      "email": emailcontroller.text.trim(),
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    try {
      response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      fstatuscode = response.statusCode;
      forgetresponsebody = json.decode(response.body);
      print(fstatuscode);
    } on Exception catch (e) {
      print(e);
    }
    return fstatuscode;
  }

  resetpassword() async {
    final uri = Uri.parse(
        'http://manikandanblog.pythonanywhere.com/password_reset/confirm/');
    final headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "password": passwordcontroller.text.trim(),
      "token": tokencontroller.text.trim()
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    var response, rstatuscode, resetresponsebody;

    try {
      response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      rstatuscode = response.statusCode;
      resetresponsebody = jsonDecode(response.body);

      print(resetresponsebody);
      print(rstatuscode);
      //print(statusCode);
    } on Exception catch (e) {
      print("error in reset password django api $e");
    }
    return rstatuscode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Forget Password',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: emailcontroller,
                onFieldSubmitted: (String str) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                )),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  forgetpassword().then((value) {
                    if (value == 200) {
                      Fluttertoast.showToast(
                          msg: "Mail Send Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      emailcontroller.text = "";
                    } else {
                      Fluttertoast.showToast(
                          msg: "Error in reset password",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  });
                },
                child: Text("Get Token")),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: tokencontroller,
                onFieldSubmitted: (String str) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Token',
                )),
            TextFormField(
                obscureText: _isObscure,
                controller: passwordcontroller,
                onFieldSubmitted: (String str) {
                  setState(() {});
                },
                decoration: InputDecoration(
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
                )),
            ElevatedButton(
                onPressed: () {
                  resetpassword().then((value) {
                    if (value == 200) {
                      Fluttertoast.showToast(
                          msg: "Reset Password Successful",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    } else {
                      Fluttertoast.showToast(
                          msg: "Error in reset Password",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 6,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  });
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
