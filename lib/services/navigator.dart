import 'package:flutter/material.dart';
import 'package:instantchatting/modals/user.dart';
import 'package:instantchatting/pages/login.dart';
import 'package:instantchatting/pages/messageboxs.dart';
import 'package:instantchatting/services/auth.dart';
import 'package:provider/provider.dart';


class navigator extends StatelessWidget {
  final _scKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final _auth =
    Provider.of<Auth>(context, listen: false);

    return StreamBuilder(
        key: _scKey,
        stream: Auth().chasing,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasData) {
            Person person = snapshot.data;
            _auth.profileowner = person.id;

            return messageboxs();
          } else
            return login();
        });
  }
}
