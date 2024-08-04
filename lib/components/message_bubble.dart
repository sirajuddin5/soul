import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.sender,
      required this.text,
      required this.isME,
      required this.timestamp
      });

  final String sender;
  final String text;
  final bool isME;
  final String timestamp;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            color: isME ? Colors.lightBlueAccent : Colors.white,
            borderRadius: isME
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0)),
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment:
                    isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    ' $text ',
                    style: TextStyle(
                      color: isME ? Colors.white : Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),
                  Text(
                    timestamp, //implement time stamp
                    style: TextStyle(
                      fontSize: 8.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ) ,
    );
  }
}

// todo have to implement date wise button on middle check is today if yes show messages if not today show
// todo a text in middle and date and the show messages
