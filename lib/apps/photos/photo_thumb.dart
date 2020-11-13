import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class PhotoThumbData{
  String id;
  String photoUrl;
  bool isMain;

  PhotoThumbData({@required this.id, this.photoUrl, this.isMain});
}

class PhotoThumb extends StatefulWidget{
  PhotoThumb({Key key}) : super(key: key);

  PhotoThumbState createState() => PhotoThumbState(key: key);
}

class PhotoThumbState extends State<PhotoThumb>{
  PhotoThumbState({Key key});

  PhotoThumbData _data;
  bool mouseOver = false;
  Size size = new Size(70, 95);

  update(PhotoThumbData data){
    setState(() {
      _data = data;
    });
  }

  clear(){
    print("clear");
    setState(() {
      _data = null;
    });
  }

  onSetAsMain(){

  }

  onDelete(){

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
          onEnter: (_){
            setState(() {
              mouseOver = true;
            });
          },
          onExit: (_){
            setState(() {
              mouseOver = false;
            });
          },
          child: _data == null ? Container() : Container(
                  margin: EdgeInsets.all(2),
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: mouseOver ? Border.all(color: Colors.blue, width: 2) : Border.all(color: Colors.grey[500], width: 1) ,
                  ),
                  child: Stack(
                    children: [
                      Center(child: Image.network(_data.photoUrl)),
                      Column(
                        children: [
                          mouseOver ?
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Tooltip(
                                  message: AppLocalizations.of(context).translate("app_photos_thumb_mainTip"),
                                  child: Container(
                                      color: Colors.blue,
                                      child: ZButton(
                                          clickHandler: onSetAsMain,
                                          icon: Icons.filter_center_focus,
                                          iconColor: Colors.white,
                                          iconSize: 25,
                                      )
                                  )
                                ),
                                Expanded(child: Container()),
                                Tooltip(
                                  message: AppLocalizations.of(context).translate("app_photos_thumb_deleteTip"),
                                  child: Container(
                                      color: Colors.red,
                                      child: ZButton(
                                          clickHandler: onDelete,
                                          icon: Icons.delete_forever,
                                          iconColor: Colors.white,
                                          iconSize: 25,
                                      )
                                  )
                                )
                              ],
                            ),
                          )
                          : Container(),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _data.isMain ? Container(
                              decoration: BoxDecoration(
                                  color: new Color.fromRGBO(10, 10, 10, 0.8) // Specifies the background color and the opacity
                              ),
                              child: Center(
                                child: Text(AppLocalizations.of(context).translate("app_photos_main"),
                                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              )
                          ) : Container()
                        ],
                      )
                    ],
                  )
              ),
        );
  }
}