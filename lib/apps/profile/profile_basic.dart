import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class ProfileBasic extends StatefulWidget {
  ProfileBasic({Key key, this.profileInfo, this.myWidth, this.isMe, this.isOnline});

  final ProfileInfo profileInfo;
  final double myWidth;
  final bool isMe;
  final bool isOnline;

  ProfileBasicState createState() => ProfileBasicState();
}

class ProfileBasicState extends State<ProfileBasic> {
  ProfileBasicState();

  GlobalKey<ZButtonState> editProfileInfoButtonKey;
  GlobalKey<ZButtonState> onAddFriendButtonKey;
  GlobalKey<ZButtonState> onSendGiftButtonKey;
  GlobalKey<ZButtonState> onSendMessageButtonKey;

  double photoSize = 100;

  onEditProfileHandler() {
    print("EditMe");
  }

  onAddFriendHandler() {}

  onSendGiftHandler() {}

  onSendMessageHandler() {}

  @override
  void initState() {
    editProfileInfoButtonKey = new GlobalKey<ZButtonState>();
    onAddFriendButtonKey = new GlobalKey<ZButtonState>();
    onSendGiftButtonKey = new GlobalKey<ZButtonState>();
    onSendMessageButtonKey = new GlobalKey<ZButtonState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    basicAreaRecord(String label, String data) {
      return Container(
          padding: EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Text(
                data,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
                softWrap: true,
              )
            ],
          ));
    }

    return Column(
      children: [
        Container(
            width: widget.myWidth,
            color: Colors.orange[700],
            height: 30,
            padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.profileInfo.user.username, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(child: Container()),
                Text(AppLocalizations.of(context).translate(widget.isOnline ? "app_profile_lblOn" : "app_profile_lblOff"), style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.normal)),
                SizedBox(width: 5),
                FaIcon(widget.profileInfo.isOnline ? FontAwesomeIcons.grinAlt : FontAwesomeIcons.mehBlank, color: Colors.white, size: 20),
              ],
            )),
        Container(
            // padding: EdgeInsets.all(5),
            width: widget.myWidth,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.orangeAccent[50],
              border: Border.all(color: Colors.orange[700], width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: photoSize + 10,
                    height: 130,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border(right: BorderSide(color: Colors.orange[700], width: 1)),
                    ),
                    child: (widget.profileInfo.user.username == "" || widget.profileInfo.user.mainPhoto == null)
                        ? FaIcon(widget.profileInfo.user.sex == 4 ? FontAwesomeIcons.userFriends : Icons.face,
                            size: photoSize,
                            color: widget.profileInfo.user.sex == 1
                                ? Colors.blue
                                : widget.profileInfo.user.sex == 2
                                    ? Colors.pink
                                    : Colors.green)
                        : Image.network(widget.profileInfo.user.mainPhoto, fit: BoxFit.fitHeight)),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblQuote"), widget.profileInfo.status),
                            SizedBox(height: 2),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblGender"), Utils.instance.getSexString(context, widget.profileInfo.user.sex)),
                                    basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblAge"), widget.profileInfo.age.toString()),
                                    basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblZodiac"), widget.profileInfo.zodiacSign.toString()),
                                    basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblArea"), widget.profileInfo.city + ", " + widget.profileInfo.country.toString())
                                  ],
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblSignup"), widget.profileInfo.createDate),
                                    basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblLastLogin"), widget.profileInfo.lastLogin),
                                    basicAreaRecord(AppLocalizations.of(context).translate("app_profile_lblOnlineTime"), widget.profileInfo.onlineTime.toString())
                                  ],
                                )
                              ],
                            )
                          ],
                        ))),
                Container(
                    decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.orange[700], width: 1)),
                    ),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Zoo Level", style: TextStyle(color: Colors.indigoAccent, fontSize: 20, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                        SizedBox(height: 5),
                        Text(widget.profileInfo.level.toString(), style: TextStyle(color: Colors.red, fontSize: 25, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                        SizedBox(height: 5),
                        Icon(Icons.star, size: 55, color: widget.profileInfo.user.isStar ? Colors.orange[300] : Colors.white)
                      ],
                    )),
              ],
            )),
        (widget.isMe)
            ? Center(
                child: Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 100,
                color: Colors.orange[700],
                // padding : EdgeInsets.all(5),
                child: ZButton(key: editProfileInfoButtonKey, clickHandler: onEditProfileHandler, label: AppLocalizations.of(context).translate("app_profile_app_profile_editBasicInfo"), labelStyle: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ))
            : Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: 180,
                        height: 40,
                        child: ZButton(
                          key: onAddFriendButtonKey,
                          clickHandler: onAddFriendHandler,
                          label: AppLocalizations.of(context).translate("app_profile_addFriend"),
                          labelStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          iconData: Icons.face_retouching_natural,
                          iconSize: 25,
                          iconColor: Colors.white,
                          buttonColor: Colors.green,
                        )),
                    Container(
                        width: 180,
                        height: 40,
                        child: ZButton(
                          key: onSendGiftButtonKey,
                          clickHandler: onSendGiftHandler,
                          label: AppLocalizations.of(context).translate("app_profile_sendGift"),
                          labelStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          iconData: FontAwesomeIcons.gift,
                          iconSize: 25,
                          iconColor: Colors.white,
                          buttonColor: Colors.pink,
                        )),
                    Container(
                        width: 180,
                        height: 40,
                        child: ZButton(
                          key: onSendMessageButtonKey,
                          clickHandler: onSendMessageHandler,
                          label: AppLocalizations.of(context).translate("app_profile_chat"),
                          labelStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                          iconData: FontAwesomeIcons.comment,
                          iconSize: 25,
                          iconColor: Colors.white,
                          buttonColor: Colors.blue,
                        ))
                  ],
                ),
              )
      ],
    );
  }
}
