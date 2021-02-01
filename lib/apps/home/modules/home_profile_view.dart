import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/apps/home/modules/module_header.dart';
import 'package:zoo_flutter/apps/protector/protector.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/statsprofileview/stats_profile_view_record.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/widgets/z_dropdown_button.dart';

class HomeModuleProfileView extends StatefulWidget {
  HomeModuleProfileView();

  HomeModuleProfileViewState createState() => HomeModuleProfileViewState();
}

class HomeModuleProfileViewState extends State<HomeModuleProfileView> {
  HomeModuleProfileViewState();

  RPC _rpc;

  List<String> _dates = [];
  String _selectedDateString = "";
  String _newestDateString = "";
  List<Widget> _viewersList = [];
  bool _noViews = false;
  double _itemWidth = 290;
  double _usernameFieldWidth = 75;

  _doOpenProfile(BuildContext context, int userId) {
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId, callbackAction: (retValue) {});
  }

  @override
  void initState() {
    _rpc = RPC();
    getProfileViewDates();
    super.initState();
  }

  getViewerItem(StatsProfileViewRecord data) {
    bool _hasMainPhoto = false;
    if (data.user.mainPhoto != null) {
      if (data.user.mainPhoto["image_id"] != null) _hasMainPhoto = true;
    }

    return GestureDetector(
        onTap: () {
          _doOpenProfile(context, int.parse(data.user.userId.toString()));
        },
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
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
                            ClipOval(
                              child: _hasMainPhoto
                                  ? Image.network(Utils.instance.getUserPhotoUrl(photoId: data.user.mainPhoto["image_id"].toString()), height: 45, width: 45, fit: BoxFit.fitWidth)
                                  : Image.asset(data.user.sex == 1 ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 45, width: 45, fit: BoxFit.fitWidth),
                            ),
                            Container(width: _usernameFieldWidth, margin: EdgeInsets.only(left: 5), child: Text(data.user.username, style: TextStyle(color: Color(0xffFF9C00), fontSize: 15), overflow: TextOverflow.ellipsis, maxLines: 1)),
                            Text(AppLocalizations.of(context).translate("app_home_module_profileViews_label"), style: TextStyle(color: Colors.black, fontSize: 12)),
                            Text(data.times.toString(), style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold))
                          ],
                        ))))));
  }

  getProfileViewDates() async {
    var res = await _rpc.callMethod("OldApps.Stats.getUserStats");

    if (res["status"] == "ok") {
      print("viewDates = ");
      print(res["data"]["viewDates"]);
      List<String> lst = [];
      for (int i = 0; i < res["data"]["viewDates"].length; i++) {
        lst.add(res["data"]["viewDates"][i].toString());
      }
      setState(() {
        _dates = lst;
        if (_dates.length > 0){
          _selectedDateString = _dates[0].toString();
          _newestDateString = _dates[0].toString();
        }
      });
      if (_dates.length > 0)
        getProfileViewsForDate(date: _selectedDateString.toString());
    } else {
      print("ERROR");
      print(res);
    }
  }

  getProfileViewsForDate({String date, int pay = 0}) async {
    var res = await _rpc.callMethod("OldApps.Stats.getProfileViews", _selectedDateString, pay);

    if (res["status"] == "ok") {
      print("profile Views = ");
      print(res["data"]);
      List<Widget> lst = [];
      _viewersList.clear();
      for (int i = 0; i < res["data"].length; i++) {
        if (i < 3) lst.add(getViewerItem(StatsProfileViewRecord.fromJSON(res["data"][i])));
      }

      setState(() {
        _noViews = lst.length == 0;
        _viewersList = lst;
        _selectedDateString = date;
      });
    } else {
      print("ERROR");
      print(res);
    }
  }

  _onDateChanged(String date) {
    if (date != _newestDateString) {
      PopupManager.instance.show(context: context, options: CostTypes.oldStats, popup: PopupType.Protector, callbackAction: (retVal) => {if (retVal == "ok") getProfileViewsForDate(date: date, pay: 1)});
    } else
      getProfileViewsForDate(date: date, pay: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 285,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          // border: Border.all(color: Colors.deepOrange, width: 3),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getModuleHeader(AppLocalizations.of(context).translate("app_home_module_title_profile_views"), context),
            Padding(
                padding: EdgeInsets.all(7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    zDropdownButton(
                        context,
                        "",
                        280,
                        _selectedDateString,
                        _dates.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(Utils.instance.getNiceForumDate(dd: value, hours: false), style: TextStyle(color: Colors.black, fontSize: 16)),
                          );
                        }).toList(),
                        _onDateChanged),
                    SizedBox(height: 10),
                    _noViews
                        ? Center(child: Text(AppLocalizations.of(context).translate("app_home_module_profileViews_noViews"), style: TextStyle()))
                        : Container(
                            width: _itemWidth,
                            height: 180,
                            child: Column(
                              children: _viewersList,
                            ))
                  ],
                ))
          ],
        ));
  }
}
