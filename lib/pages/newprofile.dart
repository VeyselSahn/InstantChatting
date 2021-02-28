import 'package:flutter/material.dart';
import 'package:instantchatting/modals/user.dart';
import 'package:instantchatting/pages/abox.dart';
import 'package:instantchatting/pages/edit.dart';
import 'package:instantchatting/pages/profilebutton.dart';
import 'package:instantchatting/services/auth.dart';
import 'package:instantchatting/services/firestore.dart';
import 'package:instantchatting/widgets/textstyle.dart';
import 'package:provider/provider.dart';

class newprofile extends StatefulWidget {
  final String owner;

  const newprofile({Key key, this.owner}) : super(key: key);
  @override
  _newprofileState createState() => _newprofileState();
}

class _newprofileState extends State<newprofile> {
  String active;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    active = Provider.of<Auth>(context, listen: false).profileowner;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      body: FutureBuilder<Person>(
          future: firestore().getUser(widget.owner),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            }
            Person person = snapshot.data;
            return ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 230.0,
                      //color: Colors.brown,
                    ),
                    Container(
                      height: 180.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(person.picture),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      left: 30.0,
                      bottom: 0.0,
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(60.0),
                            border: Border.all(width: 2.0, color: Colors.pink),
                            image: DecorationImage(
                                image: NetworkImage(person.picture),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    Positioned(
                      top: 180.0,
                      left: 160.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            person.username,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0),
                          ),
                          Text(
                            "About me!",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.normal,
                                fontSize: 15.0),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 15.0,
                      bottom: 57.0,
                      child: Container(
                          height: 50.0,
                          width: 110.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15.0)),
                          child: widget.owner == active
                              ? GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => edit(
                                      person: person,
                                    ),
                                  ),),
                                  child: profilebutton("Edit", Icons.info))
                              : InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => chat(
                  person: person,
                ),
              ));
            }
            ,child: profilebutton("Message", Icons.messenger))),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                SizedBox(height: 15,),
                widget.owner == active ?
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
                      Auth().exit();
                      Navigator.pop(context);
                    }

                ) :  ListTile(
                    leading: Icon(
                      Icons.block,
                      color: Colors.green,
                      size: 30,
                    ),
                    title: Text("Block", style: styles().titlestyle()),
                    subtitle: Text("Is @ ${person.username} bothering you",
                        style: styles().subtitlestyle()),
                    onTap: ()  {
                      Auth().exit();
                      Navigator.pop(context);
                    }

                )
              ],
            );
          }),
    );
  }
}
