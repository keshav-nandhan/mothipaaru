// ignore: avoid_web_libraries_in_flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mothipaaru_flutter/loading.dart';
import 'package:mothipaaru_flutter/users.model.dart';
final themeColor = Color(0xfff5a623);
final primaryColor = Color(0xff203152);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);

class ChatScreenPage extends StatefulWidget {

final String chatroomID;final Users currentUser;final String? secondUser;
  ChatScreenPage({Key? key,required this.chatroomID,required this.currentUser,required this.secondUser}): super(key: key);
  @override
  _ChatScreenPageState createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  String? peerId;
  String? peerAvatar;
  String? id;

  List<DocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  String? groupChatId;
  bool? isLoading;
  bool isShowSticker=false;
  String? imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';
    
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(widget.secondUser!),
      actions: [IconButton(icon: Icon(Icons.call), onPressed: (){})]),
      body:Container(
        child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
        topRight: Radius.circular(20))
        ),
        child: Column(children:<Widget>[
              Expanded(
              child:buildListMessage(),
              ),
              Container(
        margin: EdgeInsets.all(15.0),
        height: 61,
        child: Row(children: [
    Expanded(
    child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 5,
                  color: Colors.grey)
            ],
          ),
          child: Row(
            children: [
              // IconButton(
              //     icon: Icon(Icons.face), onPressed: () {}),
              Expanded(
                child: TextField(
                  scrollPadding: EdgeInsets.all(5.0),
                  textCapitalization: TextCapitalization.sentences,
                  controller: textEditingController,
                  decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                  )
                ),
              ),
              // IconButton(
              //   icon: Icon(Icons.photo_camera),
              //   onPressed: () {},
              // ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                    if (textEditingController.text.isNotEmpty) {
                      FocusScope.of(context).unfocus();
                      await FirebaseFirestore.instance.collection("chatroom").doc(widget.chatroomID).collection("messages").add({
                        "sendBy": widget.currentUser.uid,
                        "message": textEditingController.text,
                        'timestamp': DateTime.now().millisecondsSinceEpoch
                        }).then((value) => 
                            setState(() {
                                    textEditingController.text = "";
                                  })
                        );
                      }
                  
                },
               )
            ],
          ),
    ),
    ),
],
      )
      ,)
            
            // List of messages
    // Expanded(  
    //         //padding: EdgeInsets.all(1),  
    //         child:TextField(
    //         controller: textEditingController,
    //         decoration: InputDecoration(
    //             hintText: 'Type a message',
    //             border: OutlineInputBorder(),  
    //         ),
    //     ),
    // ),
    //     Flexible(child:ElevatedButton(
    //         onPressed: () {
    // if (textEditingController.text.isNotEmpty) {
    //   FirebaseFirestore.instance.collection("chatroom").doc(widget.chatroomID).collection("messages").add({
    //     "sendBy": widget.currentUser.uid,
    //     "message": textEditingController.text,
    //     'timestamp': DateTime.now().millisecondsSinceEpoch
    //     }).then((value) => 
    //         setState(() {
    //                 textEditingController.text = "";
    //               })
    //     );
    //   }
    //         },
    //         child: Icon(Icons.send)
    //     ),
    //     ),
        
            ],)
            
            ),
            // Input content
      ),
    );
  }

// void onSendMessage(String content, int type) {
//     // type: 0 = text, 1 = image, 2 = sticker
//     if (content.trim() != '') {
//       textEditingController.clear();

//       var documentReference = FirebaseFirestore.instance
//           .collection('messages')
//           .doc(groupChatId)
//           .collection(groupChatId)
//           .doc(DateTime.now().millisecondsSinceEpoch.toString());

//       FirebaseFirestore.instance.runTransaction((transaction) async {
//         transaction.set(
//           documentReference,
//           {
//             'idFrom': id,
//             'idTo': peerId,
//             'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
//             'content': content,
//             'type': type
//           },
//         );
//       });
//       listScrollController.animateTo(0.0,
//           duration: Duration(milliseconds: 300), curve: Curves.easeOut);
//     } else {
//       CupertinoAlertDialog(content: Text("Nothing to Send"));
//     }
//   }

Future<bool> checkIfCollectionExist(String collectionName) async {
  var value = await FirebaseFirestore.instance
      .collection("chatroom")
      .doc(collectionName)
      .collection("messages")
      .limit(1)
      .get();
  return value.docs.isNotEmpty;
}

  Widget buildLoading() {
    return Positioned(
      child: const Loading(),
    );
  }

 
  Widget buildListMessage() {
    // Future<bool> funcresp=checkIfCollectionExist(widget.chatroomID);
    // Widget result=Container();
    return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatroom')
                  .doc(widget.chatroomID)
                  .collection("messages")
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                final widgetdata=snapshot.data;
                print(widgetdata);
                     switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index)=> MessageTile(message: 'No New Messages',sendByMe:true),
                                        controller: listScrollController,
                                      );
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                              default:
                // if(snapshot.hasError){
                //   return ListView.builder(
                //     padding: EdgeInsets.all(10.0),
                //     itemBuilder: (context, index)=> MessageTile(message: 'No New Messages',sendByMe:true),
                //                         controller: listScrollController,
                //                       );
                  
                // }
                if(snapshot.hasError){
                   return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index)=> MessageTile(message: 'No New Messages',sendByMe:true),
                                        controller: listScrollController,
                                      );
                }
                else{
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  //final List<DocumentSnapshot> documents = snapshot.data.docs;
                  listMessage.addAll((snapshot.data ! as QuerySnapshot).docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index)=> MessageTile(message: (snapshot.data ! as QuerySnapshot).docs[index]["message"].toString(),sendByMe: (snapshot.data ! as QuerySnapshot).docs[index]["sendBy"]==widget.currentUser.uid),
                    //  itemBuilder: (context, index)=> MessageTile(message: snapshot.data.docs[index].data().toString(),sendByMe: snapshot.data.docs[index].data()==widget.currentUser.uid),
                                        itemCount: (snapshot.data ! as QuerySnapshot).docs.length,
                                        reverse: true,
                                        controller: listScrollController,
                                      );
                                    }
                     }
                                  }}
                                );
                      }
                    
                       Future<bool> onBackPress() {
                        if (isShowSticker) {
                          setState(() {
                            isShowSticker = false;
                          });
                        } 
                    
                        return Future.value(false);
                      }
                    
                      void onFocusChange() {
                        if (focusNode.hasFocus) {
                          // Hide sticker when keyboard appear
                          setState(() {
                            isShowSticker = false;
                          });
                        }
                      }
                     void getSticker() {
                        // Hide keyboard when sticker appear
                        focusNode.unfocus();
                        setState(() {
                          isShowSticker = !isShowSticker;
                        });
                      } 
                    
                         
                    }
                   
                    
  class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .6),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius:BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ),
            gradient: LinearGradient(
              colors: [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w400)),
      ),
    );
  }
}