import 'package:boat/components/decorations.dart';
import 'package:boat/models/userdetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;
var loggedinUser = FirebaseAuth.instance.currentUser;

class ConversationScreen extends StatefulWidget {
  final String chatroomId;
  final String userName;
  final UserData currentuser;

  const ConversationScreen(
      {Key key, this.chatroomId, this.userName, this.currentuser})
      : super(key: key);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final messageTextController = TextEditingController();
  static final auth = FirebaseAuth.instance;

  String messagetext;

  void messagestream() async {
    await for (var snapshot in firestore
        .collection('ChatRoom')
        .doc(widget.chatroomId)
        .collection('chats')
        .snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.userName),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              currentuser: widget.currentuser,
              chatroomId: widget.chatroomId,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messagetext = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      firestore
                          .collection('ChatRoom')
                          .doc(widget.chatroomId)
                          .collection('chats')
                          .add({
                        'text': messagetext,
                        'sender': widget.currentuser.name,
                        'time': DateTime.now(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final UserData currentuser;
  final chatroomId;
  const MessagesStream({Key key, this.currentuser, this.chatroomId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('ChatRoom')
          .doc(chatroomId)
          .collection('chats')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data.docs.reversed;
          List<Widget> messagewidgets = [];
          for (var message in messages) {
            final messagetext = message.data()['text'];
            final messagesender = message.data()['sender'];
            final messagetime = message.data()['time'];

            final currentUser = currentuser.name;

            final messagewidget = MessageBubble(
              sender: messagesender,
              text: messagetext,
              time: messagetime,
              isMe: currentUser == messagesender,
            );
            messagewidgets.add(messagewidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messagewidgets,
            ),
          );
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Container();
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final Timestamp time;
  final bool isMe;

  const MessageBubble({Key key, this.sender, this.text, this.time, this.isMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 10, color: Colors.black54),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            color: isMe ? Colors.lightBlueAccent : Colors.greenAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 15, color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                time.toDate().hour.toString(),
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
              Text(
                ':',
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
              Text(
                time.toDate().minute.toString(),
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
