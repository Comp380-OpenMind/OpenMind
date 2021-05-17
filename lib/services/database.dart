import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfoToDB(
      String userId, Map<String, dynamic> userInfoMap) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<void> removeUserFromDB(String userID) {
    return FirebaseFirestore.instance.collection('users').doc(userID).delete();
  }

  //search a user by username
  Future<Stream<QuerySnapshot>> getUserbyUserName(String username) async {
    //FirebaseFirestore.instance allows us to access the database
    return FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getUserbyTopic(String opposing) async {
    return FirebaseFirestore.instance
        .collection("pairing_system")
        .where("topic-stance", isEqualTo: opposing)
        .snapshots();
  }

  Future addMessage(
      String chatRoomId, String messageId, Map messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  addUserToTopic(String topic, String stance, String user) {
    String topicStance = topic + " - " + stance;
    FirebaseFirestore.instance
        .collection("pairing_system")
        .doc(user)
        .set({"user": user, "topic-stance": topicStance});
  }

  Future<void> removeUserFromTopic(String user) {
    return FirebaseFirestore.instance
        .collection('pairing_system')
        .doc(user)
        .delete();
  }

  Future<void> deleteChatroom(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .delete();
  }

  updateLastMessageSend(String chatRoomId, Map lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      //chatroom already exists
      return true;
    } else {
      // chatroom does not exist
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
  }
}
