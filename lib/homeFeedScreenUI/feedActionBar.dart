import 'package:flutter/material.dart';

class FeedActionBar extends StatelessWidget { //TODO: transform to stateful widget and set counter
  const FeedActionBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.thumb_up),
            SizedBox(height: (MediaQuery.of(context).size.height/50),),
            Text(' Like'),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.comment),
            SizedBox(height: 8,),
            Text(' Comment'),
          ],
        ),
        Row(
          children: <Widget>[
            Icon(Icons.share),
            SizedBox(height: 8,),
            Text(' Share'),
          ],
        ),
      ],
    );
  }
}