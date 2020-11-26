import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/models/user/user_info_model.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/Utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/widgets/z_button.dart';

class ProfileBasic extends StatefulWidget{
  ProfileBasic({Key key, this.userData, this.myWidth, this.isMe, this.isOnline});

  final UserInfoModel userData;
  final double myWidth;
  final bool isMe;
  final bool isOnline;

  ProfileBasicState createState() => ProfileBasicState();
}

class ProfileBasicState extends State<ProfileBasic>{
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
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
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

    return
      Column(
        children: [
          Container(
              width: widget.myWidth,
              color: Colors.orange[700],
              height: 30,
              padding: EdgeInsets.only(left: 10, top:5, bottom: 5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text(widget.userData.username,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Expanded(child: Container()),
                  Text(AppLocalizations.of(context).translate(widget.isOnline ? "app_profile_lblOn" : "app_profile_lblOff"),
                      style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.normal)
                  ),
                  SizedBox(width: 5),
                  FaIcon(widget.userData.isOnline ? FontAwesomeIcons.grinAlt : FontAwesomeIcons.mehBlank, color: Colors.white, size: 20),
                ],
              )
          ),
          Container(
            // padding: EdgeInsets.all(5),
              width: widget.myWidth,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.orangeAccent[50],
                border: Border.all(color:Colors.orange[700], width: 1),
              ),
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: photoSize + 10,
                      height: 130,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.orange[700], width: 1)),
                      ),
                      child: (widget.userData.photoUrl == "" || widget.userData.photoUrl == null)
                          ? FaIcon(
                          widget.userData.sex == 2
                              ? FontAwesomeIcons.userFriends
                              : Icons.face,
                          size: photoSize,
                          color: widget.userData.sex == 0
                              ? Colors.blue
                              : widget.userData.sex == 1
                              ? Colors.pink
                              : Colors.green)
                          : Image.network(widget.userData.photoUrl,
                          fit: BoxFit.fitHeight)),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              basicAreaRecord(
                                  AppLocalizations.of(context)
                                      .translate("app_profile_lblQuote"),
                                  widget.userData.quote),
                              SizedBox(height: 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      basicAreaRecord(
                                          AppLocalizations.of(context)
                                              .translate(
                                              "app_profile_lblGender"),
                                          Utils.instance.getSexString(
                                              context, widget.userData.sex)),
                                      basicAreaRecord(
                                          AppLocalizations.of(context)
                                              .translate(
                                              "app_profile_lblAge"),
                                          widget.userData.age.toString()),
                                      basicAreaRecord(
                                          AppLocalizations.of(context)
                                              .translate(
                                              "app_profile_lblZodiac"),
                                          widget.userData.zodiac),
                                      basicAreaRecord(
                                          AppLocalizations.of(context)
                                              .translate(
                                              "app_profile_lblArea"),
                                          widget.userData.city + ", " + widget.userData.country)
                                    ],
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      basicAreaRecord(
                                          AppLocalizations.of(context)
                                              .translate(
                                              "app_profile_lblSignup"),
                                          widget.userData.signupDate),
                                      basicAreaRecord(
                                          AppLocalizations.of(context)
                                              .translate(
                                              "app_profile_lblLastLogin"),
                                          widget.userData.lastLogin),
                                      basicAreaRecord(
                                          AppLocalizations.of(context)
                                              .translate(
                                              "app_profile_lblOnlineTime"),
                                          widget.userData.onlineTime)
                                    ],
                                  )
                                ],
                              )
                            ],
                          ))),
                  Container(
                      decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: Colors.orange[700], width: 1)),
                      ),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Zoo Level",
                              style: TextStyle(
                                  color: Colors.indigoAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900),
                              textAlign: TextAlign.center),
                          SizedBox(height: 5),
                          Text(widget.userData.zooLevel.toString(),
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900),
                              textAlign: TextAlign.center),
                          SizedBox(height: 5),
                          Icon(Icons.star,
                              size: 55,
                              color: widget.userData.star
                                  ? Colors.orange[300]
                                  : Colors.white)
                        ],
                      )),
                ],
              )
          ),
          (widget.isMe)
              ? Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 100,
                color: Colors.orange[700],
                // padding : EdgeInsets.all(5),
                child: ZButton(
                    key: editProfileInfoButtonKey,
                    clickHandler: onEditProfileHandler,
                    label: AppLocalizations.of(context)
                        .translate("app_profile_app_profile_editBasicInfo"),
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
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
                      label: AppLocalizations.of(context)
                          .translate("app_profile_addFriend"),
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
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
                      label: AppLocalizations.of(context)
                          .translate("app_profile_sendGift"),
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
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
                      label: AppLocalizations.of(context)
                          .translate("app_profile_chat"),
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
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
