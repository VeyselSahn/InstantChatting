import 'package:flutter/material.dart';
import 'package:instantchatting/modals/user.dart';
import 'package:instantchatting/pages/edit.dart';
import 'package:instantchatting/services/auth.dart';
import 'package:instantchatting/services/firestore.dart';
import 'package:instantchatting/widgets/appbar.dart';
import 'package:instantchatting/widgets/textstyle.dart';
import 'package:provider/provider.dart';

class profile extends StatefulWidget {
  final String ownerID;

  const profile({Key key, this.ownerID}) : super(key: key);
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
           Scaffold(
            backgroundColor: Colors.white,
            appBar: appbar(
                context: context,
                backcolor: Colors.lightBlue,
                iconcolor: Colors.white,
                iconData: Icons.arrow_back,
                textcolor: Colors.white),
            body: RefreshIndicator(onRefresh: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => profile(ownerID: widget.ownerID),));
            },child: ListView(children: [body(),listtiles()])),
          );

  }

  Widget body() {
    return FutureBuilder<Person>(
        future: firestore().getUser(widget.ownerID),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return LinearProgressIndicator(
                backgroundColor: Colors.green[800]);
          Person owner = snapshot.data;
          print(owner.username);
          return Container(
            child: Column(
                children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage: owner != null
                              ? NetworkImage(owner.picture)
                              : AssetImage("assets/unnamed.jpg"),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            Text(owner.username,
                                style: styles().titlestyle()),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text("email", style: styles().subtitlestyle())
                          ],
                        ),
                      ]),
                      SizedBox(
                        width: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => edit(
                                    person: owner,
                                  ),
                                ));
                          },
                          child: Container(
                            height: 30.0,
                            width: 30.0,
                            child: Image.asset(
                              "assets/support.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
  Widget listtiles(){
    var _auth= Provider.of<Auth>(context, listen: false);
    return
      Column(
       children: [
          ListTile(
            leading: Icon(
              Icons.help_outline,
              size: 30,
              color: Colors.green,
            ),
            title: Text("Support", style: styles().titlestyle()),
            subtitle: Text(
                "If you have a problem , We are always exited for helping you",
                style: styles().subtitlestyle()),
            onTap: () => print("listtile clicked"),
          ),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.green,
              size: 30,
            ),
            title: Text("About Us", style: styles().titlestyle()),
            subtitle: Text("Are you curious about us ? Just click",
                style: styles().subtitlestyle()),
            onTap: () => print("listtile clicked"),
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.green,
              size: 30,
            ),
            title: Text("Sign Out", style: styles().titlestyle()),
            subtitle: Text("Way of coming back always open for you ",
                style: styles().subtitlestyle()),
            onTap: ()  {
            _auth.exit();
            Navigator.pop(context);
            }

          )
        ],
      );
  }
}
