import 'package:flutter/material.dart';
import '../components/message_bubble.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  late String messageText;

  final messageTextController = TextEditingController();

  late String timestamp;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }

  void getFirestoreMessages() async {
    await _firestore
        .collection('messages')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // print(doc["Text"] );
        // print(doc['sender']);
        print(doc.data());
      });
    });
  }

  void messageStream() async {
    await for (var snapshot in _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.power_settings_new_outlined),
              onPressed: () {
                DateTime _now = DateTime.now();
                print('timestamp: ${_now.hour}:${_now.minute}:${_now.second}');
                // messageStream();
                // getMessages();
                // getFirestoreMessages();
                _auth.signOut();
                Navigator.pop(context);
                //TODO Implement logout functionality
              }),
        ],
        title: Text('⚡️ Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //TODO Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      DateTime _now = DateTime.now();
                      timestamp = '${_now.hour}:${_now.minute}';

                      _firestore.collection('messagesoul').add(
                        {
                          'text': messageText,
                          'sender': loggedInUser.email,
                          //TODO implement timestamp
                          'timestamp': timestamp
                        },
                      );
                      //TODO Implement send functionality.
                      print(messageText);
                      print(timestamp);
                      print(loggedInUser.email);
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

class MessageStream extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messagesoul')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data?.docs;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages!) {
          // final messageText = message.data["Text"];
          // final messageSender = message.data['sender'];

          final messageText = message['text'];
          final messageSender = message["sender"];
          final messageTimestamp = message['timestamp'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            timestamp: messageTimestamp,
            isME: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            // reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}
