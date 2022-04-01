import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_talk_about/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final textEditingController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
    } else {
      print("No user detected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('D I S C U S S S S',style: TextStyle(color: Colors.black,wordSpacing: 4,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Color(0xffA88F5D),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<Widget> displayedMessages = [];
                    final messages = snapshot.data!.docs;
                    for (DocumentSnapshot message in messages) {
                      final messageText = message['text'];
                      final messageSender = message['sender'];
                      displayedMessages.add(MessageBubble(
                        sender: messageSender,
                        text: messageText,
                      ));
                    }
                    return Expanded(
                        child: ListView(children: displayedMessages));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textEditingController.clear();
                      _firestore.collection('messages').add(
                          {'sender': loggedInUser.email, 'text': messageText});
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

class MessageBubble extends StatelessWidget {
  const MessageBubble({this.text, this.sender});

  final String? text;
  final String? sender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(
          margin: EdgeInsets.fromLTRB(25,0,0,0),
          child: Material(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(
                  '$text',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              elevation: 3,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.lightBlue),
        ),
        SizedBox(height: 5),
        Text('sent by $sender',
            style: const TextStyle(color: Colors.black45, fontSize: 12)),
      ]),
    );
  }
}