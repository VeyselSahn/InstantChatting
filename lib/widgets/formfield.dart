import 'package:flutter/material.dart';

class formfields {
  Widget mailff(TextEditingController controller, String value) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => value = newValue,
      decoration: InputDecoration(

        prefixIcon: Icon(Icons.mail),
        hintText: "Enter your email",
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      ),
    );
  }

  Widget usernameff(TextEditingController controller, String value) {
    return TextFormField(
      controller: controller,
      onSaved: (newValue) => value = newValue,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: "Enter your username",
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      ),
    );
  }

  Widget passwordff(TextEditingController controller, String value) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      onSaved: (newValue) => value = newValue,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_open_sharp),
        hintText: "Enter your password",
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      ),
    );
  }
}
