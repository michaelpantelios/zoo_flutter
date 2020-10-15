import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppWindowTopBar extends StatefulWidget{
  AppWindowTopBar({Key key});

  @override
  AppWindowTopBarState createState() => AppWindowTopBarState();
}

class AppWindowTopBarState extends State<AppWindowTopBar>{
  AppWindowTopBarState({Key key});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child:  Padding(
                padding: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 10),
                child: Text("Title", style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.left)
            )
          ),

        ]
      )
    );
  }

}