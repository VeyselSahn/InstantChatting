import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instantchatting/modals/user.dart';

class firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final DateTime time = DateTime.now();

  Future<void> kullaniciOlustur({
    id,
    email,
    username,
  }) async {
    await _firestore.collection("users").doc(id).set({
      "username": username,
      "email": email,
      "picture":
          "https://firebasestorage.googleapis.com/v0/b/instantchat-9c1ae.appspot.com/o/images%2Fprofile%2Funnamed.jpg?alt=media&token=d55e4cec-dc19-4705-bf64-96dec7217d27",
      "time": time,
      "id": id,
    });
  }

  Future<Person> getUser(String id) async {
    DocumentSnapshot doc = await _firestore.collection("users").doc(id).get();
    if (doc.exists) {
      Person user = Person.producingDoc(doc);
      return user;
    } else {
      return null;
    }
  }

  Future<void> updateUser({String username, String picture, String id}) async {
    await _firestore
        .collection("users")
        .doc(id)
        .update({"username": username, "picture": picture});
  }

  Future<List<Person>> getChatFriends(String id) async {
    QuerySnapshot doc = await _firestore
        .collection("chatfriends")
        .doc(id)
        .collection("listoffriends")
        .get();
    List<Person> list = doc.docs.map((e) => Person.producingDoc(e)).toList();
    if (list.isNotEmpty) return list;
  }

  addChatFriend({String ownerId, String receiverId}) {
    _firestore
        .collection("chatfriends")
        .doc(ownerId)
        .collection("listoffriends")
        .doc(receiverId)
        .set({});

    _firestore
        .collection("chatfriends")
        .doc(receiverId)
        .collection("listoffriends")
        .doc(ownerId)
        .set({});
  }

  Future<List<Person>> searchUser(String search) async {
    QuerySnapshot snap = await _firestore
        .collection("users")
        .where("username", isEqualTo: search)
        .get();
    List<Person> list = snap.docs.map((e) => Person.producingDoc(e)).toList();
    return list;
  }

  Stream<QuerySnapshot> getMessages(String ownerId) {
    return _firestore
        .collection("Messages")
        .doc(ownerId)
        .collection("MyMessages")
        .orderBy("time", descending: false)
        .snapshots();
  }

  addMessage({
    String ownerId,
    String receiverId,
    String text,
  }) {
    _firestore
        .collection("Messages")
        .doc(ownerId)
        .collection("MyMessages")
        .add({
      "text": text,
      "ownerId": ownerId,
      "receiverId": receiverId,
      "time": time
    });

    _firestore
        .collection("Messages")
        .doc(receiverId)
        .collection("MyMessages")
        .add({
      "text": text,
      "ownerId": ownerId,
      "receiverId": receiverId,
      "time": time
    });
  }

  Stream<QuerySnapshot> getLMessages(String ownerId) {
    return _firestore
        .collection("Messages")
        .doc(ownerId)
        .collection("MyMessages")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<void> deleteMessages(String owner, String receiver) async {
    QuerySnapshot snapshot = await _firestore
        .collection("Messages")
        .doc(owner)
        .collection("MyMessages")
        .where("receiverId", isEqualTo: receiver)
        .get();
    snapshot.docs.forEach((sendingmessage) {
      if (sendingmessage.exists) {
        sendingmessage.reference.delete();
      }
    });
    QuerySnapshot snap = await _firestore
        .collection("Messages")
        .doc(owner)
        .collection("MyMessages")
        .where("ownerId", isEqualTo: receiver)
        .get();
    snap.docs.forEach((takingmessage) {
      if (takingmessage.exists) {
        takingmessage.reference.delete();
      }
    });
  }
}
