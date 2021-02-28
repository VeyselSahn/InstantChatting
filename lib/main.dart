import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:instantchatting/services/auth.dart';
import 'package:instantchatting/services/navigator.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_)=>Auth(),
      child: MaterialApp(
        title: 'ChatMe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: navigator(),
      ),
    );
  }
}

 