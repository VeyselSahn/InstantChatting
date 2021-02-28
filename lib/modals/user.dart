import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Person{
  
  final String id;
  final String username;
  final String email;
  final String picture;

  Person({this.username, this.id, this.email, this.picture});

  factory Person.producingFirebase(User kullanici) {
    return Person(
      id: kullanici.uid,
      username: kullanici.displayName,
      picture: kullanici.photoURL,
      email: kullanici.email
    );
  }

  factory Person.producingDoc(DocumentSnapshot doc) {
    var docData = doc.data();
    return Person(
      id: doc.id,
      username: docData['username'],
      email: docData['email'],
      picture: docData['picture'],

    );
  }

}