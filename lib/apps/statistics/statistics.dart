import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/utils/utils.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/main.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/widgets/z_dropdown_button.dart';
import 'package:zoo_flutter/managers/popup_manager.dart';
import 'package:zoo_flutter/models/statsprofileview/stats_profile_view_record.dart';
import 'package:zoo_flutter/apps/protector/protector.dart';

class Statistics extends StatefulWidget {
  Statistics({this.size});

  final Size size;

  StatisticsState createState() => StatisticsState();
}

class StatisticsState extends State<Statistics>{
  StatisticsState();

  RPC _rpc;

  double _myHeight;

  String _chats = "";
  String _forumPosts = "";
  String _signupDate = "";
  String _loginsNum = "";
  String _lastLoginDate = "";
  String _onlineTime = "";

  String _selectedDateString = "";
  String _newestDateString = "";
  List<String> _dates = [];
  List<Widget> _viewersList = [];
  bool _noViews = false;
  double _itemWidth = 275;
  double _itemHeight = 55;
  double _usernameFieldWidth = 75;

  _doOpenProfile(BuildContext context, int userId) {
    PopupManager.instance.show(context: context, popup: PopupType.Profile, options: userId, callbackAction: (retValue) {});
  }

  @override
  void initState() {
    _myHeight = Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding;
    _rpc = RPC();

    _getUserStats();
    super.initState();
  }

  getDataRow(String label, String data){
    return Container(
      padding: EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 310,
            height: 30,
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),
              textAlign: TextAlign.left,
            )
          ),
          Container(
            height: 30,
            child: Text(
              data,
              style: TextStyle(color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w200
              ),
              textAlign: TextAlign.left,
            )
          )
        ],
      )
    );
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
                height: _itemHeight,
                child: Center(
                    child: Container(
                        width: _itemWidth - 10,
                        height: _itemHeight - 10,
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
                                  ? Image.network(Utils.instance.getUserPhotoUrl(photoId: data.user.mainPhoto["image_id"].toString()), height: 45, width: 45, fit: BoxFit.fitHeight)
                                  : Image.asset(data.user.sex == 1 ? "assets/images/home/maniac_male.png" : "assets/images/home/maniac_female.png", height: 45, width: 45, fit: BoxFit.fitHeight),
                            ),
                            Container(width: _usernameFieldWidth, margin: EdgeInsets.only(left: 5), child: Text(data.user.username, style: TextStyle(color: Color(0xffFF9C00), fontSize: 15), overflow: TextOverflow.ellipsis, maxLines: 1)),
                            Text(AppLocalizations.of(context).translate("app_home_module_profileViews_label"), style: TextStyle(color: Colors.black, fontSize: 12)),
                            Text(data.times.toString(), style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold))
                          ],
                        ))))));
  }

  _getUserStats() async {
    var res = await _rpc.callMethod("OldApps.Stats.getUserStats");

    if (res["status"] == "ok") {
      print(res["data"]);
      var ranks = res["data"]["ranks"];

      _chats = ranks["chatNo"]["value"].toString() + " ("+ranks["chatNo"]["position"].toString()+")";
      _forumPosts = ranks["forumPosts"]["value"].toString() + " ("+ranks["forumPosts"]["position"].toString()+")";
      _signupDate = Utils.instance.getNiceForumDate(dd: res["data"]["createDate"].toString(), hours: false);
      _loginsNum = ranks["logins"]["value"].toString() + " ("+ranks["logins"]["position"].toString() +")";
      _lastLoginDate = Utils.instance.getNiceForumDate(dd : res["data"]["lastLogin"].toString());
      _onlineTime = ranks["onlineTime"]["value"].toString() + " (" + ranks["onlineTime"]["position"].toString() + ")";
      
      List<String> lst = [];
      for (int i = 0; i < res["data"]["viewDates"].length; i++) {
        lst.add(res["data"]["viewDates"][i].toString());
      }
      setState(() {
        _dates = lst;
        _selectedDateString = _dates[0].toString();
        _newestDateString = _dates[0].toString();
      });
      getProfileViewsForDate(date: _selectedDateString.toString());
    } else {
      print("ERROR");
      print(res);
    }
  }

  getProfileViewsForDate({String date, int pay = 0}) async {
    var res = await _rpc.callMethod("OldApps.Stats.getProfileViews", _selectedDateString, pay);

    if (res["status"] == "ok") {
      print("profile Views for date "+Utils.instance.getNiceForumDate(dd: date, hours: false) + " = ");
      print(res["data"]);
      _viewersList.clear();
      List<Widget> _profileViewRows = [];
      int _rows = (res["data"].length / 3).ceil();

      int index = -1;
      for (int i = 0; i < _rows; i++) {
        List<Widget> _rowItems = [];
        for (int j=0; j<3; j++){
          index++;
          if (index < res["data"].length)
            _rowItems.add(getViewerItem(StatsProfileViewRecord.fromJSON(res["data"][index])));
          else _rowItems.add(SizedBox(width: _itemWidth, height: _itemHeight));
        }

        Row row = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _rowItems,
        );

        _profileViewRows.add(row);
      }

      print("_profileViewRows.length = "+_profileViewRows.length.toString());

      setState(() {
        _noViews = _profileViewRows.length == 0;
        _viewersList = _profileViewRows;
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
      color: Color(0xFFffffff),
      width: widget.size.width,
      height: _myHeight,
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: widget.size.width - 20,
              height: 230,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: Color(0xff9597a3),
                    width: 2,
                  )
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getDataRow(AppLocalizations.of(context).translate("app_stats_chat_label"), _chats),
                  getDataRow(AppLocalizations.of(context).translate("app_stats_forum_label"), _forumPosts),
                  getDataRow(AppLocalizations.of(context).translate("app_stats_signup_date_label"), _signupDate),
                  getDataRow(AppLocalizations.of(context).translate("app_stats_logins"), _loginsNum),
                  getDataRow(AppLocalizations.of(context).translate("app_stats_last_login"), _lastLoginDate),
                  getDataRow(AppLocalizations.of(context).translate("app_stats_online_time"), _onlineTime+AppLocalizations.of(context).translate("app_stats_hours"))
                ],
              )
            ),
            SizedBox(height:30),
            Container(
              width: widget.size.width - 20,
              height: 450,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: Color(0xff9597a3),
                    width: 2,
                  )
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context).translate("app_stats_profile_views"),
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.left),
                      SizedBox(width: 20),
                      zDropdownButton(
                          context,
                          "",
                          280,
                          _selectedDateString,
                          _dates.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(Utils.instance.getNiceForumDate(dd: value, hours: false), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                          _onDateChanged),
                    ],
                  ),
                  SizedBox(height: 40),
                  _noViews
                      ? Center(child: Text(AppLocalizations.of(context).translate("app_stats_noViews"), style: Theme.of(context).textTheme.bodyText2))
                      : Container(
                    height: 350,
                    child: ListView(
                      children: _viewersList,
                    )
                  )
                ],
              )

            )
          ],
        ),
      )
    );
  }


}