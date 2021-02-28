import 'package:flutter/material.dart';

import 'package:instantchatting/modals/user.dart';
import 'package:instantchatting/pages/abox.dart';
import 'package:instantchatting/services/firestore.dart';
import 'package:instantchatting/widgets/textstyle.dart';

class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController _controller = TextEditingController();

  Future<List<Person>> _list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarS(),
      body: _list != null ? _resultS() : noResult(),
    );
  }



  Widget noResult() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Container(width: 150,height: 150,child: Image.asset("assets/unnamed.jpg",fit: BoxFit.cover)),
           SizedBox(height: 10,),
           Center(child: Text("Please enter username of your friend",style: styles().titlestyle(),))
         ],
       ),
      ),
    );
  }

  AppBar _appBarS() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
        titleSpacing: 0.0,
        backgroundColor: Colors.grey[100],
        title: TextFormField(
          controller: _controller,
          onFieldSubmitted: (value) {
            setState(() {
              _list = firestore().searchUser(value);
            });
          },
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: InputBorder.none,
            hintText: "Search",
            prefixIcon: IconButton(icon: Icon(Icons.search), onPressed: null),
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 30.0,
                ),
                onPressed: () => _controller.clear()),
          ),
        ));
  }

  Widget _resultS() {
    return FutureBuilder<List<Person>>(
      future: _list,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data.length == 0) {
          return Center(child: Text("No result found"));
        }

        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              Person person = snapshot.data[index];
              return listing(person);
            });
      },
    );
  }

  Widget listing(Person person) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => chat(person: person,
        ),
      )),
      child: ListTile(
        leading: CircleAvatar(
          radius: 40.0,
          backgroundImage: person.picture != null
              ? NetworkImage(person.picture)
              : AssetImage("assets/unnamed.jpg"),
        ),
        title: Text(
          person.username,
          style: styles().titlestyle(),
        ),
        subtitle: Text(
          person.email,
          style: styles().subtitlestyle(),
        ),
      ),
    );
  }
}
