///@author Christian Henrich
/// Dummy class for presentation purposes of chat_screen.dart
class Message {
  final String time;
  final String text;
  bool senderIsMe;

  Message({this.time, this.text, this.senderIsMe});
}

/// example messages for chat_screen.dart
List<Message> messages = [
  Message(
    time: '4:50 PM',
    text: 'Aight, im ready',
    senderIsMe: true,
  ),
  Message(
    time: '4:30 PM',
    text: 'i will come pick you up after i walked my doggo',
    senderIsMe: false,
  ),
  Message(
    time: '3:45 PM',
    text: 'Sounds good, pick me up at 5',
    senderIsMe: true,
  ),
  Message(
    time: '3:15 PM',
    text: 'getting food',
    senderIsMe: false,
  ),
  Message(
    time: '2:30 PM',
    text: 'Sure man! What did you have in mind?',
    senderIsMe: true,
  ),
  Message(
    time: '2:00 PM',
    text: 'Yo, you wanna go out later?',
    senderIsMe: false,
  ),
];
