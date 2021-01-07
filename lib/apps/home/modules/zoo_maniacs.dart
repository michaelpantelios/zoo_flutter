import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/home/modules/module_header.dart';
import 'package:zoo_flutter/managers/alert_manager.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/maniacs/level_maniac_record.dart';
import 'package:zoo_flutter/models/maniacs/points_maniac_record.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';

class HomeModuleManiacs extends StatefulWidget {
  HomeModuleManiacs();

  HomeModuleManiacsState createState() => HomeModuleManiacsState();
}

class HomeModuleManiacsState extends State<HomeModuleManiacs> {
  HomeModuleManiacsState();

  RPC _rpc;

  List<Widget> _pointsUsers = new List<Widget>();
  List<Widget> _levelUsers = new List<Widget>();

  double _itemsColumnWidth = 375;
  double _itemWidth = 355;
  double _usernameFieldWidth = 155;

  _openProfile(BuildContext context, int userId) {
    print("_openProfile " + userId.toString());
    if (!UserProvider.instance.logged) {
      PopupManager.instance.show(
          context: context,
          popup: PopupType.Login,
          callbackAction: (res) {
            if (res) {
              print("ok");
              _doOpenProfile(context, userId);
            }
          });
      return;
    }
    _doOpenProfile(context, userId);
  }

  _doOpenProfile(BuildContext context, int userId) {
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId, callbackAction: (retValue) {});
  }

  _onMoreZooManiacs() {
    AlertManager.instance.showSimpleAlert(context: context, bodyText: AppLocalizations.of(context).translate("unavailable_service"));
  }

  @override
  void initState() {
    _rpc = RPC();
    UserProvider.instance.addListener(onUserProviderSessionKey);

    super.initState();
  }

  onUserProviderSessionKey() {
    UserProvider.instance.removeListener(onUserProviderSessionKey);
    if (UserProvider.instance.sessionKey != null) {
      _getTopLevels();
      _getTopPoints();
    }
  }

  _getTopLevels() async {
    var res = await _rpc.callMethod("Points.Main.getUsersByLevel", [
      {"recsPerPage": 4, "page": 1}
    ]);

    if (res["status"] == "ok") {
      var records = res["data"]["records"];
      // print("top levels records.length = "+records.length.toString());
      // print(res["data"]);

      List<Widget> lst = [];
      for (int i = 0; i < records.length; i++) {
        lst.add(getLevelManiacItem(LevelManiacRecord.fromJSON(records[i]), i));
      }

      setState(() {
        _levelUsers = lst;
      });
    } else {
      print("top levels service ERROR");
      print(res["status"]);
    }
  }

  _getTopPoints() async {
    var res = await _rpc.callMethod("Points.Main.getUsersByPoints", [
      {"recsPerPage": 4, "page": 1}
    ]);

    if (res["status"] == "ok") {
      var records = res["data"]["records"];
      // print("top Points records.length = "+records.length.toString());
      // print(res["data"]);
      List<Widget> lst = [];
      for (int i = 0; i < records.length; i++) {
        lst.add(getPointManiacItem(PointsManiacRecord.fromJSON(records[i]), i));
      }
      setState(() {
        _pointsUsers = lst;
      });
    } else {
      print("top points service ERROR");
      print(res["status"]);
    }
  }

  Widget getPointManiacItem(PointsManiacRecord data, int index) {
    bool _hasMainPhoto = false;
    if (data.user.mainPhoto != null) {
      if (data.user.mainPhoto["image_id"] != null) _hasMainPhoto = true;
    }

    return FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          _openProfile(context, int.parse(data.user.userId.toString()));
        },
        child: Container(
            width: _itemWidth,
            height: 60,
            child: Center(
                child: Container(
                    width: _itemWidth - 10,
                    height: 50,
                    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
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
                        Expanded(child: Container()),
                        Text(data.points.toString(), style: TextStyle(color: Color(0xffFF9C00), fontSize: 25))
                      ],
                    )))));
  }

  Widget getLevelManiacItem(LevelManiacRecord data, int index) {
    bool _hasMainPhoto = false;
    if (data.user.mainPhoto != null) {
      if (data.user.mainPhoto["image_id"] != null) _hasMainPhoto = true;
    }

    return FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          _openProfile(context, data.user.userId);
        },
        child: Container(
            width: _itemWidth,
            height: 60,
            child: Center(
                child: Container(
                    width: _itemWidth - 10,
                    height: 50,
                    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
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
                        Expanded(child: Container()),
                        Text(data.level.toString(), style: TextStyle(color: Color(0xffFF9C00), fontSize: 25))
                      ],
                    )))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          // border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getModuleHeader(AppLocalizations.of(context).translate("app_home_module_title_zoo_maniacs"), context),
            Container(
                height: 300,
                child: Row(
                  children: [
                    Container(width: 190, height: 300, decoration: BoxDecoration(color: Color(0xff63ABFF), shape: BoxShape.rectangle, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(9.0))), child: Center(child: Image.asset("assets/images/home/zoomaniacs.png"))),
                    Container(
                        padding: EdgeInsets.all(7),
                        height: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: _itemsColumnWidth,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 3),
                                      child: Text(AppLocalizations.of(context).translate("app_home_module_zoo_maniacs_weekly_zpoints"), style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      child: Column(
                                        children: _pointsUsers,
                                      ),
                                    ),
                                    Container(
                                      width: _itemWidth,
                                      alignment: Alignment.centerRight,
                                      child: FlatButton(
                                          height: 14,
                                          onPressed: () {
                                            _onMoreZooManiacs();
                                          },
                                          child: Text(AppLocalizations.of(context).translate("app_home_more_link"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))),
                                    )
                                  ],
                                )),
                            Container(
                                width: _itemsColumnWidth,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 3),
                                      child: Text(AppLocalizations.of(context).translate("app_home_module_zoo_maniacs_weekly_zlevel"), style: TextStyle(color: Colors.black, fontSize: 18), textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      child: Column(
                                        children: _levelUsers,
                                      ),
                                    ),
                                    Container(
                                      width: _itemWidth,
                                      alignment: Alignment.centerRight,
                                      child: FlatButton(
                                          height: 14,
                                          onPressed: () {
                                            _onMoreZooManiacs();
                                          },
                                          child: Text(AppLocalizations.of(context).translate("app_home_more_link"), style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold))),
                                    )
                                  ],
                                ))
                          ],
                        ))
                  ],
                ))
          ],
        ));
  }
}
