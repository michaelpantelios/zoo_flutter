import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_info.dart';

class BrowserGameThumb extends StatefulWidget {
  BrowserGameThumb({Key key, this.data, this.onClickHandler}) : super(key : key);

  final BrowserGameInfo data;
  final Function onClickHandler;

  static double myWidth = 135;
  static double myHeight = 170;

  BrowserGameThumbState createState() => BrowserGameThumbState(key: key);
}

class BrowserGameThumbState extends State<BrowserGameThumb> {
  BrowserGameThumbState({Key key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        waitDuration: Duration(milliseconds: 400),
        message: widget.data.gameDesc,
        height: 50,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.lightGreen[50],
          border: Border.all(color: Colors.lightGreen[900], width: 1),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            new BoxShadow(color: Color(0xaa000000), offset: new Offset(2.0, 2.0), blurRadius: 6, spreadRadius: 3),
          ],
        ),
        textStyle: TextStyle(color: Colors.lightGreen[900], fontSize: 17, fontWeight: FontWeight.normal),
        child: FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () {
           widget.onClickHandler(widget.data);
          },
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              width: BrowserGameThumb.myWidth,
              height: BrowserGameThumb.myHeight,
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        "assets/images/browsergames/" + widget.data.gameIcon,
                        key: new GlobalKey(),
                        fit: BoxFit.fill,
                      )),
                  SizedBox(height: 5),
                  Text(
                    widget.data.gameName,
                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                ],
              )),
        ));
  }
}
