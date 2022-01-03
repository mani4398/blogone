import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';
import 'package:async/async.dart';

class AddBlog extends StatefulWidget {
  final String value;
  const AddBlog({Key? key, required this.value}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  var titlecontroller = new TextEditingController();
  var desccontroller = new TextEditingController();
  var imagecontroller = new TextEditingController();
  var uid, ppp;
  late File _image;
  var multipartFile;
  bool picked = false;

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

      print(responseBody);
      setState(() {
        uid = responseBody['id'];
      });
    } on Exception catch (e) {
      print(e);
      print('error on current user');
    }
    return responseBody;
  }

  dynamic generateOrderId() {
    var rnd = new Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }

    return ('ord' + next.toInt().toString());
  }

  @override
  void initState() {
    currentUser();
  }

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    try {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        picked = true;
        print('image fetched');
      } else {
        picked = false;
        print('No image selected.');
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "No Image Selected $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    setState(() {});
  }

  upload(File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://manikandanblog.pythonanywhere.com/");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // add headers with Auth token
    Map<String, String> headers = {
      'Authorization': 'Token ' + widget.value.toString()
    };
// "blog_id": id,
//       "user_id_id": uid,
//       "title": titlecontroller.text.trim(),
//       "body": desccontroller.text.trim(),
//       "image": upload(_image)
    var id = generateOrderId();
    request.headers.addAll(headers);
    request.fields['blog_id'] = id;
    request.fields['user_id_id'] = uid.toString();
    request.fields['title'] = titlecontroller.text.trim();
    request.fields['body'] = desccontroller.text.trim();
    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  // createBlog() async {
  //   //upload(_image);

  //   // add file to multipart

  //   var id = generateOrderId();

  //   final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/');

  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Token ' + widget.value.toString()
  //   };
  //   Map<String, dynamic> body = {
  //     "blog_id": id,
  //     "user_id_id": uid,
  //     "title": titlecontroller.text.trim(),
  //     "body": desccontroller.text.trim(),
  //     "image": upload(_image)
  //   };
  //   String jsonBody = json.encode(body);
  //   //final encoding = Encoding.getByName('utf-8');
  //   var response;
  //   int statusCode;
  //   String responseBody;
  //   try {
  //     response = await http.post(
  //       uri,
  //       headers: headers,
  //       body: jsonBody,
  //       //encoding: encoding,
  //     );
  //     statusCode = response.statusCode;
  //     responseBody = response.body;
  //     print(responseBody);
  //     print(statusCode);
  //   } on Exception catch (e) {
  //     print("error on create blog django api");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Blog"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Column(
            children: [
              //if (_image.path != "") Image.file(_image),
              // SizedBox(
              //   child: Flexible(
              //       child:
              //           // ignore: unnecessary_null_comparison
              //           _image.path != null
              //               ? Text("Image got")
              //               : Text('no Image')),
              // ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: titlecontroller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: const Icon(Icons.person),
                  hintText: 'Blog Title',
                  //labelText: 'Blog Title',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: desccontroller,
                decoration: const InputDecoration(
                  //isDense: true,
                  border: OutlineInputBorder(),

                  icon: const Icon(Icons.person),

                  hintText: 'Blog Description',
                  //labelText: 'Blog Title',
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    // ignore: non_constant_identifier_names
                    getImage().then((PickedFile) {
                      try {
                        if (picked == true) {
                          ppp = _image.path;
                          final snackBar = SnackBar(content: Text(_image.path));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          ppp = "";
                          final snackBar =
                              SnackBar(content: Text('Image not picked'));

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } on Exception catch (e) {
                        Fluttertoast.showToast(
                            msg: "No Image Selected $e",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 4,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    });
                  },
                  child: Text("Get Image")),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child:
                    Text(picked != false ? _image.path : 'No image Selected'),
              ),

              ElevatedButton(
                  onPressed: () {
                    final String title = titlecontroller.text.trim();
                    final String desc = desccontroller.text.trim();

                    if (title.isNotEmpty && desc.isNotEmpty && ppp != null) {
                      upload(_image).then((_) {
                        Navigator.pop(context);

                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             CardView(value: widget.value)));
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "Fields Cannot be empty",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: Text("Create Blog")),
            ],
          ),
        ),
      ),
    );
  }
}
