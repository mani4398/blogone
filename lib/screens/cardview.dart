import 'dart:convert';

import 'package:blogone/screens/savedblogs_screen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:load/load.dart';

class CardFullView extends StatefulWidget {
  final String blogid;
  final String value;
  const CardFullView({Key? key, id, required this.blogid, required this.value})
      : super(key: key);

  @override
  _CardFullViewState createState() => _CardFullViewState();
}

class _CardFullViewState extends State<CardFullView> {
  final double circleRadius = 100.0;
  final double circleBorderWidth = 8.0;
  var vjsonData, username, userid;
  viewOneBlog() async {
    final uri = Uri.parse(
        'http://manikandanblog.pythonanywhere.com/getblog/${widget.blogid}');

    final headers = {'Authorization': 'Token ' + widget.value.toString()};
    var vresponse;
    try {
      vresponse = await http.get(
        uri,
        headers: headers,
      );
      //statusCode = vresponse.statusCode;
      vjsonData = jsonDecode(vresponse.body);
      setState(() {
        vjsonData;
      });
      print(vjsonData);

      //print(statusCode);
    } on Exception catch (e) {
      print("error on view one blog django api $e");
    }
    return vjsonData;
  }

  currentUser() async {
    final uri =
        Uri.parse('http://manikandanblog.pythonanywhere.com/currentuser/');
    final headers = {'Authorization': 'Token ' + widget.value.toString()};
    var currentuserresponse, responseBody;

    try {
      currentuserresponse = await http.get(
        uri,
        headers: headers,
        //body: jsonBody,
        //encoding: encoding,
      );

      responseBody = jsonDecode(currentuserresponse.body);
      setState(() {
        userid = responseBody['id'];
        username = responseBody['username'];
      });
      print(responseBody);

      //print(responseBody['id']);
    } on Exception catch (e) {
      print(e);
      print('error on current user');
    }
  }

  saveBlog() async {
    final uri = Uri.parse(
        'http://manikandanblog.pythonanywhere.com/updateBlog/${widget.blogid}');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ' + widget.value.toString()
    };
    Map<String, dynamic> body = {
      "blog_id": widget.blogid,
      "user_id_id": '${vjsonData['user_id_id']}'.toString(),
      "created": '${vjsonData['created']}'.toString(),
      "title": '${vjsonData['title']}'.toString(),
      "body": '${vjsonData['body']}'.toString(),
      "likes": List.filled(userid, userid, growable: true),
    };
    String jsonBody = json.encode(body);
    //final encoding = Encoding.getByName('utf-8');
    var response;
    int statusCode;
    String responseBody;
    try {
      response = await http.put(
        uri,
        headers: headers,
        body: jsonBody,
        //encoding: encoding,
      );
      statusCode = response.statusCode;
      responseBody = response.body;
      print(responseBody);
      print(statusCode);
    } on Exception catch (e) {
      print(e);
      print("error on update blog func");
    }
  }

  unSaveBlog() async {
    final uri = Uri.parse(
        'http://manikandanblog.pythonanywhere.com/unSaveBlog/${widget.blogid}');
    final headers = {'Authorization': 'Token ' + widget.value.toString()};
    try {
      var currentresponse = await http.post(
        uri,
        headers: headers,
        //body: jsonBody,
        //encoding: encoding,
      );
    } on Exception catch (e) {
      print("Error on unSaveBlog function $e");
    }
  }

  @override
  void initState() {
    super.initState();
    currentUser();
    viewOneBlog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            if (vjsonData == null) Text(""),
            if (vjsonData != null)
              Container(
                child: Stack(
                  children: <Widget>[
                    if (vjsonData == null) Text(""),
                    if (vjsonData != null)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Container(
                          child: ClipRRect(
                            child: Image(
                              image: NetworkImage(
                                  'http://manikandanblog.pythonanywhere.com${vjsonData['image']}'),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60.0),
                              topRight: Radius.circular(60.0)),
                        ),
                        child: SizedBox(width: 1),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 0,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            // IconButton(
                            //     icon: Icon(
                            //       Icons.bookmark_border,
                            //       color: Colors.white,
                            //       size: 30,
                            //     ),
                            //     onPressed: () {}),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            Container(
              //height: 700,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (vjsonData == null) Text(""),
                    if (vjsonData != null)
                      Text(
                        " ${vjsonData['title']}",
                        style: TextStyle(
                            fontSize: 28.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2),
                      ),
                    if (vjsonData == null) Text(""),
                    if (vjsonData != null)
                      if ('${vjsonData['likes']}'.contains(userid.toString()) ==
                              false &&
                          '${vjsonData['username']}' != username)
                        Padding(
                          padding: const EdgeInsets.only(left: 300.0),
                          child: IconButton(
                              onPressed: () {
                                saveBlog().then((_) {
                                  showLoadingDialog();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SavedBlogs(value: widget.value)));
                                });
                                print('saving');
                              },
                              icon: Icon(Icons.favorite_border)),
                        ),
                    if (vjsonData == null) Text(""),
                    if (vjsonData != null)
                      if ('${vjsonData['likes']}'.contains(userid.toString()) ==
                              true &&
                          '${vjsonData['username']}' != username)
                        Padding(
                          padding: const EdgeInsets.only(left: 300.0),
                          child: IconButton(
                              onPressed: () {
                                unSaveBlog().then((_) {
                                  showLoadingDialog();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SavedBlogs(value: widget.value)));
                                });
                                print('unsaving');
                              },
                              icon: Icon(Icons.favorite)),
                        ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.timer,
                              color: Colors.grey,
                              size: 16.0,
                            ),
                            SizedBox(width: 2.0),
                            if (vjsonData == null) Text(""),
                            if (vjsonData != null)
                              Text(
                                " ${vjsonData['created']}",
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
                              ),
                            //SizedBox(width: 130.0),
                            // IconButton(
                            //     icon: Icon(
                            //       widget.blog.liked == "true"
                            //           ? Icons.bookmark
                            //           : Icons.bookmark_border,
                            //       color: Colors.black,
                            //       size: 30,
                            //     ),
                            //     onPressed: () {}),
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Row(
                          children: <Widget>[
                            // Icon(
                            //   Icons.remove_red_eye,
                            //   color: Colors.grey,
                            //   size: 16.0,
                            // ),
                            SizedBox(width: 2.0),
                            // Text(
                            //   "7k Views",
                            //   style:
                            //       TextStyle(color: Colors.grey, fontSize: 16.0),
                            // )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQfUbi5bgcsNaRtcbmG7dR3R8e_kLca43xIg&usqp=CAU'),
                          radius: 28.0,
                        ),
                        SizedBox(width: 10.0),
                        if (vjsonData == null) Text(""),
                        if (vjsonData != null)
                          Text(
                            " ${vjsonData['username']}",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8),
                          )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    if (vjsonData == null) Text(""),
                    if (vjsonData != null)
                      Text(
                        " ${vjsonData['body']}",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                            letterSpacing: 1),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
