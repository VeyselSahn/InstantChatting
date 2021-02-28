import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class storage {
  String id;
  Reference _storage = FirebaseStorage.instance.ref();

  Future<String> profileStorage(File image) async {
    id = Uuid().v4();
    UploadTask task = _storage.child("images/profile/pp$id.jpg").putFile(image);
    TaskSnapshot snapshot = await task;
    String url = await snapshot.ref.getDownloadURL();

    return url;
  }
}
