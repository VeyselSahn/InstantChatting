import 'package:flutter/material.dart';

Widget appbar({BuildContext context,Color backcolor,Color iconcolor , IconData iconData, Color textcolor}){
  return AppBar
  (
title: Text("ChatMe",style: TextStyle(color: textcolor),),
centerTitle: true,
backgroundColor: backcolor,
elevation: 0.0,
leading: IconButton(
  onPressed: () =>
  Navigator.pop(context) ,
  icon: Icon(iconData,color: iconcolor,size: 30.0,),),
  )
  ;
}