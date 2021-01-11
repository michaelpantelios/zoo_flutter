import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/profile/profile_info.dart';
import 'package:zoo_flutter/models/user/user_main_photo.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/apps/protector/protector.dart';


class ProfileBasic extends StatefulWidget {
  ProfileBasic(
      {Key key,
      this.profileInfo,
      this.myWidth,
      this.isMe,
    });

  final ProfileInfo profileInfo;
  final double myWidth;
  final bool isMe;

  ProfileBasicState createState() => ProfileBasicState();
}

class ProfileBasicState extends State<ProfileBasic> {
  ProfileBasicState();

  GlobalKey<ZButtonState> _onAddFriendButtonKey;
  GlobalKey<ZButtonState> _onSendGiftButtonKey;
  GlobalKey<ZButtonState> _onSendMailButtonKey;

  double photoSize = 100;

  MainPhoto _mainPhoto;
  String _mainPhotoId;
  String _country;
  bool _isStar;
  String _status;
  String _city;
  String _zodiacString;
  RPC _rpc;

  double _dataColumnWidth = 200;

  _onEditProfileHandler(BuildContext context){
    PopupManager.instance.show(context: context, options: widget.profileInfo, popup: PopupType.ProfileEdit, callbackAction: (retVal)=>{
       if (retVal != null){
        _onEditProfileComplete(context, retVal)
       }
    });
  }

  _onEditProfileComplete(BuildContext context, dynamic data) async {
    var res = await _rpc.callMethod("Zoo.Account.updateBasicInfo", [data]);

    if (res["status"] == "ok") {
      print("Edit Profile Complete");
      AlertManager.instance.showSimpleAlert(context: context,
          bodyText: AppLocalizations.of(context).translate("app_profile_edit_basicInfoUpdateComplete"));
    } else {
      print("ERROR");
      print(res);
    }
  }


  _onEditPhotosHandler() {
    print("edit photos");
    PopupManager.instance.show(
        context: context,
        popup: PopupType.Photos,
        options: widget.profileInfo.user.userId,
        callbackAction: (retValue) {});
  }

  _onEditVideosHandler() {
    print("edit photos");
    AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText:
            AppLocalizations.of(context).translate("unavailable_service"));
    // PopupManager.instance.show(context: context, popup: PopupType.Videos, options: widget.profileInfo.user.username, callbackAction: (retValue) {});
  }

  _onSendFriendshipRequest(BuildContext context) {
    AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translateWithArgs("request_friendship_body", [widget.profileInfo.user.username]), callbackAction: (retValue) {
      if (retValue == 1)
        _doSendFriendshipRequest(context, widget.profileInfo);
    }, dialogButtonChoice: AlertChoices.OK_CANCEL);
  }

  _doSendFriendshipRequest(BuildContext context, ProfileInfo targetInfo,{ int charge = 1 }) async {
   print("_doSendFriendshipRequest");
    var res = await _rpc.callMethod("Messenger.Client.createFriendshipRequest",  [targetInfo.user.userId, charge]);

    print("_doSendFriendshipRequest res");
    print("=====ADDING FRIEND====");
    print("Status: " + res["status"].toString());
    if (res["status"] == "ok")
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("request_friendship_ok"));
    else {
      switch(res["errorMsg"]) {
        case "ok":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("request_friendship_ok"));
          break;
        case "not_authenticated":
          AlertManager.instance.showSimpleAlert(context: context, bodyText:AppLocalizations.of(context).translate("request_friendship_not_authenticated"));
          break;
        case "not_authorized":
          AlertManager.instance.showSimpleAlert(context: context, bodyText:AppLocalizations.of(context).translate("request_friendship_not_authorized"));
          break;
        case "invalid_user":
          AlertManager.instance.showSimpleAlert(context: context, bodyText:AppLocalizations.of(context).translate("request_friendship_invalid_user"));
          break;
        case "double_action":
          AlertManager.instance.showSimpleAlert(context: context, bodyText:AppLocalizations.of(context).translate("request_friendship_double_action"));
          break;
        case "user_blocked":
          AlertManager.instance.showSimpleAlert(context: context, bodyText:AppLocalizations.of(context).translate("request_friendship_blocked"));
          break;
        case "max_friends":
          AlertManager.instance.showSimpleAlert(context: context, bodyText:AppLocalizations.of(context).translate("request_friendship_max_friends"));
          break;
        case "no_coins":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("request_friendship_no_coins"), callbackAction: (retValue) {
            if (retValue == 1)
              PopupManager.instance.show(context: context, popup: PopupType.Coins);
          });
          break;
        case "limit_reached":
          AlertManager.instance.showSimpleAlert(context: context, bodyText:AppLocalizations.of(context).translate("limit_reached"));
          break;
        case "friend_already":
          AlertManager.instance.showSimpleAlert(context: context, bodyText:AppLocalizations.of(context).translate("friend_already"));
          break;
        case "no_collectibles":
          AlertManager.instance.showSimpleAlert(context: context, bodyText:AppLocalizations.of(context).translate("no_collectibles"));
          break;
        case "coins_required":
          PopupManager.instance.show(context: context, options: CostTypes.add_friend, popup: PopupType.Protector,
              callbackAction: (retVal) => {
                if (retVal == "ok")
                  _doSendFriendshipRequest(context, targetInfo, charge: 1)
              });
          break;
        default:
          print(res);
          print("status: "+res["status"]);
          break;
      }
    }
  }

  _onSendGift() {
    PopupManager.instance.show(
        context: context,
        popup: PopupType.Gifts,
        options: widget.profileInfo.user.username,
        headerOptions: widget.profileInfo.user.username
    );
  }

  _onSendMail() {
    PopupManager.instance.show(
        context: context,
        popup: PopupType.MailNew,
        options: widget.profileInfo.user.username);
  }

  @override
  void initState() {
    _rpc = RPC();
    _onAddFriendButtonKey = new GlobalKey<ZButtonState>();
    _onSendGiftButtonKey = new GlobalKey<ZButtonState>();
    _onSendMailButtonKey = new GlobalKey<ZButtonState>();

    print("USER STATUS: ");
    print(widget.profileInfo.status);

    if (widget.profileInfo.user.mainPhoto != null &&
        widget.profileInfo.user.mainPhoto["image_id"] != null)
      _mainPhotoId = widget.profileInfo.user.mainPhoto["image_id"].toString();

    if (widget.profileInfo.status != null)
      _status = widget.profileInfo.status.replaceAll('"', "");
    else
      _status = "";

    if (widget.profileInfo.city != null)
      _city = widget.profileInfo.city.toString();
    else _city= "";

    super.initState();
  }

  @override
  void didChangeDependencies() {


    if (widget.profileInfo.country != null)
      _country = Utils.instance
          .getCountriesNames(
              context)[int.parse(widget.profileInfo.country.toString())]
          .toString();
    else
      _country = "--";

     if (widget.profileInfo.zodiacSign != null){
       List<String> zodiacStrings = AppLocalizations.of(context).translate("zodiac").split(",");
       _zodiacString = zodiacStrings[int.parse(widget.profileInfo.zodiacSign.toString())];
     } else _zodiacString = "";

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    basicAreaRecord(String label, String data, double width, { bool showTooltip = false }) {
      return Container(
          width: width,
          padding: EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Flexible(
                  child:
              (showTooltip && data != null) ?
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
                  message: label + data,
                  child: Text(data == null ? "" : data,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w200),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1
                  )
                ) :
                  Text(data == null ? "" : data,
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w200),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1
                  )
              )
            ],
          ));
    }

    return Column(
      children: [
        Container(
            width: widget.myWidth,
            height: 35,
            padding: EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(widget.profileInfo.user.username,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left),
                Expanded(child: Container()),
                Text(
                    AppLocalizations.of(context).translate(
                        widget.profileInfo.online.toString() == "1"
                            ? "app_profile_lblOn"
                            : "app_profile_lblOff"),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500)),
                SizedBox(width: 5),
                Icon(Icons.circle,
                    color: int.parse(widget.profileInfo.online.toString()) == 1
                        ? Color(0xff21e900)
                        : Color(0xffff6161),
                    size: 25),
              ],
            )),
        Container(
            padding: EdgeInsets.all(15),
            width: widget.myWidth - 30,
            height: 130,
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                shape: BoxShape.rectangle,
                border: Border.all(color: Color(0xff9598a4), width: 2),
                borderRadius: BorderRadius.circular(9)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: (_mainPhotoId != null)
                      ?
                      GestureDetector(
                        onTap: (){
                          PopupManager.instance.show(context: context, popup: PopupType.PhotoViewer, options: int.parse(_mainPhotoId.toString()));
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Image.network(
                              Utils.instance.getUserPhotoUrl(
                                  photoId: _mainPhotoId, size: "normal"),
                              height: 100,
                              width: 100,
                              fit: BoxFit.fitWidth)
                          )
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          color: Theme.of(context).primaryColor,
                          child: Image.asset(
                              int.parse(widget.profileInfo.user.sex
                                          .toString()) ==
                                      1
                                  ? "assets/images/general/male_user.png"
                                  : "assets/images/general/female_user.png",
                              height: 80,
                              width: 80,
                              fit: BoxFit.contain),
                        ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    basicAreaRecord(
                        AppLocalizations.of(context)
                            .translate("app_profile_lblQuote"),
                        _status,
                        _dataColumnWidth, showTooltip: true),
                    basicAreaRecord(
                        AppLocalizations.of(context)
                            .translate("app_profile_lblGender"),
                        Utils.instance
                            .getSexString(context, widget.profileInfo.user.sex),
                        _dataColumnWidth),
                    basicAreaRecord(
                        AppLocalizations.of(context)
                            .translate("app_profile_lblAge"),
                        widget.profileInfo.age.toString(),
                        _dataColumnWidth),
                    basicAreaRecord(
                        AppLocalizations.of(context)
                            .translate("app_profile_lblZodiac"),
                        _zodiacString,
                        _dataColumnWidth),
                    basicAreaRecord(
                        AppLocalizations.of(context)
                            .translate("app_profile_lblArea"),
                        _city + "," + _country,
                        _dataColumnWidth)
                  ],
                ),
                SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    basicAreaRecord(
                        AppLocalizations.of(context)
                            .translate("app_profile_lblSignup"),
                        Utils.instance.getNiceDate(int.parse(widget
                            .profileInfo.createDate["__datetime__"]
                            .toString())),
                        _dataColumnWidth),
                    basicAreaRecord(
                        AppLocalizations.of(context)
                            .translate("app_profile_lblLastLogin"),
                        Utils.instance.getNiceDate(int.parse(widget
                            .profileInfo.lastLogin["__datetime__"]
                            .toString())),
                        _dataColumnWidth),
                    basicAreaRecord(
                        AppLocalizations.of(context)
                            .translate("app_profile_lblOnlineTime"),
                        Utils.instance.getNiceDuration(
                            context,
                            int.parse(
                                widget.profileInfo.onlineTime.toString())),
                        _dataColumnWidth),
                    widget.profileInfo.user.star == 0 ? Container() : Container(
                      width : _dataColumnWidth,
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context).translate("app_profile_star_label"),
                          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 22, fontWeight: FontWeight.w500)),
                          Padding(padding: EdgeInsets.only(left: 10),
                          child: Icon(Icons.star, color: Theme.of(context).accentColor, size: 30))
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 100, height: 120,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(9)),
                      child: Center(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                                AppLocalizations.of(context)
                                    .translate("app_profile_zlevel_label"),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                            Text(widget.profileInfo.level.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center),
                          ],
                      ))),
                ),
              ],
            )),
        (widget.isMe)
            ? Container(
                width: widget.myWidth,
                height: 40,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ZButton(
                        key: GlobalKey(),
                        minWidth: 190,
                        height: 40,
                        buttonColor: Theme.of(context).buttonColor,
                        clickHandler: ()=> {_onEditProfileHandler(context)},
                        label: AppLocalizations.of(context)
                            .translate("app_profile_editBasicInfo"),
                        hasBorder: false,
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        iconData: Icons.person,
                        iconColor: Colors.white,
                        iconSize: 25,
                        iconPosition: ZButtonIconPosition.right,
                    ),
                    SizedBox(width:10),
                    ZButton(
                        minWidth: 190,
                        height: 40,
                        buttonColor: Theme.of(context).accentColor,
                        key: GlobalKey(),
                        clickHandler: _onEditPhotosHandler,
                        label: AppLocalizations.of(context)
                            .translate("app_profile_editBasicInfo"),
                        hasBorder: false,
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        iconData: Icons.camera_alt,
                        iconColor: Colors.white,
                        iconSize: 25,
                        iconPosition: ZButtonIconPosition.right,
                    ),
                    SizedBox(width:10),
                    ZButton(
                        minWidth: 190,
                        height: 40,
                        buttonColor: Color(0xff3c8d40),
                        key: GlobalKey(),
                        clickHandler: _onEditVideosHandler,
                        label: AppLocalizations.of(context)
                            .translate("app_profile_editBasicInfo"),
                        hasBorder: false,
                        labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                        iconData: Icons.videocam,
                        iconColor: Colors.white,
                        iconSize: 25,
                        iconPosition: ZButtonIconPosition.right,
                    ),
                  ],
                ))
            : SizedBox(height: 10),
        widget.isMe
            ? Container()
            : Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ZButton(
                       minWidth: 190,
                       height: 40,
                       key: _onSendMailButtonKey,
                       clickHandler: _onSendMail,
                       label: AppLocalizations.of(context).translate("app_profile_sendMail"),
                       labelStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                       iconData: Icons.mail,
                       iconSize: 25,
                       iconColor: Colors.white,
                       buttonColor: Theme.of(context).buttonColor,
                      iconPosition: ZButtonIconPosition.right,
                    ),
                    SizedBox(width:10),
                    ZButton(
                      minWidth: 190,
                      height: 40,
                      key: _onAddFriendButtonKey,
                      clickHandler:(){ _onSendFriendshipRequest(context); },
                      label: AppLocalizations.of(context).translate("app_profile_addFriend"),
                      labelStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
                      iconData: Icons.person_add_alt_1,
                      iconSize: 25,
                      iconColor: Colors.white,
                      buttonColor: Theme.of(context).accentColor,
                      iconPosition: ZButtonIconPosition.right,
                    ),
                    SizedBox(width:10),
                    ZButton(
                      minWidth: 190,
                      height: 40,
                      key: _onSendGiftButtonKey,
                      clickHandler: _onSendGift,
                      label: AppLocalizations.of(context)
                          .translate("app_profile_sendGift"),
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                      iconData: FontAwesomeIcons.gift,
                      iconSize: 25,
                      iconColor: Colors.white,
                      buttonColor: Color(0xff3c8d40),
                      iconPosition: ZButtonIconPosition.right,
                    ),
                  ],
                ),
              )
      ],
    );
  }
}
