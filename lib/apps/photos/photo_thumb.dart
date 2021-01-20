import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/models/photos/user_photo_model.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class PhotoThumb extends StatefulWidget {
  PhotoThumb({Key key, @required this.photoData, @required this.onClickHandler, this.onSetAsMainHandler, this.onDeleteHandler}) ;

  static Size size = Size(130, 130);

  final Function onClickHandler;
  final Function onDeleteHandler;
  final Function onSetAsMainHandler;
  final UserPhotoModel photoData;

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
              widget.onClickHandler(widget.photoData.imageId);
            },
            child: Container(
              margin: EdgeInsets.all(5),
              width: PhotoThumb.size.width,
              height: PhotoThumb.size.height,
              color: Colors.white,
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
                                      Utils.instance.getUserPhotoUrl(photoId: widget.photoData.imageId.toString()),
                                      width: PhotoThumb.size.width,
                                      // height: PhotoThumb.size.height,
                                      fit: BoxFit.fitHeight))
                              ),
                              widget.photoData.main == 1 ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      color: Color(0x99000000),
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppLocalizations.of(context).translate("app_photos_main"),
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                                        textAlign: TextAlign.center,
                                      )
                                  )
                                ],
                              ) : Container(),
                              widget.photoData.approved == 0 ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(5),
                                      color: Color(0xdddb664c),
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppLocalizations.of(context).translate("app_photos_notApproved"),
                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal),
                                        textAlign: TextAlign.center,
                                      )
                                  )
                                ],
                              ) : Container(),
                              mouseOver ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 30,
                                      color: Color(0x99000000),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          widget.photoData.personal == 1 && widget.photoData.approved == 1 ? 
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
                                            message: AppLocalizations.of(context).translate("app_photos_thumb_mainTip"),
                                            child: ZButton(
                                              clickHandler: () {
                                                widget.onSetAsMainHandler(widget.photoData.imageId);
                                              },
                                              minWidth: 30,
                                              height: 30,
                                              buttonColor: Color(0x000000000),
                                              iconData: Icons.person,
                                              iconSize: 28,
                                              iconColor: Colors.white,
                                            )
                                          ) : Container(),
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
                                            message: AppLocalizations.of(context).translate("app_photos_thumb_deleteTip"),
                                            child: ZButton(
                                              clickHandler:() {
                                                widget.onDeleteHandler(widget.photoData.imageId);
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
            )
        )
    );
  }


}
