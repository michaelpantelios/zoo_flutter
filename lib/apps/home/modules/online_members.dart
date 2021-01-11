import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/home/modules/module_header.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/search/search_result_record.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';

class HomeModuleOnlineMembers extends StatefulWidget {
  HomeModuleOnlineMembers();

  HomeModuleOnlineMembersState createState() => HomeModuleOnlineMembersState();
}

class HomeModuleOnlineMembersState extends State<HomeModuleOnlineMembers> {
  HomeModuleOnlineMembersState();
  RPC _rpc;

  List<Widget> _maleMembers = new List<Widget>();
  List<Widget> _femaleMembers = new List<Widget>();

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

  getDataRow(String label, String data, {bool showTooltip = false}) {
    String _dataString = data == null ? "--" : data.toString();
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 1),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
            ),
            Flexible(
                child: showTooltip
                    ? Tooltip(
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
                        child: Text(_dataString, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 11), overflow: TextOverflow.ellipsis, maxLines: 1
                            // softWrap: false,
                            ))
                    : Text(_dataString, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 11), overflow: TextOverflow.ellipsis, maxLines: 1
                        // softWrap: false,
                        ))
          ],
        ));
  }

  Widget getMemberItem(SearchResultRecord info) {
    bool _hasMainPhoto = false;
    if (info.mainPhoto != null) {
      if (info.mainPhoto["image_id"] != null) _hasMainPhoto = true;
    }
    String _teaserString = info.teaser == null ? "" : info.teaser.toString();
    String _countryString = info.me["country"] == null ? "" : Utils.instance.getCountriesNames(context)[int.parse(info.me["country"].toString())].toString();
    return GestureDetector(
        onTap: () {
          _openProfile(context, info.userId);
        },
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
                width: 236,
                height: 120,
                child: Center(
                    child: Container(
                        width: 226,
                        height: 110,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipOval(
                              child: _hasMainPhoto
                                  ? Image.network(Utils.instance.getUserPhotoUrl(photoId: info.mainPhoto["image_id"].toString()), height: 75, width: 75, fit: BoxFit.cover)
                                  : Image.asset(info.me["sex"] == 1 ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 75, width: 75, fit: BoxFit.cover),
                            ),
                            Container(
                                width: 125,
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 2),
                                          child: Text(
                                            info.username,
                                            style: TextStyle(color: Color(0xffFF9C00), fontSize: 15),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )),
                                    ),
                                    getDataRow(AppLocalizations.of(context).translate("app_home_module_online_members_teaser"), _teaserString, showTooltip: true),
                                    getDataRow(AppLocalizations.of(context).translate("app_home_module_online_members_age"), info.me["age"].toString()),
                                    getDataRow(AppLocalizations.of(context).translate("app_home_module_online_members_sex"), Utils.instance.getSexString(context, int.parse(info.me["sex"].toString()))),
                                    getDataRow(AppLocalizations.of(context).translate("app_home_module_online_members_city"), info.me["city"] == null ? "" : info.me["city"]),
                                    getDataRow(AppLocalizations.of(context).translate("app_home_module_online_members_country"), _countryString),
                                  ],
                                ))
                          ],
                        ))))));
  }

  _getOnlineMembers() async {
    var criteria = {
      "onLine": 1,
      "hasPersPhotos": 1,
      "lastLogin": 7,
    };

    var options = {"order": "lastlogin", "recsPerPage": "100", "page": 1};

    var res = await _rpc.callMethod("OldApps.Search.getUsers", criteria, options);

    if (res["status"] == "ok") {
      var records = res["data"]["records"];
      // print("records.length = " + records.length.toString());

      // for(int i=0; i< res["data"]["records"].length; i++){
      //   print("rec: "+i.toString());
      //   print(res["data"]["records"][i]["me"]["country"]);
      // }
      //
      // print(res["data"]);

      List<Widget> maleMembers = [];
      List<Widget> femaleMembers = [];
      int _malesFound = 0;
      int _femalesFound = 0;
      for (int i = 0; i < records.length; i++) {
        SearchResultRecord _rec = SearchResultRecord.fromJSON(records[i]);
        if (int.parse(_rec.me["sex"].toString()) == 1 && _malesFound < 4) {
          _malesFound++;
          maleMembers.add(getMemberItem(_rec));
        } else if (int.parse(_rec.me["sex"].toString()) == 2 && _femalesFound < 4) {
          _femalesFound++;
          femaleMembers.add(getMemberItem(_rec));
        }
      }

      setState(() {
        _maleMembers = maleMembers;
        _femaleMembers = femaleMembers;
      });
    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _rpc = RPC();
    UserProvider.instance.addListener(onUserProviderSessionKey);

    super.initState();
  }

  onUserProviderSessionKey() {
    UserProvider.instance.removeListener(onUserProviderSessionKey);
    if (UserProvider.instance.sessionKey != null) _getOnlineMembers();
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
            getModuleHeader(AppLocalizations.of(context).translate("app_home_module_title_online_members"), context),
            Padding(
                padding: EdgeInsets.all(7),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _femaleMembers,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _maleMembers,
                    )
                  ],
                ))
          ],
        ));
  }
}
