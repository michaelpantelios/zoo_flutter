import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/models/video/user_video_info.dart';

class ProfileVideoThumb extends StatefulWidget {
  ProfileVideoThumb({Key key, @required this.videoInfo, @required this.onClickHandler});

  static Size size = Size(100, 100);

  final Function onClickHandler;
  final UserVideoInfo videoInfo;

  ProfileVideoThumbState createState() => ProfileVideoThumbState();
}

class ProfileVideoThumbState extends State<ProfileVideoThumb>{
  ProfileVideoThumbState();

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
        child:  GestureDetector(
            onTap: (){
              widget.onClickHandler(widget.videoInfo);
            },
            child: Container(
              margin: EdgeInsets.all(5),
              width: ProfileVideoThumb.size.width,
              height: ProfileVideoThumb.size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                border: mouseOver
                    ? Border.all(color: Colors.blue, width: 2)
                    : Border.all(color: Colors.grey[500], width: 1),
              ),
              child: Center(
                  child: Image.network(
                      Utils.instance.getUserPhotoUrl(photoId: widget.videoInfo.captureId.toString()),
                      fit: BoxFit.fitHeight)
              ),
            )));
  }


}
