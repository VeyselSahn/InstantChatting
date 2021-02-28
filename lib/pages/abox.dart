import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instantchatting/modals/user.dart';
import 'package:instantchatting/pages/newprofile.dart';
import 'package:instantchatting/services/Message.dart';
import 'package:instantchatting/services/auth.dart';
import 'package:instantchatting/services/firestore.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class chat extends StatefulWidget {
  final Person person;

  const chat({Key key, this.person}) : super(key: key);
  @override
  _chatState createState() => _chatState();
}

class _chatState extends State<chat> {
  TextEditingController content = TextEditingController();
  String _active;
  Person active;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _active = Provider.of<Auth>(context, listen: false).profileowner;
    timeago.setLocaleMessages('en', timeago.EnMessages());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: firestore().getUser(_active),
        builder: (context, snapshot) {
          active = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              backgroundColor: Colors.lightBlue[600],
              iconTheme: IconThemeData(color: Colors.white),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => newprofile(
                      owner: widget.person.id,
                    ),
                  ),);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(widget.person.picture),
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      widget.person.username,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.video_call),
                      color: Colors.white,
                      onPressed: () => print("clicked video call"),
                    ),
                    IconButton(
                        icon: Icon(Icons.call),
                        color: Colors.white,
                        onPressed: () => print("clicked call")),
                    IconButton(
                        icon: Icon(Icons.more_vert_outlined),
                        color: Colors.white,
                        onPressed: () => settings(),
                    )],
                )
              ],
            ),
            body: Column(
              children: [messages(), input()],
            ),
          );
        });
  }

  Future<Widget> settings() {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("Options"),
        children: [

          SimpleDialogOption(
            child: Text("Delete Messages",style: TextStyle(color: Colors.redAccent[700]),),
            onPressed: () {
            firestore().deleteMessages(_active, widget.person.id);
              Navigator.pop(context);
            },
          ),
          SimpleDialogOption(
            child: Text("Back"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget messages() {
    return Expanded(
      child: StreamBuilder(
          stream: firestore().getMessages(_active),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data.docs.length == 0)
              return emptyStatus();
            else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    Message message =
                        Message.producingDoc(snapshot.data.docs[index]);

                    return showmessage(message);
                  });
            }
          }),
    );
  }

  Widget emptyStatus() {
    return Center(
      child: FutureBuilder(
          future: firestore().getUser(_active),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            Person pers = snapshot.data;
            return Container(
              height: 300.0,
              width: 270.0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: widget.person.picture != null
                            ? NetworkImage(widget.person.picture)
                            : Image.asset(
                                "assets/unnamed.jpg",
                                fit: BoxFit.cover,
                              ),
                        radius: 50.0,
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      CircleAvatar(
                        backgroundImage: pers.picture != null
                            ? NetworkImage(pers.picture)
                            : Image.asset(
                                "assets/unnamed.jpg",
                                fit: BoxFit.cover,
                              ),
                        radius: 50.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Empty Message Box",
                    style: TextStyle(color: Colors.black, fontSize: 17.0),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                      "How about send first message to dear ${widget.person.username}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 15.0))
                ],
              ),
            );
          }),
    );
  }

  Widget showmessage(Message message) {
    return FutureBuilder<Person>(
        future: firestore().getUser(message.ownerId),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          Person p = snapshot.data;
          if (message.ownerId == widget.person.id &&
                  message.receiverId == active.id ||
              message.ownerId == active.id &&
                  message.receiverId == widget.person.id) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.lightBlue,
                backgroundImage: NetworkImage(p.picture),
                radius: 20.0,
              ),
              title: Text(message.text),
              subtitle: Text(
                timeago.format(message.time.toDate(), locale: "en"),
                style: TextStyle(color: Colors.grey[700], fontSize: 12.0),
              ),
            );
          } else
            return SizedBox(
              height: 0,
            );
        });
  }

  Widget input() {
    return ListTile(
      title: TextFormField(
        cursorColor: Colors.indigo,
        controller: content,
        decoration: InputDecoration(hintText: "Enter your message"),
      ),
      trailing: IconButton(icon: Icon(Icons.send,color: Colors.blue), onPressed: sendComm),
    );
  }

  void sendComm() {
    String id = Provider.of<Auth>(context, listen: false).profileowner;
    if(content.text != ""){
    firestore().addMessage(
        ownerId: id, text: content.text, receiverId: widget.person.id);
    firestore().addChatFriend(ownerId: _active, receiverId: widget.person.id);
    content.clear();
    }else {
      return null;
    }
  }
}
