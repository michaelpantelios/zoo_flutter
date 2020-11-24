import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/interfaces/record_set_thumb_interface.dart';

class ProfileGiftData{
  final String id;
  final String senderId;

  ProfileGiftData({this.id, this.senderId});
}

class ProfileGiftThumb extends StatefulWidget {
  ProfileGiftThumb({Key key, @required this.onClickHandler}) : super(key: key);

  final Function onClickHandler;

  ProfileGiftThumbState createState() => ProfileGiftThumbState(key: key);
}

class ProfileGiftThumbState extends State<ProfileGiftThumb> implements RecordSetThumbInterface{
  ProfileGiftThumbState({Key key});

  ProfileGiftData _data;
  bool mouseOver = false;
  Size size = new Size(70, 120);
  bool isEmpty = false;

  update(Object data) {
    setState(() {
      isEmpty = false;
      _data = data;
    });
  }

  clear() {
    print("clear");
    setState(() {
      isEmpty = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}
