import 'dart:async';

import 'package:blogone/screens/cardview.dart';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:load/load.dart';

var jsonData, userid, username;

class SavedBlogs extends StatefulWidget {
  final String value;
  const SavedBlogs({Key? key, required this.value}) : super(key: key);

  @override
  _SavedBlogsState createState() => _SavedBlogsState();
}

class _SavedBlogsState extends State<SavedBlogs> {
  currentUser() async {
    //var token = await SharedPreferenceHelper().getToken();
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

  savedBlogs() async {
    //var token = await SharedPreferenceHelper().getToken();
    final uri =
        Uri.parse('http://manikandanblog.pythonanywhere.com/savedBlog/');

    final headers = {'Authorization': 'Token ' + widget.value.toString()};
    var response, statusCode;
    try {
      response = await http.get(
        uri,
        headers: headers,
      );
      statusCode = response.statusCode;
      jsonData = jsonDecode(response.body);
      setState(() {
        jsonData;
      });
      print(statusCode);
      print(jsonData);
    } on Exception catch (e) {
      print(e);
      print("error on saved blogs django api");
    }
    return jsonData;
  }

  @override
  void initState() {
    
    super.initState();
    savedBlogs();
    Timer(Duration(seconds: 1), () {
      hideLoadingDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Blogs'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              if (jsonData == null) Text("No Blogs"),
              if (jsonData != null)
                for (var i in jsonData)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CardFullView(
                                  blogid: i['blog_id'], value: widget.value)));
                    },
                    child: GFCard(
                      boxFit: BoxFit.cover,
                      titlePosition: GFPosition.end,
                      image: Image.network(
                        "http://manikandanblog.pythonanywhere.com${i['image']}",
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      showImage: true,
                      title: GFListTile(
                        avatar: GFAvatar(
                          size: 20,
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQfUbi5bgcsNaRtcbmG7dR3R8e_kLca43xIg&usqp=CAU'),
                        ),
                        titleText: '${i['title']}',
                        subTitleText: "${i['username']}",
                        icon: Container(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Icon(Icons.share),
                            Padding(padding: EdgeInsets.only(top: 50))
                          ],
                        )),
                      ),
                      content: Text("${i['short']}\n"),
                      buttonBar: GFButtonBar(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 220)),
                          InkWell(
                            child: Text("Read More"),
                            onTap: () {
                              print("j");
                            },
                          ),
                          Icon(
                            Icons.double_arrow,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
