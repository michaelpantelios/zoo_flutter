import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:zoo_flutter/main.dart';
import 'package:zoo_flutter/net/rpc.dart';
import 'package:zoo_flutter/utils/app_localizations.dart';
import 'package:zoo_flutter/apps/zoomaniacs/maniacs_item.dart';
import 'package:zoo_flutter/models/maniacs/points_maniac_record.dart';
import 'package:zoo_flutter/utils/global_sizes.dart';

class PointsManiacs extends StatefulWidget{
  PointsManiacs();

  PointsManiacsState createState() => PointsManiacsState();
}

class PointsManiacsState extends State<PointsManiacs>{
  PointsManiacsState();

  double _controlsHeight = 85;
  int _pointServicePage = 1;
  int _servicePageFactor = 10;

  RPC _rpc;
  int _recsPerPage;

  int _totalPointsResultsNum;
  int _totalPointsPages = 0;

  List<PointsManiacRecord> _pointsManiacsList = [];

  @override
  void initState() {
    super.initState();
    _rpc = RPC();

    _recsPerPage = ((Root.AppSize.height - GlobalSizes.taskManagerHeight - GlobalSizes.appBarHeight - 2 * GlobalSizes.fullAppMainPadding - _controlsHeight) / ManiacsItem.myHeight).floor();
  }

  _getUsersByPoints({bool addMore = false}) async {
    var options = {};
    options["page"] = _pointServicePage;
    options["recsPerPage"] = _recsPerPage * _servicePageFactor;
    options["getCount"] = addMore ? 0 : 1;

    var res = await _rpc.callMethod("Points.Main.getUsersByPoints", []);

    if(res["status"] == "ok"){
      if (res["data"]["count"] != null) {
        _totalPointsResultsNum = res["data"]["count"];
        _totalPointsPages = (res["data"]["count"] / _recsPerPage).ceil();
      }

      var records = res["data"]["records"];
      print("records.length = " + records.length.toString());

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

  }

  _updatePointsPagerData(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


}