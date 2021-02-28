import 'package:flutter/material.dart';

class styles{

  styles();

  TextStyle textstyle({TextDecoration underline}) {
    return TextStyle(
        color: Colors.black,
        fontSize: 15.0,
        decoration: underline
    );
  }

  TextStyle titlestyle() {
    return TextStyle(
        color: Colors.black, fontSize: 18.0);
  }

  TextStyle subtitlestyle() {
    return TextStyle(
        color: Colors.grey, fontSize: 15.0);
  }

}