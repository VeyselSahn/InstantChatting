import 'package:flutter/material.dart';

Row profilebutton(String text,IconData icon){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Icon(
        icon,
        size: 18.0,
        color: Colors.black,
      ),
      SizedBox(
        width: 2.0,
      ),
      Text(text,
          style: TextStyle(
              color: Colors.black,
              fontSize: 17.0,
              fontWeight: FontWeight.bold)),
    ],
  );
}