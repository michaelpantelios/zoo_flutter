import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CameraPhotoThumb extends StatefulWidget {
  CameraPhotoThumb({Key key, @required this.id, @required this.onClickHandler}) : super(key: key);

  final String id;
  final Function onClickHandler;

  CameraPhotoThumbState createState() => CameraPhotoThumbState(key: key);
}

class CameraPhotoThumbState extends State<CameraPhotoThumb> {
  CameraPhotoThumbState({Key key});

  bool selected = false;
  bool active = true;
  Image theImage;

  @override
  void initState() {
    theImage = Image.asset("assets/images/default.png");
    super.initState();
  }

  setSelected(bool value) {
    setState(() {
      selected = value;
    });
  }

  setActive(bool value) {
    setState(() {
      active = value;
    });
  }

  setSource() async {
    setState(() {
      active = true;
      //todo capture camera image and set it as source
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (active && !selected) widget.onClickHandler(widget.id);
        },
        child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              border: selected ? Border.all(color: Colors.blueAccent, width: 2) : Border.all(color: Colors.black38, width: 1),
            ),
            // child: active ? Icon(Icons.face, color: Colors.orange, size: 25) : Icon(Icons.not_interested, color: Colors.red, size: 50)
            child: theImage));
  }
}
