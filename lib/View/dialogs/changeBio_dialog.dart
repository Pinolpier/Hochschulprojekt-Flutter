import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// this is used as a dialog that opens when you press the "change bio" button on the profile screen while your logged in as the profile owner on your own profile
/// it gives you the option to input a new bio in the textfield and confirm it through the button at the right so your new bio text gets displayed
class ChangeBioDialog extends StatefulWidget{
  @override
  _ChangeBioDialogState createState() => _ChangeBioDialogState();
}

class _ChangeBioDialogState extends State<ChangeBioDialog> {

  final _textController = TextEditingController();
  String newBioText = "";     //TODO: fill this with the bio text from the database of the user

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("Change your Bio"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      hintText: "input new bio here"
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 265,top: 10),
              child: FloatingActionButton(
                shape: RoundedRectangleBorder(),
                backgroundColor: Colors.grey[200],
                onPressed: () {
                  setState(() {
                    newBioText = _textController.text;
                    //TODO: Save this new bio text in firebase
                  });
                },
                child: Icon(Icons.check,color: Colors.black45),
              ),
            )
          ],
        ),
      ),
    );
  }
}