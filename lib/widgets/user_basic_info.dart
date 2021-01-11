import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoo_flutter/apps/protector/protector.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';

class UserBasicInfo extends StatefulWidget {
  UserBasicInfo({Key key, @required this.basicUserInfo, @required this.size});

  final Map<String, dynamic> basicUserInfo;
  final Size size;

  @override
  _UserBasicInfoState createState() => _UserBasicInfoState();
}

class _UserBasicInfoState extends State<UserBasicInfo> {
  bool _userIsMyFriend = false;
  RPC _rpc;
  @override
  void initState() {
    super.initState();
    _rpc = RPC();

    var t = () async {
      var res = await _rpc.callMethod("Messenger.Client.getUserFriends", [UserProvider.instance.userInfo.userId]);
      if (res["status"] == "ok") {
        var recs = res["data"]["records"];
        for (var rec in recs) {
          if (rec["user"]["userId"] == widget.basicUserInfo["userId"]) {
            setState(() {
              _userIsMyFriend = true;
            });
            return;
          }
        }
      }
    };

    t();
  }

  _onSendFriendshipRequest(BuildContext context) {
    AlertManager.instance.showSimpleAlert(
        context: context,
        bodyText: AppLocalizations.of(context).translateWithArgs("request_friendship_body", [widget.basicUserInfo["username"]]),
        callbackAction: (retValue) {
          if (retValue == 1) _doSendFriendshipRequest(context, widget.basicUserInfo);
        },
        dialogButtonChoice: AlertChoices.OK_CANCEL);
  }

  _doSendFriendshipRequest(BuildContext context, Map<String, dynamic> targetInfo, {int charge = 1}) async {
    print("_doSendFriendshipRequest");
    var res = await _rpc.callMethod("Messenger.Client.createFriendshipRequest", [targetInfo["userId"], charge]);

    print("_doSendFriendshipRequest res");
    print("=====ADDING FRIEND====");
    print("Status: " + res["status"].toString());
    if (res["status"] == "ok")
      AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("request_friendship_ok"));
    else {
      switch (res["errorMsg"]) {
        case "ok":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("request_friendship_ok"));
          break;
        case "not_authenticated":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("request_friendship_not_authenticated"));
          break;
        case "not_authorized":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("request_friendship_not_authorized"));
          break;
        case "invalid_user":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("request_friendship_invalid_user"));
          break;
        case "double_action":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("request_friendship_double_action"));
          break;
        case "user_blocked":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("request_friendship_blocked"));
          break;
        case "max_friends":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("request_friendship_max_friends"));
          break;
        case "no_coins":
          AlertManager.instance.showSimpleAlert(
              context: context,
              bodyText: AppLocalizations.of(context).translate("request_friendship_no_coins"),
              callbackAction: (retValue) {
                if (retValue == 1) PopupManager.instance.show(context: context, popup: PopupType.Coins);
              });
          break;
        case "limit_reached":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("limit_reached"));
          break;
        case "friend_already":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("friend_already"));
          break;
        case "no_collectibles":
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("no_collectibles"));
          break;
        case "coins_required":
          PopupManager.instance.show(
            context: context,
            options: CostTypes.add_friend,
            popup: PopupType.Protector,
            callbackAction: (retVal) => {
              if (retVal == "ok") _doSendFriendshipRequest(context, targetInfo, charge: 1),
            },
          );
          break;
        default:
          print(res);
          print("status: " + res["status"]);
          AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("app_settings_alertFbPassError"));
          break;
      }
    }
  }

  _buttonsList() {
    var lst = [
      Tooltip(
        message: AppLocalizations.of(context).translate("userInfo_tpGift"),
        child: GestureDetector(
          onTap: () {
            print("send gift!");
            PopupManager.instance.show(context: context, popup: PopupType.Gifts, options: widget.basicUserInfo["username"], headerOptions: widget.basicUserInfo["username"], callbackAction: (retValue) {});
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Image.asset(
              "assets/images/general/gift_icon.png",
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
      Tooltip(
        message: AppLocalizations.of(context).translate("userInfo_tpProfile"),
        child: GestureDetector(
          onTap: () {
            print("show profile!");
            PopupManager.instance.show(context: context, popup: PopupType.Profile, options: widget.basicUserInfo["userId"], callbackAction: (retValue) {});
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Image.asset(
              "assets/images/general/profile_icon_2.png",
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    ];

    if (!_userIsMyFriend)
      lst.insert(
        0,
        Tooltip(
          message: AppLocalizations.of(context).translate("userInfo_tpFriends"),
          child: GestureDetector(
            onTap: () {
              print("add friend!");
              _onSendFriendshipRequest(context);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Image.asset(
                "assets/images/general/add_friend.png",
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
      );

    return lst;
  }

  @override
  Widget build(BuildContext context) {
    getSexString(int sex) {
      switch (sex) {
        case 0:
          return AppLocalizations.of(context).translate("user_sex_male");
        case 1:
          return AppLocalizations.of(context).translate("user_sex_female");
        case 2:
          return AppLocalizations.of(context).translate("user_sex_couple");
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(5),
      width: widget.size.width,
      height: widget.size.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xff9598a4),
          width: 2,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(7),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.basicUserInfo != null
            ? [
                if (widget.basicUserInfo["mainPhoto"] == null || widget.basicUserInfo["mainPhoto"] == null)
                  FaIcon(widget.basicUserInfo["sex"] == 2 ? FontAwesomeIcons.userFriends : Icons.face,
                      size: 110,
                      color: widget.basicUserInfo["sex"] == 0
                          ? Colors.blue
                          : widget.basicUserInfo["sex"] == 1
                              ? Colors.pink
                              : Colors.green)
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ClipOval(
                      child: Image.network(
                        Utils.instance.getUserPhotoUrl(photoId: widget.basicUserInfo["mainPhoto"]["image_id"].toString(), size: "normal"),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(left: 65, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("userInfo_username"),
                        style: TextStyle(color: Color(0xff393e54)),
                        textAlign: TextAlign.left,
                      ),
                      Expanded(
                        child: Text(
                          widget.basicUserInfo["username"].toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          softWrap: false,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 65, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("userInfo_sex"),
                        style: TextStyle(color: Color(0xff393e54)),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        getSexString(widget.basicUserInfo["sex"]),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 65, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("userInfo_age"),
                        style: TextStyle(color: Color(0xff393e54)),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.basicUserInfo["age"].toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 65, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("userInfo_country"),
                        style: TextStyle(color: Color(0xff393e54)),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.basicUserInfo["country"] == null ? "" : Utils.instance.getCountriesNames(context)[int.parse(widget.basicUserInfo["country"].toString())].toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 65, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).translate("userInfo_city"),
                        style: TextStyle(color: Color(0xff393e54)),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.basicUserInfo["city"].toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _buttonsList(),
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}
