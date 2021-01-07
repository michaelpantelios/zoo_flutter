import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/utils.dart';

class ProfilePhotoThumb extends StatefulWidget {
  ProfilePhotoThumb({Key key, @required this.photoId, @required this.onClickHandler}) ;

  static Size size = Size(100, 100);

  final Function onClickHandler;
  final int photoId;

  ProfilePhotoThumbState createState() => ProfilePhotoThumbState();
}

class ProfilePhotoThumbState extends State<ProfilePhotoThumb>{
  ProfilePhotoThumbState();

  bool mouseOver = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: (){
            widget.onClickHandler(widget.photoId);
          },
          child: Container(
            margin: EdgeInsets.all(5),
            width: ProfilePhotoThumb.size.width,
            height: ProfilePhotoThumb.size.height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.network(
                      Utils.instance.getUserPhotoUrl(photoId: widget.photoId.toString()),
                      fit: BoxFit.fitHeight),
                )
                
            ),
          )
      );
  }


}
