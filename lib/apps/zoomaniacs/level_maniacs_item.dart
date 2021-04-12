import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/maniacs/points_maniac_record.dart';
import 'package:zoo_flutter/models/maniacs/level_maniac_record.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

class LevelManiacsItem extends StatefulWidget {
  LevelManiacsItem({Key key}): super(key: key);

  static double myWidth = 500;
  static double myHeight = 60;

  LevelManiacsItemState createState() => LevelManiacsItemState(key: key);
}

class LevelManiacsItemState extends State<LevelManiacsItem>{
  LevelManiacsItemState({Key key});

  LevelManiacRecord _data;
  bool _hasMainPhoto = false;
  double _usernameFieldWidth = 200;
  int _index = 0;

  update(LevelManiacRecord data){
    setState(() {
      _hasMainPhoto = false;
      _data = data;
      if (data.user.mainPhoto != null)
        if (data.user.mainPhoto["image_id"] != null)
          _hasMainPhoto = true;
    });
  }

  clear(){
    setState(() {
      _data = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _data == null ? SizedBox(width: LevelManiacsItem.myWidth, height: LevelManiacsItem.myHeight) :
    GestureDetector(
        onTap: (){
          PopupManager.instance.show(context: context, popup: PopupType.Profile, options: _data.user.userId, callbackAction: (retValue) {});
        },
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
                width: LevelManiacsItem.myWidth,
                height: LevelManiacsItem.myHeight,
                child: Center(
                    child: Container(
                        width: LevelManiacsItem.myWidth - 10,
                        height: LevelManiacsItem.myHeight - 10,
                        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            new BoxShadow(color: Color(0x33000000), offset: new Offset(0.0, 0.0), blurRadius: 2, spreadRadius: 2),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipOval(
                              child: _hasMainPhoto
                                  ? Image.network(Utils.instance.getUserPhotoUrl(photoId: _data.user.mainPhoto["image_id"].toString()), height: 40, width: 40, fit: BoxFit.cover)
                                  : Image.asset(_data.user.sex == 1 ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 40, width: 40, fit: BoxFit.contain),
                            ),
                            Container(width: _usernameFieldWidth, margin: EdgeInsets.only(left: 5), child: Text(_data.user.username, style: TextStyle(color: Color(0xffFF9C00), fontSize: 15), overflow: TextOverflow.ellipsis, maxLines: 1)),
                            _data.user.star == 1 ? Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Image.asset("assets/images/home/star.png")) : Container(),
                            Spacer(),
                            Text(_data.level.toString(), style: TextStyle(color: Color(0xffFF9C00), fontSize: 25))
                          ],
                        )
                    )
                )
            )
        )
    );
  }


}