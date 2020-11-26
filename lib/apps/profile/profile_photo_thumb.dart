import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/interfaces/record_set_thumb_interface.dart';

class ProfilePhotoThumbData {
  final String url;
  final bool isPersonal;

  ProfilePhotoThumbData({this.url, this.isPersonal = false});
}

class ProfilePhotoThumb extends StatefulWidget {
  ProfilePhotoThumb({Key key, this.onClickHandler}) : super(key: key);

  final Function onClickHandler;

  ProfilePhotoThumbState createState() => ProfilePhotoThumbState(key: key);
}

class ProfilePhotoThumbState extends State<ProfilePhotoThumb> implements RecordSetThumbInterface{
  ProfilePhotoThumbState({Key key});

  ProfilePhotoThumbData _data;
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
