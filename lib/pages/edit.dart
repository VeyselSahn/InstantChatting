import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instantchatting/modals/user.dart';
import 'package:instantchatting/services/auth.dart';
import 'package:instantchatting/services/firestore.dart';
import 'package:instantchatting/services/storage.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';


class edit extends StatefulWidget {
  final Person person;

  const edit({Key key, this.person}) : super(key: key);

  @override
  _editState createState() => _editState();
}

class _editState extends State<edit> {
  String username, regard;
  File file;
  String  exp = "It isn't active";

  bool _loading = false;
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 15.0),
            icon: Icon(
              Icons.check,
            ),
            color: Colors.black,
            alignment: Alignment.centerRight,
            onPressed: () => _save(),
          ),
        ],
      ),
      body:
         ListView(
            children: [
              _loading
                  ? LinearProgressIndicator()
                  : SizedBox(
                height: 0.0,
              ),
              profileS(),
              textS()
            ],
          )


    );
  }

  _save() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      _formKey.currentState.save();

      String photoUrl;
      if (file == null) {
        photoUrl = widget.person.picture;
      } else {
        photoUrl = await storage().profileStorage(file);
      }

      final _id =
          Provider.of<Auth>(context, listen: false).profileowner;
      firestore().updateUser(
        id: _id,username:username,picture: photoUrl
      );
    }
    setState(() {
      _loading = false;
    });

    Navigator.pop(context);
  }

  void chooseGallery() async {
    final _picker = ImagePicker();
    var image = await _picker.getImage(
        source: ImageSource.gallery,
        maxHeight: 400,
        maxWidth: 600,
        imageQuality: 100);
    setState(() {
      file = File(image.path);
    });
  }

  Widget profileS() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Center(
        child: InkWell(
          onTap: () => chooseGallery(),
          child: CircleAvatar(
            radius: 55.0,
            backgroundImage: file == null
                ? NetworkImage(widget.person.picture)
                : FileImage(file),
          ),
        ),
      ),
    );
  }

  Widget textS() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              initialValue: widget.person.username,
              decoration: InputDecoration(labelText: "Username"),
              validator: (value) {
                if (value.trim().length < 4)
                  return "Username must be longer 4";
                else if (value.trim().length > 50)
                  return "Username can't be longer 50 ";
                else
                  return null;
              },
              onSaved: (newValue) => username = newValue,
            ),
            SizedBox(
              height: 20.0,
            ),
            TextFormField(
              initialValue: exp,
              decoration: InputDecoration(labelText: "About Me"),
              validator: (value) {
                if (value != null) {
                  return null;
                } else
                  return "Email can't be empty";
              },
              onSaved: (newValue) {setState(() {
                exp = newValue;
              });},
            ),
          ],
        ),
      ),
    );
  }
}
