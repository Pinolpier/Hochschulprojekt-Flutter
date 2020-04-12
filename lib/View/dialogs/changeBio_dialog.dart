import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeBioDialog extends StatefulWidget{
  @override
  _ChangeBioDialogState createState() => _ChangeBioDialogState();
}

class _ChangeBioDialogState extends State<ChangeBioDialog> {

  final _textController = TextEditingController();
  String newBioText = "";

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