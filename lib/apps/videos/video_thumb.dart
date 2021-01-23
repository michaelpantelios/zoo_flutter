import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/models/video/user_video_model.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class VideoThumb extends StatefulWidget {
  VideoThumb({Key key, @required this.videoInfo, @required this.onClickHandler, this.onDeleteHandler});

  static Size size = Size(130, 130);

  final Function onClickHandler;
  final Function onDeleteHandler;
  final UserVideoModel videoInfo;

  VideoThumbState createState() => VideoThumbState();
}

class VideoThumbState extends State<VideoThumb>{
  VideoThumbState();

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
              widget.onClickHandler(widget.videoInfo.id);
            },
            child: Container(
              margin: EdgeInsets.all(5),
              width: VideoThumb.size.width,
              height: VideoThumb.size.height,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Stack(
                      children: [
                        Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                                child: Image.network(
                                    Utils.instance.getUserPhotoUrl(
                                        photoId: widget.videoInfo.captureId.toString()),
                                    width: VideoThumb.size.width,
                                    fit: BoxFit.fitHeight)
                            )
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(5),
                                color: Color(0x99000000),
                                alignment: Alignment.center,
                                child: Text(
                                  Utils.instance.getNiceDurationFromSecs(context, int.parse(widget.videoInfo.length.toString())),
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.center,
                                )
                            )
                          ],
                        ),
                        mouseOver ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                height: 30,
                                color: Color(0x99000000),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Tooltip(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(9),
                                          boxShadow: [
                                            new BoxShadow(color: Color(0x55000000), offset: new Offset(1.0, 1.0), blurRadius: 2, spreadRadius: 2),
                                          ],
                                        ),
                                        message: AppLocalizations.of(context).translate("app_videos_btnDelete"),
                                        child: ZButton(
                                          clickHandler:() {
                                            widget.onDeleteHandler(widget.videoInfo.id);
                                          },
                                          minWidth: 30,
                                          height: 30,
                                          buttonColor: Color(0x000000000),
                                          iconData: Icons.delete,
                                          iconSize: 28,
                                          iconColor: Colors.white,
                                        )
                                    )
                                  ],
                                )
                            )
                          ],
                        )
                            : Container()
                      ],
                    )
                  )
                ],
              )
              ,
            )));
  }


}
