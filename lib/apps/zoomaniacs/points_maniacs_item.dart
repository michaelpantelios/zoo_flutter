import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/maniacs/points_maniac_record.dart';
import 'package:zoo_flutter/utils/utils.dart';

class PointsManiacsItem extends StatefulWidget {
  PointsManiacsItem({Key key});

  static double myWidth = 330;
  static double myHeight = 55;

  PointsManiacsItemState createState() => PointsManiacsItemState(key: key);

}

class PointsManiacsItemState extends State<PointsManiacsItem>{
  PointsManiacsItemState({Key key});

  PointsManiacRecord _data;
  bool _hasMainPhoto = false;
  
  update(PointsManiacRecord data){
    setState(() {
      _data = data;
      if (data.user.mainPhoto != null)
        if (data.user.mainPhoto["image_id"] != null) _hasMainPhoto = true;
    });
  }

  clear(){
    setState(() {
     _data = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _data == null ? SizedBox(width: PointsManiacsItem.myWidth, height: PointsManiacsItem.myHeight) :
        GestureDetector(
          onTap: (){

          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: PointsManiacsItem.myWidth,
              height: PointsManiacsItem.myHeight,
              child: Center(
                child: Container(
                  width: PointsManiacsItem.myWidth - 10,
                  height: PointsManiacsItem.myHeight - 10,
                  padding: EdgeInsets.all(10),
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
                      Padding(padding: EdgeInsets.only(right: 5), child: Text((index + 1).toString(), style: TextStyle(color: Color(0xffBFC1C4), fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
                      ClipOval(
                        child: _hasMainPhoto
                            ? Image.network(Utils.instance.getUserPhotoUrl(photoId: data.user.mainPhoto["image_id"].toString()), height: 45, width: 45, fit: BoxFit.contain)
                            : Image.asset(data.user.sex == 1 ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 45, width: 45, fit: BoxFit.contain),
                      ),
                      Container(width: _usernameFieldWidth, margin: EdgeInsets.only(left: 5), child: Text(data.user.username, style: TextStyle(color: Color(0xffFF9C00), fontSize: 15), overflow: TextOverflow.ellipsis, maxLines: 1)),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Image.asset("assets/images/home/star.png")),
                      Spacer(),
                      Text(data.points.toString(), style: TextStyle(color: Color(0xffFF9C00), fontSize: 25))
                    ],
                  )
                )
              )
            )
          )
        );
  }


}