import 'package:firebase_auth/firebase_auth.dart';
import 'package:instantchatting/modals/user.dart';

class Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String profileowner;

  Person creatinguser(User kullanici) {
    return kullanici == null ? null : Person.producingFirebase(kullanici);
  }

  Stream<Person> get chasing {
    return _auth.authStateChanges().map(creatinguser);
  }

  Future<Person> login({String email, String password}) async {
    var card = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return creatinguser(card.user);
  }

  Future<Person> register(
      {String email, String password, String username}) async {
    var card = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return creatinguser(card.user);
  }

  Future<void> exit() {
    return _auth.signOut();
  }
}
