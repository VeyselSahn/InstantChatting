import 'package:flutter/material.dart';
import 'package:instantchatting/pages/register.dart';
import 'package:instantchatting/services/auth.dart';
import 'package:instantchatting/widgets/appbar.dart';
import 'package:instantchatting/widgets/button.dart';
import 'package:instantchatting/widgets/textstyle.dart';

class login extends StatefulWidget {
  login({Key key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scKey = GlobalKey<ScaffoldState>();
  String mail, password;

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scKey,
      appBar: appbar(context: context,iconData: Icons.star_border,iconcolor: Colors.yellow,backcolor: Colors.white,textcolor: Colors.black),
      body:
           body(),
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
          controller: email,
            validator: (value) {
              if (value.isEmpty)
                return "Must enter an email";
              else if(!value.contains('@')) return "Enter an valid email";
              else return null;
            },
          keyboardType: TextInputType.emailAddress,
          onSaved: (newValue) => mail = newValue,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.mail),
            hintText: "Enter your email",
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          ),
        ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              controller: pass,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty)
                  return "Must enter an password";
                else if (value.trim().length < 6)
                  return "Can't be shorter 6 digits";
                else
                  return null;
              },
              onSaved: (newValue) => password = newValue,
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
                child: button("Log In", Colors.lightBlue)),
            SizedBox(
              height: 30.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?", style: styles().textstyle()),
                GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => register()));
                    },
                    child: Text(
                      "Register now",
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
        await Auth().login(email: mail, password: password);
        print(password);
      } catch (hata) {
        setState(() {
          loading = false;
        });

        showError(code: hata.code);
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
