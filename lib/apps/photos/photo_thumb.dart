import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhotoThumbData{
  String photoUrl;
  bool isMain;

  PhotoThumbData({this.photoUrl, this.isMain});
}

class PhotoThumb extends StatefulWidget{
  PhotoThumb({Key  key});
  PhotoThumbState createState() => PhotoThumbState();
}

class PhotoThumbState extends State<PhotoThumb>{
  PhotoThumbState();

  PhotoThumbData _data;

  update(PhotoThumbData data){
    setState(() {
      _data = data;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_data == null) ? Container() :
        MouseRegion(
          onEnter: (_){ print("onEnter"); },
          onExit: (_){ print("onExit"); },
          child: Container(
            margin: EdgeInsets.all(2),
            width: 50,
            height: 70,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 1)
            ),
          ),
        );

  }
}