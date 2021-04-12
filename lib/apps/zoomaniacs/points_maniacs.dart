import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/main.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/providers/user_provider.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/zoomaniacs/points_maniacs_item.dart';
import 'package:zoo_flutter/models/maniacs/points_maniac_record.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';
import 'package:zoo_flutter/widgets/z_button.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_html/flutter_html.dart';

class PointsManiacs extends StatefulWidget{
  PointsManiacs({this.myHeight});

  final double myHeight;

  PointsManiacsState createState() => PointsManiacsState();
}

class PointsManiacsState extends State<PointsManiacs>{
  PointsManiacsState();

  double _componentsDistance = 30;
  double _controlsHeight = 80;
  int _currentServicePage = 1;
  int _serviceRecsPerPageFactor = 2;

  RPC _rpc;
  int _recsPerPage;

  int _totalPointsResultsNum;
  int _totalPages = 0;
  int _currentPage = 1;

  List<PointsManiacRecord> _pointsManiacsList = [];

  List<Widget> _rows = [];
  List<GlobalKey<PointsManiacsItemState>> _rowKeys = [];

  GlobalKey<ZButtonState> _btnLeftKey = GlobalKey<ZButtonState>();
  GlobalKey<ZButtonState> _btnRightKey = GlobalKey<ZButtonState>();

  postFrameCallback(_){
    _getUsersByPoints();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);
    super.initState();
    _rpc = RPC();

    _recsPerPage = ((widget.myHeight - 100) / PointsManiacsItem.myHeight).floor();
    print("_recsPerPage = "+_recsPerPage.toString());

    for(int i=0; i<_recsPerPage; i++){
      GlobalKey<PointsManiacsItemState> _key = GlobalKey<PointsManiacsItemState>();
      _rowKeys.add(_key);
      _rows.add(PointsManiacsItem(key: _key));
    }
  }

  _onPreviousPage(){
    _currentPage--;
    _updatePointsPageData();
  }

  _onNextPage(){
    _currentPage++;
    _updatePointsPageData();
  }

  _getUsersByPoints({bool addMore = false}) async {
    var options = {};
    options["page"] = _currentServicePage;
    options["recsPerPage"] = _recsPerPage * _serviceRecsPerPageFactor;
    options["getCount"] = addMore == true ? 0 : 1;

    var res = await _rpc.callMethod("Points.Main.getUsersByPoints", [options]);

    if(res["status"] == "ok"){
      // print(res);
      if (res["data"]["count"] != null) {
        _totalPointsResultsNum = res["data"]["count"];
        _totalPages = (res["data"]["count"] / _recsPerPage).ceil();
      }

      var records = res["data"]["records"];

      if (!addMore) _pointsManiacsList.clear();

      for(int i=0; i<records.length; i++){
        PointsManiacRecord record = PointsManiacRecord.fromJSON(records[i]);
        _pointsManiacsList.add(record);
      }

      if (!addMore)
        _updatePointsPageData();
      else _updatePointsPagerData();

    } else {
      print("ERROR");
      print(res["status"]);
    }
  }

  _updatePointsPageData(){
    for(int i=0; i<_recsPerPage; i++){
      int fetchedManiacsIndex = ((_currentPage - 1) * _recsPerPage) + i;
      if (fetchedManiacsIndex < _pointsManiacsList.length)
        _rowKeys[i].currentState.update(_pointsManiacsList[fetchedManiacsIndex]);
      else _rowKeys[i].currentState.clear();
    }

    if (_currentPage == _currentServicePage * _serviceRecsPerPageFactor
        && _pointsManiacsList.length <= _currentPage * _currentServicePage * _recsPerPage){
      print("reached Max");
      _btnRightKey.currentState.setDisabled(true);
      _currentServicePage++;
      _getUsersByPoints(addMore: true);
    }

    _updatePointsPagerData();
  }

  _updatePointsPagerData(){
    setState(() {
      _btnLeftKey.currentState.setDisabled(_currentPage == 1);
      _btnRightKey.currentState.setDisabled(_currentPage == _totalPages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.myHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
               height: widget.myHeight - 80,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xff9598a4),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(9)
                  )
              ),
              padding: EdgeInsets.all(2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 45,
                      decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)
                          )
                      ),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 10),
                          Text(AppLocalizations.of(context).translate("app_zoomaniacs_zoo_points"),
                            style: TextStyle(color: Color(0xff151922), fontSize: 20, fontWeight: FontWeight.normal),
                            textAlign: TextAlign.left),
                          Text(AppLocalizations.of(context).translateWithArgs("app_zoomaniacs_my_points", [UserProvider.instance.userInfo.points.toString()]),
                              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.left),
                          SizedBox(width: 10),
                        ],
                      )
                  ),
                  Container(
                      height: widget.myHeight - 140,
                      child: Column(
                          children: _rows
                      )
                  ),
                ],
              )
          ),
          Container(
              // height: 50,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ZButton(
                      minWidth: 40,
                      height: 40,
                      key: _btnLeftKey,
                      iconData: Icons.arrow_back_ios,
                      iconColor: Colors.blue,
                      iconSize: 30,
                      clickHandler: _onPreviousPage,
                      startDisabled: true
                  ),
                  Container(
                    height: 40,
                    width: 250,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                            child: Html(data: AppLocalizations.of(context).translateWithArgs(
                                "pager_label", [_currentPage.toString(), _totalPages.toString()]),
                                style: {
                                  "html": Style(
                                      backgroundColor: Colors.white,
                                      color: Colors.black,
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w100),
                                  "b": Style(fontWeight: FontWeight.w700),
                                }))),
                  ),
                  ZButton(
                    minWidth: 40,
                    height: 40,
                    key: _btnRightKey,
                    iconData: Icons.arrow_forward_ios,
                    iconColor: Colors.blue,
                    iconSize: 30,
                    clickHandler: _onNextPage,
                    startDisabled: true,
                  )
                ],
              )
          )
        ],
      )
    );
  }


}