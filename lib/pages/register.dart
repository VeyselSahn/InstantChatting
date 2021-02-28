import 'package:flutter/material.dart';
import 'package:instantchatting/modals/user.dart';
import 'package:instantchatting/services/auth.dart';
import 'package:instantchatting/services/firestore.dart';
import 'package:instantchatting/widgets/button.dart';
import 'package:instantchatting/widgets/textstyle.dart';

class register extends StatefulWidget {
  register({Key key}) : super(key: key);

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  TextEditingController password, email, username = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scKey = GlobalKey<ScaffoldState>();
  String pass, mail, user;

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scKey,
      appBar: AppBar(
        title: Text(
          "ChatMe",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.grey),
      ),
      body:
          loading == true ? Center(child: CircularProgressIndicator()) : body(),
    );
  }

  Widget body() {
    return Form(
      key: _formKey,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextFormField(
              controller: username,
              onSaved: (newValue) => user = newValue,
              validator: (value) {
                if(value.isEmpty) return "Must enter an username";
                else return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: "Enter your username",
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              onSaved: (newValue) => mail = newValue,
            validator: (value) {
            if (value.isEmpty)
                 return "Must enter an email";
            else if(!value.contains('@')) return "Enter an valid email";
            else return null;
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail),
                hintText: "Enter your email",
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              ),
            ),            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              controller: password,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty)
                  return "Must enter an password";
                else if (value.trim().length < 6)
                  return "Can't be shorter 6 digits";
                else
                  return null;
              },
              onSaved: (newValue) => pass = newValue,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline_rounded),
                hintText: "Enter your password",
                contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            SizedBox(
              height: 20.0,
            ),
            InkWell(
                onTap: () {
                  _login();
                },
                child: button("Register", Colors.green)),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Your idea is important for us", style: styles().textstyle()),
                GestureDetector(
                    onTap: () {
                      _login();
                    },
                    child: Text(
                      "Write your comment",
                      style: styles().textstyle(underline: TextDecoration.underline),
                    )),
              ],
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        loading = true;
      });

      try {
        Person a =
            await Auth().register(email: mail, password: pass, username: user);
        if (a != null) {
          firestore().kullaniciOlustur(id: a.id, email: mail, username: user);
        }
        Navigator.pop(context);
      } catch (error) {
        setState(() {
          loading = false;
        });

        showError(code: error.code);
      }
    }
  }

  void showError({code}) {
    String message;
    if (code == "invalid-email") {
      message = "mail is invalid";
    } else if (code == "user-disabled") {
      message = "user disabled";
    } else if (code == "user-not-found") {
      message = "User didnt be found";
    } else if (code == "wrong-password") {
      message = "Wrong Password";
    } else {
      message = "Tanımlanamayan bir hata oluştu $code";
    }

    var snack = SnackBar(content: Text(message));
    _scKey.currentState.showSnackBar(snack);
  }


}
