import 'package:flutter/rendering.dart';
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
    return GestureDetector(
            onTap: (){
              widget.onClickHandler(widget.videoInfo);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child:Container(
                margin: EdgeInsets.all(5),
                width: ProfileVideoThumb.size.width,
                height: ProfileVideoThumb.size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.network(
                          Utils.instance.getUserPhotoUrl(photoId: widget.videoInfo.captureId.toString()),
                          fit: BoxFit.fitHeight)
                    )
                ),
            )));

  }


}
