class ChatRoomModel{
  final String chatRoomID;
  final String userContact1;
  final String userContact2;
ChatRoomModel(this.chatRoomID,this.userContact1,this.userContact2);
}

class MessageModel{
  final String sender;
  final String text;
  final String time;
MessageModel(this.sender,this.text,this.time);
}

class ChatUsers{
   final String uid;
  final String email;
  final String displayName;
    final String photoURL;
  final String chatRoomID;
ChatUsers(this.displayName,this.email,this.photoURL,this.uid,this.chatRoomID);
}

