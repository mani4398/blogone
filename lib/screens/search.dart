import 'package:blogone/screens/cardview.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:share/share.dart';

class SearchBlog extends StatefulWidget {
  final String value;
  const SearchBlog({Key? key, required this.value}) : super(key: key);

  @override
  _SearchBlogState createState() => _SearchBlogState();
}

class _SearchBlogState extends State<SearchBlog> {
  var jsonData, username;
  var searchword = new TextEditingController();
  search() async {
    final uri = Uri.parse(
        'http://manikandanblog.pythonanywhere.com/blogs/?search=' +
            searchword.text.trim());

    final headers = {'Authorization': 'Token ' + widget.value.toString()};
    var response, statusCode;
    try {
      response = await http.get(
        uri,
        headers: headers,
      );
      statusCode = response.statusCode;
      jsonData = jsonDecode(response.body);

      print(statusCode);
      print(jsonData);

      setState(() {
        jsonData;
      });
    } on Exception catch (e) {
      print("error on view all blogs django api $e");
    }
    return jsonData;
  }

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
        username = responseBody['username'];
      });
      print(responseBody);

      //print(responseBody['id']);
    } on Exception catch (e) {
      print(e);
      print('error on current user');
    }
  }

  @override
  void initState() {
    super.initState();
    currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 20),
                  child: SizedBox(
                      width: 300,
                      child: TextField(
                        controller: searchword,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 5),
                  child: ElevatedButton(
                      onPressed: () {
                        if (searchword.text != "")
                          search();
                        else {
                          final snackBar = SnackBar(
                              content: Text('Textbox cannot be empty '));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text("Search"),
                      )),
                ),
              ],
            ),
            Column(
              children: [
                if (jsonData == null || jsonData == "") Text("No Blogs"),
                if (jsonData != null)
                  for (var i in jsonData.reversed.toList())
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CardFullView(
                                    blogid: i['blog_id'],
                                    value: widget.value)));
                      },
                      child: GFCard(
                        boxFit: BoxFit.cover,
                        titlePosition: GFPosition.end,
                        image: Image.network(
                          "${i['image']}",
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                        showImage: true,
                        title: GFListTile(
                          avatar: GFAvatar(
                            backgroundImage: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQfUbi5bgcsNaRtcbmG7dR3R8e_kLca43xIg&usqp=CAU'),
                          ),
                          titleText: '${i['title']}',
                          subTitleText: "${i['username']}",
                          icon: Container(
                              child: Row(
                            children: [
                              if ('${i['liked']}' == "false" &&
                                  '${i['username']}' != username)
                                Icon(Icons.favorite_border),
                              if ('${i['liked']}' == "true" &&
                                  '${i['username']}' != username)
                                Icon(Icons.favorite),
                              SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Share.share(
                                        'Checkout this post from blog app ' +
                                            i['title'] +
                                            ' \n' +
                                            i['short'] +
                                            '.....');
                                  },
                                  icon: Icon(Icons.share)),
                              Padding(padding: EdgeInsets.only(top: 50))
                            ],
                          )),
                        ),
                        // content: "${i['body']}".length > 20
                        //     ? Text("${i['body']}".substring(0, 25))
                        //     : Text("${i['body']}".substring(5)),
                        content: Text("${i['short']}"),
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
          ],
        ),
      ),
    );
  }
}
