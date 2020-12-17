import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/gifts/user_gift_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';

class ProfileGiftThumb extends StatefulWidget {
  ProfileGiftThumb({Key key, @required this.giftInfo}) : super(key: key);

  static Size size = Size(100, 140);

  final UserGiftInfo giftInfo;

  ProfileGiftThumbState createState() => ProfileGiftThumbState();
}

class ProfileGiftThumbState extends State<ProfileGiftThumb>{
  ProfileGiftThumbState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        Container(
            margin: EdgeInsets.all(5),
            width: ProfileGiftThumb.size.width,
            height: ProfileGiftThumb.size.height,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[500], width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child:
                    Image.network(
                        widget.giftInfo.giftURL,
                        fit: BoxFit.fitHeight)
                ),
                Expanded(child: Container()),
                (widget.giftInfo.fromUser == null) ?
                Container(
                  width: ProfileGiftThumb.size.width,
                  height: 12,
                  child: Text(
                    AppLocalizations.of(context).translate("app_profile_privateGift"),
                    style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal)
                  )
                ) :
                GestureDetector(
                  onTap: (){
                    print("open Profile");
                  },
                  child: Container(
                      width: ProfileGiftThumb.size.width,
                      height: 12,
                      // padding: EdgeInsets.only( top: 10),
                      child:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon( Icons.face, color: widget.giftInfo.fromUser["sex"] == 1 ? Colors.blue : Colors.pink, size: 15),
                          Flexible(
                           // width: ProfileGiftThumb.size.width-10,
                              // padding: EdgeInsets.symmetric(horizontal: 3),
                              child: Text(widget.giftInfo.fromUser["username"], overflow: TextOverflow.clip, style: Theme.of(context).textTheme.headline6, textAlign: TextAlign.left)
                          ),
                          widget.giftInfo.fromUser["photoUrl"] == null ? Container() : Icon(Icons.camera_alt, color: Colors.orange, size: 10)
                        ],
                      )
                  ),
                )
              ],
            )
        );
  }
}
