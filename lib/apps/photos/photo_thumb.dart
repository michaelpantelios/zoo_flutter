import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/utils.dart';

class PhotoThumb extends StatefulWidget {
  PhotoThumb({Key key, @required this.photoId, @required this.onClickHandler}) ;

  static Size size = Size(100, 100);

  final Function onClickHandler;
  final int photoId;

  PhotoThumbState createState() => PhotoThumbState();
}

class PhotoThumbState extends State<PhotoThumb>{
  PhotoThumbState();

  bool mouseOver = false;

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
        child: GestureDetector(
            onTap: (){
              widget.onClickHandler(widget.photoId);
            },
            child: Container(
              margin: EdgeInsets.all(5),
              width: PhotoThumb.size.width,
              height: PhotoThumb.size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                border: mouseOver
                    ? Border.all(color: Colors.blue, width: 2)
                    : Border.all(color: Colors.grey[500], width: 1),
              ),
              child: Center(
                  child: Image.network(
                      Utils.instance.getUserPhotoUrl(photoId: widget.photoId.toString()),
                      fit: BoxFit.fitHeight)
              ),
            )
        )
    );
  }


}
