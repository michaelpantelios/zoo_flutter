import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePhotoThumbData {
  final String url;
  final bool isPersonal;

  ProfilePhotoThumbData({this.url, this.isPersonal = false});
}

class ProfilePhotoThumb extends StatefulWidget {
  ProfilePhotoThumb({Key key, @required this.onClickHandler}) : super(key: key);

  final Function onClickHandler;

  ProfilePhotoThumbState createState() => ProfilePhotoThumbState(key: key);
}

class ProfilePhotoThumbState extends State<ProfilePhotoThumb> {
  ProfilePhotoThumbState({Key key});

  ProfilePhotoThumbData _data;
  bool mouseOver = false;
  Size size = new Size(70, 95);



  update(ProfilePhotoThumbData data) {
    setState(() {
      _data = data;
    });
  }

  clear() {
    print("clear");
    setState(() {
      _data = null;
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
            : GestureDetector(
                onTap: () {
                  widget.onClickHandler(_data.url);
                },
                child: Container(
                  margin: EdgeInsets.all(2),
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: mouseOver
                        ? Border.all(color: Colors.blue, width: 2)
                        : Border.all(color: Colors.grey[500], width: 1),
                  ),
                  child: Center(child: Image.network(_data.url)),
                )));
  }
}
