import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String id;
  final String ownerId;
  final String receiverId;
  final String text;
  final Timestamp time;

  Message({this.id, this.ownerId, this.receiverId, this.text, this.time});

  factory Message.producingDoc(DocumentSnapshot doc) {
    var docData = doc.data();
    return Message(
      id: doc.id,
      ownerId: docData['ownerId'],
      receiverId: docData['receiverId'],
      text: docData['text'],
      time: docData['time'],
    );
  }
}