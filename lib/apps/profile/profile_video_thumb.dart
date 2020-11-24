import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/interfaces/record_set_thumb_interface.dart';

class ProfileVideoThumbData {
  final String url;

  ProfileVideoThumbData({this.url});
}

class ProfileVideoThumb extends StatefulWidget {
  ProfileVideoThumb({Key key, @required this.onClickHandler}) : super(key: key);

  final Function onClickHandler;

  ProfileVideoThumbState createState() => ProfileVideoThumbState(key: key);
}

class ProfileVideoThumbState extends State<ProfileVideoThumb> implements RecordSetThumbInterface{
  ProfileVideoThumbState({Key key});

  ProfileVideoThumbData _data;
  bool mouseOver = false;
  Size size = new Size(70, 120);
  bool isEmpty = false;


  @override
  update(Object data) {
    setState(() {
      isEmpty = false;
      _data = data;
    });
  }

  @override
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
    return MouseRegion(
        onEnter: (_) {
          setState(() {
            mouseOver = true;
          });
        },
        onExit: (_) {
          setState(() {
            mouseOver = false;
          });
        },
        child: _data == null
            ? Container()
            : isEmpty ?
        Container(
            margin: EdgeInsets.all(5),
            width: size.width,
            height: size.height,
            child: Center(
                child:  SizedBox(width: size.width, height: size.height)
            )
        )
            :  GestureDetector(
            onTap: (){
              widget.onClickHandler(_data.url);
            },
            child: Container(
              margin: EdgeInsets.all(5),
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                border: mouseOver
                    ? Border.all(color: Colors.blue, width: 2)
                    : Border.all(color: Colors.grey[500], width: 1),
              ),
              child: Center(
                  child: Image.network(
                      _data.url,
                      fit: BoxFit.fitHeight)
              ),
            )));
  }


}
