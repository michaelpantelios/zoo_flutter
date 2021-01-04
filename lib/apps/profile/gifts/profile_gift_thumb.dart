import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/gifts/user_gift_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';

class ProfileGiftThumb extends StatefulWidget {
  ProfileGiftThumb({Key key, @required this.giftInfo});

  static Size size = Size(100, 140);

  final UserGiftInfo giftInfo;

  ProfileGiftThumbState createState() => ProfileGiftThumbState();
}

class ProfileGiftThumbState extends State<ProfileGiftThumb>{
  ProfileGiftThumbState();

  @override
  void initState() {
    super.initState();
    print("fromUser");
    print(widget.giftInfo.fromUser);
  }

  onSenderClick(){
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: int.parse(widget.giftInfo.fromUser["userId"].toString()),  callbackAction: (retValue) {});
  }

  @override
  Widget build(BuildContext context) {
    return
        Container(
            margin: EdgeInsets.all(5),
            width: ProfileGiftThumb.size.width-10,
            height: ProfileGiftThumb.size.height,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Color(0xffe8e6e6), width: 1),
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
                    style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center
                  )
                ) :
                GestureDetector(
                  onTap: onSenderClick,
                  child: Container(
                      width: ProfileGiftThumb.size.width,
                      height: 14,
                      // padding: EdgeInsets.only( top: 10),
                      child:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          int.parse(widget.giftInfo.fromUser["sex"].toString()) == 1 ? Image.asset("assets/images/user_renderers/male.png") : Image.asset("assets/images/user_renderers/female.png"),
                          SizedBox(width: 5),
                          Flexible(
                              child: Text(widget.giftInfo.fromUser["username"], overflow: TextOverflow.clip, style: TextStyle(
                                  fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.left)
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
