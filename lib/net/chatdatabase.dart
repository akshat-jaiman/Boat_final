import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatDatabaseMethods {
  getUserByUsername(String userName) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("Name", isEqualTo: userName)
        .get();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}
