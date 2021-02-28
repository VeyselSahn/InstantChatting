import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instantchatting/modals/user.dart';
import 'package:instantchatting/pages/abox.dart';
import 'package:instantchatting/pages/newprofile.dart';
import 'package:instantchatting/pages/search.dart';
import 'package:instantchatting/services/Message.dart';
import 'package:instantchatting/services/auth.dart';
import 'package:instantchatting/services/firestore.dart';
import 'package:instantchatting/widgets/textstyle.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;


class messageboxs extends StatefulWidget {
  @override
  _messageboxsState createState() => _messageboxsState();
}

class _messageboxsState extends State<messageboxs> {
  List<Person> _friends = [];
  String _active;
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _active = Provider
        .of<Auth>(context, listen: false)
        .profileowner;
    duyurulariGetir();
    timeago.setLocaleMessages('en', timeago.EnMessages());
  }

  Future<void> duyurulariGetir() async {
    List<Person> friends = await firestore().getChatFriends(_active);
    if (mounted) {
      setState(() {
        _friends = friends;
        _yukleniyor = false;
      });
    }

  }



  duyurulariGoster() {
    if (_yukleniyor) {
      return Center(child: CircularProgressIndicator());
    }

    if (_friends.isEmpty) {
      return Center(
          child: InkWell(
              onTap: () => Auth().exit(), child: Center(child: Text("No Messages"))));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: RefreshIndicator(
        onRefresh: duyurulariGetir,
        child: ListView.builder(
            itemCount: _friends.length,
            itemBuilder: (context, index) {
              Person duyuru = _friends[index];
              return duyuruSatiri(duyuru);
            }),
      ),
    );
  }

  duyuruSatiri(Person duyuru) {
    return FutureBuilder(
        future: firestore().getUser(duyuru.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              height: 0.0,
            );
          }

          Person aktiviteYapan = snapshot.data;

          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        chat(
                          person: aktiviteYapan,
                        ),
                  ));
            },
            child:  StreamBuilder(
              stream: firestore().getLMessages(_active),
              builder: (context, snapshot) {
                if(!snapshot.hasData) return LinearProgressIndicator();
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      Message message =
                      Message.producingDoc(snapshot.data.docs[0]);

                      return listtile(aktiviteYapan: aktiviteYapan,message: message,);
                    });

              }
            ));
              }

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
              child: GestureDetector(
                onTap: () => duyurulariGetir(),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: pers.picture != null
                          ? NetworkImage(pers.picture)
                          : Image.asset("assets/unnamed.jpg",fit: BoxFit.cover,),
                      radius: 50.0,
                    ),
                      SizedBox(width: 20.0,),
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
                        "How about send first message to dear ",
                        style: TextStyle(color: Colors.grey[600], fontSize: 15.0))
                  ],
                ),
              ),
            );
          }),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 1.0,
          backgroundColor: Colors.blue,
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => search(),));
          },),
        appBar: AppBar(
          title: Text("ChatMe"),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.blue,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  color: Colors.white,
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                newprofile(
                                  owner:  _active,
                                )));
                  }),
            )
          ],
        ),
        body: _friends != null ? duyurulariGoster() : emptyStatus()
    );}
}

class listtile extends StatelessWidget {
  const listtile({
    Key key,
    @required this.aktiviteYapan, this.message,
  }) : super(key: key);

  final Person aktiviteYapan;
  final Message message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(aktiviteYapan.picture),
          ),

          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child:
            Text(aktiviteYapan.username, style: styles().titlestyle()),
          ),
          subtitle: Text(
            message.text,
            style: styles().subtitlestyle(),
          ),
          trailing: Text(timeago.format(message.time.toDate()), style: styles().textstyle()),
        );
  }
}
