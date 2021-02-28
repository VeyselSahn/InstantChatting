import 'package:flutter/material.dart';

Widget button(String text,Color color)
{
  return 
            Container(
            height: 50.0,
            width: double.maxFinite,
            child: Text(text,style: TextStyle(color: Colors.white,fontSize: 18),),
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0),color: color),
          );
}