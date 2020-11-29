// ignore: avoid_web_libraries_in_flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mothipaaru_flutter/loading.dart';
import 'package:mothipaaru_flutter/users.model.dart';
final themeColor = Color(0xfff5a623);
final primaryColor = Color(0xff203152);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);

class ChatScreenPage extends StatefulWidget {

final String chatroomID;final Users currentUser;
  ChatScreenPage({Key key,@required this.chatroomID,@required this.currentUser}): super(key: key);
  @override
  _ChatScreenPageState createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
    String peerId;
  String peerAvatar;
  String id;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId;
  bool isLoading;
  bool isShowSticker=false;
  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
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
      appBar: AppBar(title: Text("Messges"),),
      body: Column(children: <Widget>[
              Flexible(
              child:buildListMessage(),
              ),
            // List of messages
Expanded(
  child: Column(children: [
    Padding(  
            padding: EdgeInsets.all(15),  
            child:TextField(
            controller: textEditingController,
            decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(),  
            ),
        ),
    ),
        ElevatedButton(
            onPressed: () {
    if (textEditingController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("chatroom").doc(widget.chatroomID).collection("messages").add({
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
            child: Icon(Icons.send)
        ),
        
            ],)
            
            ),
            // Input content
             
            ],

        // Loading
    ),
    );
  }

void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      CupertinoAlertDialog(content: Text("Nothing to Send"));
    }
  }


  Widget buildLoading() {
    return Positioned(
      child: const Loading(),
    );
  }

  Widget buildInput() {
      return Container(
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new TextField(
            controller: textEditingController,
            decoration: new InputDecoration(
                hintText: 'Type something',
            ),
        ),
        new RaisedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  child: new AlertDialog(
                      title: new Text('What you typed'),
                      content: new Text(textEditingController.text),
                  ),
              );
            },
            child: new Text('DONE'),
        ),
      ],
    ),
  );
  }

  Widget buildListMessage() {
    return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatroom')
                  .doc(widget.chatroomID)
                  .collection("messages")
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  listMessage.addAll(snapshot.data.documents);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index)=> MessageTile(message: snapshot.data.documents[index].data()["message"].toString(),sendByMe: snapshot.data.documents[index].data()["sendBy"]==widget.currentUser.uid),
                                        itemCount: snapshot.data.documents.length,
                                        reverse: true,
                                        controller: listScrollController,
                                      );
                                    }
                                  },
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
                   
                    buildItem(int index, document) {
                       
                    }

  class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
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
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)),
      ),
    );
  }
}