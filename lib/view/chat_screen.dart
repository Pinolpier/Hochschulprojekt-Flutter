import 'package:flutter/material.dart';
import 'package:univents/constants/colors.dart';
import 'package:univents/model/frontend/chat_message_model.dart';

/// @author Christian Henrich
/// This screen represents the UI for the chat screen view where the users will be able to exchange text messages with their friends later.

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  /// This method represents the individual chat containers.
  ///
  /// delivers text and timestamp of the [message] that got sent by a user for display on the screen.
  /// it is either in the color blue or white. depending on if the bool [isMyself] is true or false (if the message got sent by me or someone else)
  /// returns a container of the text that gets shown in the screen
  _buildMessage(Message message, bool isMyself) {
    final Container msg = Container(
      margin: isMyself
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMyself ? primaryColor : univentsLightGreyBackground,
        borderRadius: isMyself
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time,
            style: TextStyle(
              color: univentsBlackText2,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message.text,
            style: TextStyle(
              color: univentsBlackText,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMyself) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  /// This method represents the bar at the bottom where the user can input a textmessage and send it to his friends.
  ///
  /// returns a container of the message bar at the bottom of the screen with an input field for text, a button to upload pictures and
  /// a button to send the textmessage input.
  _messageBarBottom() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: univentsWhiteBackground,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: primaryColor,
            onPressed: () {
              print("photo icon pressed!");
            },
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: primaryColor,
            onPressed: () {
              print("Send button pressed!");
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          "Markus Link",
          //TODO: exchange later with actual username of currently signed in User
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: univentsWhiteBackground,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: univentsWhiteBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Message message = messages[index];
                      final bool isMe = message.senderIsMe;
                      return _buildMessage(message, isMe);
                    },
                  ),
                ),
              ),
            ),
            _messageBarBottom(),
          ],
        ),
      ),
    );
  }
}
