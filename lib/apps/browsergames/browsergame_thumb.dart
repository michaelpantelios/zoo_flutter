import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/browsergames/browsergame_info.dart';
import 'package:url_launcher/url_launcher.dart';

class BrowserGameThumb extends StatefulWidget{
  BrowserGameThumb({Key key, this.data, this.onClickHandler});

  final BrowserGameInfo data;
  final Function onClickHandler;

  static double myWidth = 180;
  static double myHeight = 240;

  BrowserGameThumbState createState() => BrowserGameThumbState();
}

class BrowserGameThumbState extends State<BrowserGameThumb>{
  BrowserGameThumbState();

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
        textStyle: TextStyle(
            color: Colors.lightGreen[900],
            fontSize: 17,
            fontWeight: FontWeight.normal
        ),
        child: FlatButton(
          onPressed: () async {
                if (await canLaunch(widget.data.gameUrl)) {
              await launch(widget.data.gameUrl);
              } else {
              throw 'Could not launch '+widget.data.gameUrl;
              }
            },
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: BrowserGameThumb.myWidth,
              height: BrowserGameThumb.myHeight,
              child : Column(
                children: [
                  Image.asset("/images/singleplayergames/"+widget.data.gameIcon,
                      width: BrowserGameThumb.myWidth,
                      height: BrowserGameThumb.myWidth
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.data.gameName,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              )

          ),
        )
    );
  }
}